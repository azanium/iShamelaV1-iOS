//
//  TOCViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TOCViewController.h"
#import "DBManager.h"
#import "TOC.h"
#import "Book.h"
#import "AppManager.h"
#import "ChapterViewController.h"
#import "WebViewController.h"
#import "nCell.h"
#import "RootViewController.h"
#import "RootViewController_iPad.h"
#import "DetailViewController.h"


@implementation TOCViewController

@synthesize aTableView;
@synthesize book, rootViewController;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/

#pragma mark -
#pragma mark DBManager

- (NSInteger)calcVisibilities:(NSMutableArray *)list
{
	if ([list count] == 0)
	{
		return 0;
	}
	
	if (visibleCount > [list count])
	{
		visibleCount = [list count];
	}
	remainderCount = [list count] - visibleCount;
	
	return visibleCount > 0 ? visibleCount + (remainderCount > 0 ? 1 : 0) : 0;
}

-(NSInteger) calcFilteredVisibilities:(NSMutableArray *)list
{
	if ([list count] == 0)
	{
		return 0;
	}
	
	if (visibleFilteredCount > [list count])
	{
		visibleFilteredCount = [list count];
	}
	remainderFilteredCount = [list count] - visibleFilteredCount;
	
	return visibleCount > 0 ? visibleFilteredCount + (remainderFilteredCount > 0 ? 1 : 0) : 0;
}

-(void) dbPrepare:(DBManager *)manager
{
	if (manager == dbManager)
	{
		RootViewController *parent = (RootViewController *)self.parentViewController;
		
		[actionSheet showInView:parent.view];
	}
}

-(void) dbFinalize:(DBManager *)manager
{
	if (manager == dbManager)
	{
		visibleCount = [AppManager getDefaultIncreaseCount];
		visibleFilteredCount = [AppManager getDefaultIncreaseCount];
		[self calcVisibilities:dataList];
		[self calcFilteredVisibilities:dataListFiltered];
		
		increaseStep = [AppManager getDefaultIncreaseCount];
		
		[self.aTableView reloadData];
		
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

-(BOOL) dbGotRecord:(DBManager *)manager Statement:(sqlite3_stmt *)stmt Object:(NSObject *)data
{
	if (manager == dbManager)
	{
		const char *bkId = (char *)sqlite3_column_text(stmt, 0);
		const char *bookTitle = (char *)sqlite3_column_text(stmt, 1);
		const char *bookLevel = (char *)sqlite3_column_text(stmt, 2);
		const char *bookSub = (char *)sqlite3_column_text(stmt, 3);
		
		TOC *toc = [TOC TOCWithId:(char *)bkId Title:(char *)bookTitle Level:(char *)bookLevel Sub:(char *)bookSub];
		
		[dataList addObject:toc];
		
		[toc release];
	}
	
	return YES;
}


- (void) reloadDB
{
	// Fetch the database asynchronously
	[dbManager fetchRecordsAsync:self.book.fileName 
						   Query:[NSString stringWithFormat:@"SELECT * FROM t%@", self.book.bkId]];
	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
#if defined(LITE_VERSION)
	self.contentView = aTableView;
	[super createAdOnTop:YES];
#endif
	
	[self.searchDisplayController.searchBar setTintColor:[AppManager getDefaultTintColor]];
		
	NSString *loadingStr = NSLocalizedString(@"Loading...", @"Loading...");
	actionSheet = [[UIActionSheet alloc] initWithTitle:loadingStr 
											  delegate:nil 
									 cancelButtonTitle:nil 
								destructiveButtonTitle:nil 
									 otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

	dataList = [[NSMutableArray alloc] init];
	dataListFiltered = [[NSMutableArray alloc] init];
	
	self.title = self.book.bookName;

		
	dbManager = [[DBManager alloc] init];
	[dbManager setDelegate:self];
	
	[self reloadDB];
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		self.navigationController.toolbarHidden = YES;
		[UIView commitAnimations];
	}
	
	[AppManager setDefaultView:TOC_VIEW];
		
	//[self switchDefaultView];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];

		self.navigationController.toolbarHidden = NO;
	
		[UIView commitAnimations];
	}
	
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Content Filtering

- (void) filterContentForSearchText: (NSString *)searchText scope: (NSString *)scope {
	
	[dataListFiltered removeAllObjects];
			
	for (TOC *Toc in dataList) {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		int level = 0;
		
		if ([scope isEqualToString: NSLocalizedString(@"Book", @"Book TOC")]) {
			level = 1;
		} 
		else if ([scope isEqualToString: NSLocalizedString(@"Chapter", @"Chapter TOC")]) {
			level = 2;
		}
		
		NSRange range = [Toc.bookTitle rangeOfString: searchText];
		
		if (level == 0) {
			if (range.location != NSNotFound) {
				[dataListFiltered addObject: Toc];
			}
		} else {
			if (range.location != NSNotFound && [[Toc bookLevel] intValue] == level) {
				[dataListFiltered addObject: Toc];
			}
		}
		
		
		[pool release];
		
	}
	
}

#pragma mark -
#pragma mark UISearchDisplayDelegate Delegate Methods

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	
	[self filterContentForSearchText: searchString scope: 
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex: [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
	
	return YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	
	[self filterContentForSearchText: [self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex: searchOption]];
	return YES;
}


#pragma mark -
#pragma mark Table view data source


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TOC *myTOC = nil;
	UIFont *cellFont = nil;
	NSString *bookTitle;

	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		if (indexPath.row < visibleCount)
		{
			myTOC = [dataListFiltered objectAtIndex:indexPath.row];
			bookTitle = myTOC.bookTitle;
		}
		
		if (indexPath.row >= visibleCount && remainderCount > 0 && [dataListFiltered count] > 0)
		{
			bookTitle = NSLocalizedString(@"More", @"More");;
		}
	}
	else 
	{
		if (indexPath.row < visibleCount)
		{
			myTOC = [dataList objectAtIndex:indexPath.row];
			bookTitle = myTOC.bookTitle;
		}
		
		if (indexPath.row >= visibleCount && remainderCount > 0 && [dataList count] > 0)
		{
			bookTitle = NSLocalizedString(@"More", @"More Table Rows");;
		}
	}
	
	
	cellFont = [UIFont fontWithName:@"Helvetica" size:DEFAULT_FONT_SIZE];
	
	CGRect bounds = tableView.frame;
	
	CGSize constraintSize = CGSizeMake(bounds.size.width, MAXFLOAT);
	CGSize labelSize = [bookTitle sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	

	return labelSize.height + 25;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		return [self calcFilteredVisibilities:dataListFiltered];
	}
		
    return [self calcVisibilities:dataList];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"iShamela.TOCViewController";
    	

    UITableViewCell *cell = (nCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	TOC *toc = nil;
    	
	int level = 0;
	
	BOOL isMore = NO;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		if (indexPath.row < visibleFilteredCount)
		{
			toc = [dataListFiltered objectAtIndex:indexPath.row];
			
			level = [toc.bookLevel intValue] - 1;
			cell.textLabel.text = toc.bookTitle;

			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		
		if (remainderFilteredCount > 0 && indexPath.row >= visibleFilteredCount && [dataListFiltered count] > 0)
		{
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.textColor = [UIColor blackColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
			isMore = YES;
		}
																	
	}
	else 
	{
		if (indexPath.row < visibleCount)
		{
			toc = [dataList objectAtIndex:indexPath.row];

			cell.textLabel.text = toc.bookTitle;

			level = [toc.bookLevel intValue] - 1;
			
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

		}
		
		if (remainderCount > 0 && indexPath.row >= visibleCount && [dataList count] > 0)
		{
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.textColor = [UIColor blackColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
			isMore = YES;
		}
	}
	
	CGRect bounds = cell.contentView.bounds;			
	float offset = level == 0 ? 15 : 30;
	CGRect f = CGRectMake(0, 0, bounds.size.width - offset, bounds.size.height);
	UIColor *color = level == 0 ? [UIColor blackColor] : [UIColor darkGrayColor];
	
	cell.textLabel.frame = f;
	cell.textLabel.textColor = isMore ? [UIColor redColor] : color;
	cell.textLabel.font = level == 0 ? [AppManager getDefaultFont] : [AppManager getDefaultFont];
	cell.textLabel.textAlignment = isMore ? UITextAlignmentCenter : UITextAlignmentRight;
	cell.textLabel.numberOfLines = 0;
    	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)findBookIds:(NSInteger)index List:(NSMutableArray *)list StartID:(NSString **)startId EndID:(NSString **)endId
{
	TOC *startTOC = [list objectAtIndex:index];
	int level = [startTOC.bookLevel intValue];
	
	*startId = startTOC.bookId;
	
	if (index >= [list count] - 1)
	{
		*endId = startTOC.bookId;
	}
	else {
		TOC *endTOC = nil;
		for (int i = index + 1; i < [list count] - 1; i++)
		{
			TOC *toc = [list objectAtIndex:i];
			
			if ([toc.bookLevel intValue] <= level)
			{
				endTOC = toc;
				break;
			}
		}
		
		 //= [dataList objectAtIndex:index + 1];
		*endId = endTOC.bookId;
	}

	[AppManager setDefaultDBFileName:book.fileName];
	[AppManager setDefaultBookId:book.bkId];
	[AppManager setDefaultDBStartId:*startId];
	[AppManager setDefaultDBEndId:*endId];
}

- (void)pushChapterControllerWithStartID:(NSString *)startId EndID:(NSString *)endId Title:(NSString *)title 
{
	NSString *nibName = @"ChapterView_iPhone";
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		//nibName = @"ChapterView_iPad";
	}
	
	ChapterViewController *cvc = [[ChapterViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
	cvc.startID = startId;
	cvc.endID = endId;
	cvc.book = book;
	cvc.title = title;
	cvc.rootViewController = self.rootViewController;
	[self.navigationController pushViewController:cvc animated:YES];
	[cvc release], cvc = nil;
}

- (void)pushWebViewControllerWithStartID:(NSString *)startId EndID:(NSString *)endId Title:(NSString *)title
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		NSString *nibName = @"WebView_iPhone";
		
		WebViewController *wvc = [[WebViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
		wvc.startID = startId;
		wvc.endID = endId;
		wvc.book = book;
		wvc.titleText = title;
		wvc.loadDB = YES;
		[self.navigationController pushViewController:wvc animated:YES];
		//	[wvc release], wvc = nil;
	}
	else 
	{
		RootViewController_iPad *root = (RootViewController_iPad *)self.rootViewController;
		
		if ([self.rootViewController isKindOfClass:RootViewController_iPad.class] == NO)
		{
			NSLog(@"Shit");
		}
		
		[root.detailViewController queryWithStartWithBook:book StartID:startId EndID:endId];
	}
}

- (void)switchDefaultView
{
	NSString *startId;
	NSString *endId;

	startId = [AppManager getDefaultDBStartId];
	endId = [AppManager getDefaultDBEndId];

	if (startId != nil && endId != nil)
	{
		if ([AppManager getDefaultAppView] == CHAPTER_VIEW)
		{
			[actionSheet dismissWithClickedButtonIndex:0 animated:NO];
			[self pushChapterControllerWithStartID:startId EndID:endId Title:@"Test"];
		}
		
		if ([AppManager getDefaultAppView] == CONTENT_VIEW)
		{
			
		}
	}
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSString *startId;
	NSString *endId;

	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		if (indexPath.row < visibleFilteredCount)
		{
			TOC *toc = [dataListFiltered objectAtIndex:indexPath.row];
			NSInteger index = [dataList indexOfObject:toc];
						
			[self findBookIds:index List:dataList StartID:&startId EndID:&endId];
			
			[self pushChapterControllerWithStartID:startId EndID:endId Title:toc.bookTitle];
		}
	}
	else
	{
		if (indexPath.row < visibleCount)
		{
			[self findBookIds:indexPath.row List:dataList StartID:&startId EndID:&endId];
		
			TOC *toc = [dataList objectAtIndex:indexPath.row];
			
			[self pushChapterControllerWithStartID:startId EndID:endId Title:toc.bookTitle];
		}
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *startId;
	NSString *endId;
	
	TOC *toc;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		if (indexPath.row < visibleFilteredCount)
		{
			TOC *toc = [dataListFiltered objectAtIndex:indexPath.row];
			NSInteger index = [dataList indexOfObject:toc];
			
			[self findBookIds:index List:dataList StartID:&startId EndID:&endId];
			
			[self pushWebViewControllerWithStartID:startId EndID:endId Title:toc.bookTitle];
		}
		
		if (remainderFilteredCount > 0 && indexPath.row >= visibleFilteredCount)
		{
			visibleFilteredCount += increaseStep;
			[self calcFilteredVisibilities:dataListFiltered];
			[tableView reloadData];
		}
	}
	else
	{
		if (indexPath.row < visibleCount)
		{
			[self findBookIds:indexPath.row List:dataList StartID:&startId EndID:&endId];
			
			toc = [dataList objectAtIndex:indexPath.row];
			
			[self pushWebViewControllerWithStartID:startId EndID:endId Title:toc.bookTitle];
			
		}
		
		if (remainderCount > 0 && indexPath.row >= visibleCount)
		{
			visibleCount += increaseStep;
			[self calcVisibilities:dataList];
			[tableView reloadData];
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
	[dataListFiltered removeAllObjects];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;

	dataListFiltered = nil;
	self.rootViewController = nil;
}


- (void)dealloc {
	[dataList release];
	[dbManager release];
	[dataListFiltered release];
	[book release];
	[actionSheet release];
	[rootViewController release];
	
    [super dealloc];
}


@end

