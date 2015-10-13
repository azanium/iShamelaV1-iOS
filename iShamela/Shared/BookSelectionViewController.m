//
//  BookSelectionViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/30/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "BookSelectionViewController.h"
#import "AppManager.h"
#import "Book.h"

@implementation BookSelectionViewController


@synthesize bookList;


#pragma mark -
#pragma mark View lifecycle

- (void)dismissView
{
	for (Book *book in bookList)
	{
		[AppManager setBoolForKey:book.bookName Value:book.selected];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];


	self.navigationController.navigationBar.tintColor = [AppManager getDefaultTintColor];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") 
																	style:UIBarButtonItemStyleDone 
																   target:self
																   action:@selector(dismissView)];
	
    self.navigationItem.leftBarButtonItem = closeButton;	
	[closeButton release];
	
	self.title = NSLocalizedString(@"Search From", @"Search From");
	
	for (Book *book in bookList)
	{
		book.selected = [AppManager getBoolForKey:book.bookName];
	}
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [bookList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Book *book = [bookList objectAtIndex:indexPath.row];
    
	CGRect f = cell.frame; 
	f.size.width -= 20;
	cell.frame = f;
	cell.textLabel.font = [AppManager getDefaultFont];
	cell.textLabel.textAlignment = UITextAlignmentRight;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.textColor = book.selected ? [UIColor redColor] : [UIColor blackColor];
	
	cell.textLabel.text = book.bookName;
	cell.accessoryType = book.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
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
	Book *book = [bookList objectAtIndex:indexPath.row];
	
	book.selected = !book.selected;
	
	[tableView reloadData];
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
	[bookList release];
	
    [super dealloc];
}


@end

