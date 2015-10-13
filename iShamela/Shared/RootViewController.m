//
//  RootViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 Aza. All rights reserved.
//

#import <sqlite3.h>

#import "RootViewController.h"
#import "RootViewController_iPad.h"
#import "DBManager.h"
#import "Book.h"
#import "nCell.h"
#import "AppManager.h"
#import "AboutViewController.h"
#import "TOCViewController.h"
#import "WifiSharingViewController.h"
#import "BookSearchInfo.h"
#import "TOC.h"
#import "nArray.h"
#import "BookContent.h"
#import "BookDetailViewController.h"
#import "WebViewController.h"
#import "RootViewController_iPad.h"
#import "DetailViewController.h"
#import "BookSelectionViewController.h"
#import "StoreViewController.h"

@implementation RootViewController


@synthesize aTableView;


#pragma mark -
#pragma mark Shopping

- (void)shopping
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		StoreViewController *storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreView" bundle:[NSBundle mainBundle]];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:storeViewController];
		
		[self.navigationController presentModalViewController:navController animated:YES];
		
		[navController release], navController = nil;
		[storeViewController release], storeViewController = nil;
	}
}

#pragma mark -
#pragma mark Toolbar Actions 

- (void)wifiSharing
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		WifiSharingViewController *wvc = [[WifiSharingViewController alloc] initWithNibName:@"WifiSharingView" bundle:[NSBundle mainBundle]];
		wvc.rootViewController = self;
		
		UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:wvc];
		
		[self.navigationController presentModalViewController:nvc animated:YES];
		[nvc release];
		[wvc release];
	}
}

- (void)bookSelection
{
	BookSelectionViewController *bvc = [[BookSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
	bvc.bookList = bookList;
	
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:bvc];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{		
		[self.navigationController presentModalViewController:nvc animated:YES];		
	}
	else {
	
		nvc.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController:nvc animated:YES];
	}
	
	[nvc release];
	[bvc release];

}

#pragma mark -
#pragma mark DB Delegate

- (void) reloadBooks
{
	[dbManager fetchAllDbInfo:@"SELECT * FROM Main"];
}

- (void) dbPrepare:(DBManager *)manager
{
	if (manager == dbManager)
	{
		[bookList removeAllObjects];
	}
	
	if (manager == dbTOC)
	{
		[dataListFiltered removeAllObjects];
	}
	
	if (manager == dbContent)
	{
		[dataListFiltered removeAllObjects];
	}

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		RootViewController_iPad *root = (RootViewController_iPad *)self;
		[root.detailViewController.activityView startAnimating];
	}
	else 
	{
		[activityView startAnimating];
	}
}

- (void) dbFinalize:(DBManager *)manager
{
	if (manager == dbManager)
	{
		[self.aTableView reloadData];
		
		for (Book *book in bookList)
		{
			book.selected = [AppManager getBoolForKey:book.bookName];
		}		
	}
	
	if (manager == dbTOC)
	{
		dataListFiltered.visibleCount = [AppManager getDefaultIncreaseCount];
		increaseStep = [AppManager getDefaultIncreaseCount];
				
		[self.searchDisplayController.searchResultsTableView reloadData];
	}
	
	if (manager == dbContent)
	{
		dataListFiltered.visibleCount = [AppManager getDefaultIncreaseCount];
		increaseStep = [AppManager getDefaultIncreaseCount];
		
		[self.searchDisplayController.searchResultsTableView reloadData];
	}
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		RootViewController_iPad *root = (RootViewController_iPad *)self;
		[root.detailViewController.activityView stopAnimating];
	}
	else 
	{
		[activityView stopAnimating];
	}
}

-(BOOL) dbGotRecord:(DBManager *)manager Statement:(sqlite3_stmt *)statement Object:(NSObject *)data
{
	if (manager == dbTOC)
	{
		const char *bkId = (char *)sqlite3_column_text(statement, 0);
		const char *bookTitle = (char *)sqlite3_column_text(statement, 1);
		const char *bookLevel = (char *)sqlite3_column_text(statement, 2);
		const char *bookSub = (char *)sqlite3_column_text(statement, 3);
		
		Book *book = (Book *)data;
		TOC *toc = [TOC TOCWithId:(char *)bkId Title:(char *)bookTitle Level:(char *)bookLevel Sub:(char *)bookSub];
		
		BookSearchInfo *info = [BookSearchInfo bookWithScopeIndex:TOC_SCOPE Book:book toc:toc content:nil];
		
		[dataListFiltered addObject:info];
		[info release];
	}
	
	if (manager == dbContent)
	{
		const char *bookID = (char *)sqlite3_column_text(statement, 0);
		const char *bookNass = (char *)sqlite3_column_text(statement, 1);
		const char *bookPart = (char *)sqlite3_column_text(statement, 2);
		const char *bookPage = (char *)sqlite3_column_text(statement, 3);
		const char *bookHNo = (char *)sqlite3_column_text(statement, 4);
		
		BookContent *content = [BookContent bookWithId:(char *)bookID Nash:(char *)bookNass Part:(char *)bookPart Page:(char *)bookPage HNo:(char *)bookHNo];

		Book *book = (Book *)data;
		
		BookSearchInfo *info = [BookSearchInfo bookWithScopeIndex:CONTENT_SCOPE Book:book toc:nil content:content];
		
		[dataListFiltered addObject:info];
		[info release];
	}
	
	return YES;
}

- (BOOL)dbGotBookInfoRecord:(DBManager *)manager Statement:(sqlite3_stmt *)statement
{
	if (manager == dbManager)
	{
		const char *bkId = (char *)sqlite3_column_text(statement, 0);
		const char *bk = (char *)sqlite3_column_text(statement, 1);
		const char *betaka = (char *)sqlite3_column_text(statement, 2);
		const char *info = (char *)sqlite3_column_text(statement, 3);
		const char *author = (char *)sqlite3_column_text(statement, 4);
		const char *authorInfo = (char *)sqlite3_column_text(statement, 5);
		const char *tafseerName = (char *)sqlite3_column_text(statement, 6);
		const char *islamShort = (char *)sqlite3_column_text(statement, 7);
		
		Book *book = [Book bookWithFileName:manager.dbFileName BookId:(char *)bkId BookName: (char *)bk Betaka: (char *)betaka Info: (char *)info Author: (char *)author
								 AuthorInfo: (char *)authorInfo TafseerName: (char *)tafseerName IslamShort: (char *)islamShort];
		
		[bookList addObject: book];
		[book release];
	}
		
	return YES;
}

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
#pragma mark View lifecycle

- (void) setEditing:(BOOL)editing animated:(BOOL)animated 
{
	[super setEditing:editing animated:YES];
	[aTableView setEditing:editing animated:YES];
}

- (void)displaySettings
{
}

- (void)displayAbout
{
	AboutViewController *avc = [[AboutViewController alloc] init];
	avc.isDefault = YES;
	
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:avc];

	[self.navigationController presentModalViewController:nvc animated:YES];
	
	[nvc release];
	[avc release];
}

- (void)hideEmptySeparators {
	UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
	view.backgroundColor = [UIColor clearColor];
	//[self.tableView setTableHeaderView:view];
	[self.aTableView setTableFooterView:view];
	[view release];
}

- (void) displayTOC:(NSInteger)row animate:(BOOL)isAnimate
{
	NSString *nibName = @"TOCView_iPhone";
	
	TOCViewController *tc = [[TOCViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
	
	tc.rootViewController = self;
	
	tc.book = [bookList objectAtIndex:row];
	[self.navigationController pushViewController:tc animated:isAnimate];
	[tc release], tc = nil;	
}

- (void)prepareToolbar
{
	UIBarButtonItem *flexi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixed.width = 32;
	
	UIBarButtonItem *about = [[UIBarButtonItem alloc] init];
	about.target = self; about.action = @selector(displayAbout);
	about.image = [UIImage imageNamed:@"iPhone_Help.png"];
	
	UIBarButtonItem *settings = [[UIBarButtonItem alloc] init];
	settings.target = self; settings.action = @selector(displaySettings);
	settings.image = [UIImage imageNamed:@"iPhone_Settings.png"];
		
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] init];
	bookmark.image = [UIImage imageNamed:@"bookmarkStar-16.png"];
	bookmark.target = self; bookmark.action = @selector(bookSelection);

	UIBarButtonItem *shopping = [[UIBarButtonItem alloc] init];
	shopping.image = [UIImage imageNamed:@"shopping_trolley-32.png"];
	shopping.target = self; shopping.action = @selector(shopping);
	
	self.navigationItem.rightBarButtonItem = bookmark;
	
#if defined(LITE_VERSION)
	self.toolbarItems = [NSArray arrayWithObjects:shopping, flexi, activityButton, about, nil];
#else
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *wifi = [[UIBarButtonItem alloc] init];
	wifi.target = self; wifi.action = @selector(wifiSharing);
	wifi.image = [UIImage imageNamed:@"wireless32.png"];
	
	self.toolbarItems = [NSArray arrayWithObjects:wifi, shopping, flexi, activityButton, about, nil];
	[wifi release];
	[fixed release];
	
#endif

	[shopping release];
	[flexi release], [about release];
	[activityButton release];
	[bookmark release];
}

- (void)switchDefaultView
{
	if ([AppManager getDefaultAppView] > 0)
	{		
		[self displayTOC:[AppManager getDefaultTOCRow] animate:NO];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
#if defined(LITE_VERSION)
	self.contentView = aTableView;
	self.currentViewController = self;
	[super createAdOnTop:NO];
#endif
	
	[self prepareToolbar];
	[self hideEmptySeparators];

	self.navigationController.navigationBar.tintColor = [AppManager getDefaultTintColor];
	self.searchDisplayController.searchBar.tintColor = [AppManager getDefaultTintColor];
	
	self.title = NSLocalizedString(@"iShamela Library", @"iShamela App Name");
	self.aTableView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
	
	image = [UIImage imageNamed:@"BookBlue-32.png"];
	bookList = [[NSMutableArray alloc] init];
	dataListFiltered = [[nArray alloc] initWithVisibleCount:[AppManager getDefaultIncreaseCount]];
		
	increaseStep = [AppManager getDefaultIncreaseCount];
	
	dbBook = [[DBManager alloc] init];
	dbBook.delegate = self;
	
	dbTOC = [[DBManager alloc] init];
	dbTOC.delegate = self;
	
	dbContent = [[DBManager alloc] init];
	dbContent.delegate = self;
	
	dbManager = [[DBManager alloc] init];
	[dbManager setDelegate:self];
	
	[self reloadBooks];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		self.navigationController.toolbar.tintColor = [AppManager getDefaultTintColor];
	}
	
	[AppManager setDefaultView:HOME_VIEW];
	//[self switchDefaultView];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		//self.navigationController.toolbar.tintColor = tintColor;
	}
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
/*
- (NSInteger)calcFilteredVisibilities:(NSMutableArray *)list
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
	
	int c = visibleFilteredCount > 0 ? visibleFilteredCount + (remainderFilteredCount > 0 ? 1 : 0) : 0;
	
	return c;
}
*/

#if !defined(LITE_VERSION)
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView != self.searchDisplayController.searchResultsTableView)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete)
		{
			Book *book = [bookList objectAtIndex: indexPath.row];
			
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [searchPaths objectAtIndex: 0];
			NSError *error;
			BOOL success = [[NSFileManager defaultManager] removeItemAtPath: [documentPath stringByAppendingPathComponent: book.fileName] error: &error];
			
			if (!success) {
				NSLog(@"BookViewController: Delete Row: File not Found");
			}
			
			[bookList removeObjectAtIndex: indexPath.row];
			
			[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];		
		}
	}
}
#endif

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
	{
		return [NSString stringWithFormat:@"%i %@", [bookList count], NSLocalizedString(@"Books", @"Total Books")];
	}
	
	return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		int extraSpace = 30;
		
		UIFont *cellFont = nil;
		NSString *cellTitle = @"";
		
		if (indexPath.row < [dataListFiltered visibleObjectCount])
		{
			BookSearchInfo *info = [dataListFiltered objectAtIndex:indexPath.row];
			
			if (info.scopeIndex == 0 || info.scopeIndex == 1)
			{
				cellTitle = info.book.bookName;
			}
			
			if (info.scopeIndex == 2)
			{
				cellTitle = info.toc.bookTitle;
			}
			
			if (info.scopeIndex == 3)
			{
				cellTitle = [AppManager getCharsPerRow:info.content.nash];
				extraSpace = 50;
			}
		}
		
		if (dataListFiltered.remainderCount > 0 && indexPath.row >= [dataListFiltered visibleObjectCount])
		{
			cellTitle = NSLocalizedString(@"More", @"More");;
		}
		
		cellFont = [UIFont fontWithName:@"Verdana" size:15];
		
		CGRect bounds = tableView.frame;
		
		CGSize constraintSize = CGSizeMake(bounds.size.width, MAXFLOAT);
		CGSize cellSize = [cellTitle sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		return cellSize.height + extraSpace;
		
	}
	else {
		return 55;
	}

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		int c = [dataListFiltered visibleObjectCount] + [dataListFiltered remainderSwitchCount];
		
		return c;
	}
    return [bookList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"iShamela.BookList";

	UITableViewCell *cell = (nCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];					
	}
	
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		
		BOOL isMore = NO;
		int level = 0;
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		if (indexPath.row < [dataListFiltered visibleObjectCount])
		{
			BookSearchInfo *info = [dataListFiltered objectAtIndex:indexPath.row];


			if (info.scopeIndex == AUTHOR_SCOPE) // author
			{
				NSString *authorName = info.book.author;
				
				if ([authorName length] == 0)
				{
					authorName = NSLocalizedString(@"<No Name>", @"<No Name");
				}
				
				cell.textLabel.text = authorName;
			}
			
			if (info.scopeIndex == TITLE_SCOPE) // title
			{
				cell.textLabel.text = info.book.bookName;
			}
			
			if (info.scopeIndex == TOC_SCOPE) // toc
			{
				level = [info.toc.bookLevel intValue] - 1;

				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				cell.textLabel.text = info.toc.bookTitle;
				cell.textLabel.font = level == 0 ? [AppManager getDefaultFont] : [AppManager getDefaultFont];
			}	
			
			if (info.scopeIndex == CONTENT_SCOPE)
			{
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				
				cell.textLabel.text = [AppManager getCharsPerRow:info.content.nash];
				cell.textLabel.font = [AppManager getDefaultFont];
			}
		}
		
		if (dataListFiltered.remainderCount > 0 && indexPath.row >= [dataListFiltered visibleObjectCount])
		{			
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");;

			isMore = YES;
		}
		
		cell.textLabel.font = [AppManager getDefaultFont];
		cell.textLabel.textAlignment = isMore ? UITextAlignmentCenter : UITextAlignmentRight;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.textColor = isMore ? [UIColor redColor] : [UIColor blackColor];
		
		return cell;
	}
	else
	{
		nCell *cell = (nCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[nCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
		}
		
		Book *book = [bookList objectAtIndex:indexPath.row];
			/*
		cell.textLabel.textAlignment = UITextAlignmentRight;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont fontWithName: @"Verdana" size: 20];
		cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1.0];
		*/
		cell.primaryLabel.text = book.bookName;
		cell.secondaryLabel.text = book.author;
		cell.icon.image = image;
		
		return cell;
	}
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)displayBookDetails:(NSArray *)data 
{
	BookDetailViewController *bdc = [[BookDetailViewController alloc] initWithArray:data];
	
	[self.navigationController pushViewController:bdc animated:YES];
	[bdc release];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		BookSearchInfo *info = [dataListFiltered objectAtIndex:indexPath.row];
		
		if (indexPath.row < [dataListFiltered visibleObjectCount])
		{
			if (info.scopeIndex == TOC_SCOPE)
			{
				NSMutableArray *data = [[NSMutableArray alloc] init];
				if (info.book != nil)
				{
					[data addObject:info.book];
				}
				
				if (info.toc != nil)
				{
					[data addObject:info.toc];
				}
								
				[self displayBookDetails:data];
				
				[data release];				
			}
			
			if (info.scopeIndex == CONTENT_SCOPE)
			{
				NSMutableArray *data = [[NSMutableArray alloc] init];
				if (info.book != nil)
				{
					[data addObject:info.book];
				}
								
				if (info.content != nil)
				{
					[data addObject:info.content];
				}
				
				[self displayBookDetails:data];
				
				[data release];
			}
		}
	}
}


- (void)pushWebViewControllerWithTitle:(NSString *)title PageIndex:(NSInteger)pageIndex Array:(NSMutableArray *)array Book:(Book *)book
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
		wvc.dataList = array;
		wvc.loadDB = NO;
		wvc.pageIndex = pageIndex;
		[self.navigationController pushViewController:wvc animated:YES];
		//[wvc release], wvc = nil;
	}
	else 
	{
		RootViewController_iPad *root = (RootViewController_iPad *)self;
		
		[root.detailViewController queryWithPageIndex:pageIndex DataList:array];		
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		BookSearchInfo *info = [dataListFiltered objectAtIndex:indexPath.row];
		
		if (indexPath.row < [dataListFiltered visibleObjectCount])
		{
			if (info.scopeIndex == 0 || info.scopeIndex == 1)
			{
				[self displayTOC:[bookList indexOfObject:info.book] animate:YES];
			}
			
			if (info.scopeIndex == TOC_SCOPE)
			{
				BookContent *content = [[BookContent alloc] init];
				content.nash = info.toc.bookTitle;

				[self pushWebViewControllerWithTitle:@"" 
										   PageIndex:1 
											   Array:[NSMutableArray arrayWithObject:content]
												Book:info.book];				
				[content release];
			}
			
			if (info.scopeIndex == CONTENT_SCOPE)
			{
				BookContent *content = [[BookContent alloc] init];
				content.nash = info.content.nash;
				
				[self pushWebViewControllerWithTitle:@"" 
										   PageIndex:1 
											   Array:[NSMutableArray arrayWithObject:content]
												Book:info.book];				
				[content release];				
			}
		}
		
		if (dataListFiltered.remainderCount > 0 && indexPath.row >= [dataListFiltered visibleObjectCount])
		{
			[dataListFiltered increaseWith:increaseStep];
			[tableView reloadData];
		}
		
	}
	else 
	{
		[AppManager setDefaultTOCRow:indexPath.row];
		[self displayTOC:indexPath.row animate:YES];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Content Filtering

- (void) filterContentForSearchText: (NSString *)searchText scope: (NSString *)scope {
	
	[dataListFiltered removeAllObjects];

	if ([searchText length] == 0)
	{
		return;
	}
	
	int level = 0;	//title
	
	if ([scope isEqualToString: NSLocalizedString(@"Author", @"Author")]) 
	{
		level = 1;
	} 
	else if ([scope isEqualToString: NSLocalizedString(@"Chapter", @"Chapter")]) 
	{
		level = 2;
	}
	else if ([scope isEqualToString:NSLocalizedString(@"Content", @"Content")])
	{
		level = 3;
	}


	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSRange range;
	switch (level) {
		case 0:
		case 1:
		{
			for (Book *book in bookList)
			{
				if (level == 0)
				{
					range = [book.bookName rangeOfString: searchText];
					if (range.location != NSNotFound)
					{
						BookSearchInfo *info = [BookSearchInfo bookWithScopeIndex:level Book:book toc:nil content:nil];
						[dataListFiltered addObject:info];
						[info release];
					}
				}
				else if (level == 1)
				{
					range = [book.author rangeOfString:searchText];
					if (range.location != NSNotFound)
					{
						BookSearchInfo *info = [BookSearchInfo bookWithScopeIndex:level Book:book toc:nil content:nil];
						[dataListFiltered addObject:info];
						[info release];
					}
					
				}
			}
			
		} break;
			
		case 2:
		{
			NSMutableArray *files = [[NSMutableArray alloc] init];
			NSMutableArray *queries = [[NSMutableArray alloc] init];
			for (Book *book in bookList)
			{
				if (book.selected)
				{
					[files addObject:book.fileName];
					[queries addObject:[NSString stringWithFormat:@"SELECT * FROM t%@ WHERE tit LIKE '%%%@%%'", book.bkId, searchText]];
				}
			}
			
			[dbTOC stopFetch];
			
			[dbTOC fetchRecordsAsyncWithFiles:files Queries:queries Objects:bookList];
			
			[files release];
			[queries release];
			
		} break;
			
		case 3:
		{
			NSMutableArray *files = [[NSMutableArray alloc] init];
			NSMutableArray *queries = [[NSMutableArray alloc] init];
			for (Book *book in bookList)
			{
				if (book.selected)
				{
					[files addObject:book.fileName];
					[queries addObject:[NSString stringWithFormat:@"SELECT * FROM b%@ WHERE nass LIKE '%%%@%%'", book.bkId, searchText]];
				}
			}
			
			[dbContent stopFetch];
			
			[dbContent fetchRecordsAsyncWithFiles:files Queries:queries Objects:bookList];
			
			[files release];
			[queries release];
			
		} break;
			
		default:
			break;
	}
	
/*		
 NSRange range = [Toc.bookTitle rangeOfString: searchText];

		if (level == 0) 
		{
			if (range.location != NSNotFound) {
				[dataListFiltered addObject: Toc];
			}
		} 
		else if (leve
		{
			if (range.location != NSNotFound && [[Toc bookLevel] intValue] == level) {
				[dataListFiltered addObject: Toc];
			}
		}
		
*/		
		
	

	[pool release];

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
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[dbManager release];
	[bookList release];
	[dataListFiltered release];
	[image release];
	[dbBook release];
	[dbTOC release];
	[dbContent release];
	[activityView release];
	
    [super dealloc];
}


@end

