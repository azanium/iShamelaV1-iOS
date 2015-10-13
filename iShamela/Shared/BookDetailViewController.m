//
//  BookDetailViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/30/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Book.h"
#import "TOC.h"
#import "BookContent.h"
#import "AppManager.h"


@implementation BookDetailViewController

@synthesize dataList;

#pragma mark -
#pragma mark Initialization

- (id) initWithArray:(NSArray *)array
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{
		self.dataList = array;
	}
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
	self.title = NSLocalizedString(@"Details", @"Details");
 }


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [dataList count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSObject *obj = [dataList objectAtIndex:section];
	
	if ([obj isKindOfClass:Book.class])
	{
		return NSLocalizedString(@"Book", @"Book");
	}
	
	
	if ([obj isKindOfClass:TOC.class])
	{
		return NSLocalizedString(@"Chapter", @"Chapter");
	}
	/*
	if ([obj isKindOfClass:BookContent.class])
	{
		return NSLocalizedString(@"Content", @"Content");
	}*/
	
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSObject *obj = [dataList objectAtIndex:section];
	
	if ([obj isKindOfClass:Book.class])
	{
		Book *book = (Book *)obj;
		
		return [book.author length] > 0 ? 2 : 1;
	}
	
	
	if ([obj isKindOfClass:TOC.class])
	{
		return 1;
	}
	/*
	if ([obj isKindOfClass:BookContent.class])
	{
		return 1;
	}*/
	
	
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString *label = @"";
	NSObject *obj = [dataList objectAtIndex:indexPath.section];
	
	
	if ([obj isKindOfClass:Book.class])
	{
		Book *currentBook = (Book *)obj;
		if (currentBook != nil)
		{
			if (indexPath.row == 0)
			{
				label = currentBook.bookName;
			}
			
			if (indexPath.row == 1)
			{	
				label = currentBook.author;
			}
		}
	}
	
	
	if ([obj isKindOfClass:TOC.class])
	{
		TOC *toc = (TOC *)obj;
		
		if (toc != nil)
		{
			if (indexPath.row == 0)
			{
				label = toc.bookTitle;
			}
		}
	}
	
	if ([obj isKindOfClass:BookContent.class])
	{
		BookContent *content = (BookContent *)content;
		if (indexPath.row == 0)
		{
			//label = [AppManager getCharsPerRow:content.nash];
		}
	}

	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	cell.textLabel.text = label;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [AppManager getDefaultFont];
	cell.textLabel.textAlignment = UITextAlignmentRight;
	
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	[dataList release];
	
    [super dealloc];
}


@end

