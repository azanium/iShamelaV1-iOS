//
//  ChapterViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "ChapterViewController.h"
#import "Book.h"
#import "BookContent.h"
#import "DBManager.h"
#import "AppManager.h"
#import "WebViewController.h"
#import "RootViewController_iPad.h"
#import "DetailViewController.h"

@implementation ChapterViewController

@synthesize aTableView;
@synthesize startID, endID;
@synthesize book, rootViewController;


#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark DB Manager

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
	
	return visibleFilteredCount > 0 ? visibleFilteredCount + (remainderFilteredCount > 0 ? 1 : 0) : 0;
}

-(void) dbPrepare:(DBManager *)manager
{
	if (manager == dbManager)
	{
		[dataList removeAllObjects];
		[dataListFiltered removeAllObjects];
		[actionSheet showInView:self.view];
	}
}

- (void) dbFinalize:(DBManager *)manager
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
		const char *bookID = (char *)sqlite3_column_text(stmt, 0);
		const char *bookNass = (char *)sqlite3_column_text(stmt, 1);
		const char *bookPart = (char *)sqlite3_column_text(stmt, 2);
		const char *bookPage = (char *)sqlite3_column_text(stmt, 3);
		const char *bookHNo = (char *)sqlite3_column_text(stmt, 4);
		
		BookContent *content = [BookContent bookWithId:(char *)bookID Nash:(char *)bookNass Part:(char *)bookPart Page:(char *)bookPage HNo:(char *)bookHNo];
		
		[dataList addObject:content];
	}
	
	return YES;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
#if defined(LITE_VERSION)
	self.contentView = aTableView;
	[super createAdOnTop:NO];
#endif
	
	[self.searchDisplayController.searchBar setTintColor:[AppManager getDefaultTintColor]];

	NSString *loadingStr = NSLocalizedString(@"Loading...", @"Loading...");
	actionSheet = [[UIActionSheet alloc] initWithTitle:loadingStr delegate:nil cancelButtonTitle:nil 
								destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	dataList = [[NSMutableArray alloc] init];
	dataListFiltered = [[NSMutableArray alloc] init];
	
	[AppManager hideTableViewFooter:self.aTableView];
	
	dbManager = [[DBManager alloc] init];
	[dbManager setDelegate:self];
	
	if ([startID isEqualToString:endID])
	{
		[dbManager fetchRecordsAsync:book.fileName Query:[NSString stringWithFormat:
														  @"SELECT * FROM b%@ WHERE id=%@",
														  book.bkId, startID]];		
	}
	else {
		[dbManager fetchRecordsAsync:book.fileName Query:[NSString stringWithFormat:
														  @"SELECT * FROM b%@ WHERE id>=%@ AND id<%@",
														  book.bkId, startID, endID]];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		self.navigationController.toolbarHidden = YES;
		[UIView commitAnimations];
	}
	
	[AppManager setDefaultView:CHAPTER_VIEW];

	[super viewWillAppear:animated];
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}



#pragma mark -
#pragma mark Table view data source

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row % 2 == 0) {
		cell.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
		//cell.textLabel.textColor = [UIColor blackColor];
	} else {
		cell.backgroundColor = [UIColor whiteColor];// colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
		//cell.textLabel.textColor = [UIColor darkGrayColor];
	}	
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BookContent *content = nil;
	UIFont *cellFont = nil;
	NSString *bookTitle = @"";

	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		if (indexPath.row < visibleFilteredCount)
		{
			content = [dataListFiltered objectAtIndex:indexPath.row];
			bookTitle = [AppManager getCharsPerRow:content.nash];
		}
		
		if (remainderFilteredCount > 0 && indexPath.row >= visibleFilteredCount)
		{
			bookTitle = NSLocalizedString(@"More", @"More Table Rows");;
		}
	}
	else 
	{
		if (indexPath.row < visibleCount)
		{
			content = [dataList objectAtIndex:indexPath.row];
			bookTitle = [AppManager getCharsPerRow:content.nash];
		}		

		if (remainderCount > 0 && indexPath.row >= visibleCount)
		{
			bookTitle = NSLocalizedString(@"More", @"More Table Rows");;
		}
		
	}
		
	cellFont = [UIFont fontWithName:@"Verdana" size:15];
	
	CGRect bounds = tableView.frame;
	
	CGSize constraintSize = CGSizeMake(bounds.size.width, MAXFLOAT);
	CGSize labelSize = [bookTitle sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	
	return labelSize.height + 50;
	
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
	
    NSInteger c = [self calcVisibilities:dataList];
	
	return c;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChapterViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	BookContent *content = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		content = [dataListFiltered objectAtIndex:indexPath.row];
	}
	else
	{
		content = [dataList objectAtIndex:indexPath.row];
	}
	
	cell.textLabel.text = [AppManager getCharsPerRow:content.nash];
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.textAlignment = UITextAlignmentRight;
	cell.textLabel.font = [AppManager getDefaultFont];

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

- (void)pushWebViewControllerWithTitle:(NSString *)title PageIndex:(NSInteger)pageIndex
{	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		NSString *nibName = @"WebView_iPhone";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			nibName = @"WebView_iPad";
		}
		
		WebViewController *wvc = [[WebViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
		wvc.book = book;
		wvc.titleText = title;
		wvc.dataList = dataList;
		wvc.loadDB = NO;
		wvc.pageIndex = pageIndex;
		[self.navigationController pushViewController:wvc animated:YES];
		//[wvc release], wvc = nil;
	}
	else 
	{
		RootViewController_iPad *root = (RootViewController_iPad *)self.rootViewController;
	
		[root.detailViewController queryWithPageIndex:pageIndex DataList:dataList];		
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	BookContent *content;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		content = [dataListFiltered objectAtIndex:indexPath.row];
		int index = [dataList indexOfObject:content];
		
		[self pushWebViewControllerWithTitle:self.title PageIndex:index + 1];
	}
	else 
	{
		[self pushWebViewControllerWithTitle:self.title PageIndex:indexPath.row + 1];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Content Filtering

- (void) filterContentForSearchText: (NSString *)searchText scope: (NSString *)scope {
	
	[dataListFiltered removeAllObjects];
		
	for (BookContent *content in dataList) {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				
		NSRange range = [content.nash rangeOfString: searchText];
		
		if (range.location != NSNotFound) {
			[dataListFiltered addObject: content];
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
	[startID release];
	[endID release];
	[dataList release];
	[dbManager release];
	[dataListFiltered release];
	[book release];
	[actionSheet release];
	[rootViewController release];
	
    [super dealloc];
}


@end

