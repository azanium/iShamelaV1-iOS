//
//  RootViewController_iPad.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/7/10.
//  Copyright 2010 Azacode Inc. All rights reserved.
//

#import "RootViewController_iPad.h"
#import "DetailViewController.h"
#import "BookSearchInfo.h"
#import "Book.h"
#import "BookContent.h"
#import "TOCViewController.h"
#import "nArray.h"
#import "TOC.h"

@implementation RootViewController_iPad

@synthesize detailViewController;

#pragma mark -
#pragma mark Table View Delegate

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.detailViewController.rootViewController = self;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (tableView != self.searchDisplayController.searchResultsTableView)
	{
		TOCViewController *tc = [[TOCViewController alloc] initWithNibName:@"TOCView_iPhone" bundle:[NSBundle mainBundle]];
		
		tc.rootViewController = self;
		tc.book = [bookList objectAtIndex:indexPath.row];
		
		[self.navigationController pushViewController:tc animated:YES];
		[tc release], tc = nil;
	}
	else {
		
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
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
	[detailViewController release];
	
	[super dealloc];
}

@end
