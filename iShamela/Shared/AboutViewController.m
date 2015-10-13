    //
//  AboutViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "AboutViewController.h"
#import "AppManager.h"

@implementation AboutViewController

@synthesize webView;
@synthesize titleText, content, isDefault;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)closeThisView
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (isDefault)
	{
		self.title = NSLocalizedString(@"About", @"About App");
	
		[self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]  ] ] ];

	}
	else {
		self.title = self.titleText;
		[self.webView loadHTMLString:self.content baseURL:nil];
	}

	
	self.navigationController.navigationBar.tintColor = [AppManager getDefaultTintColor];
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Close Action") 
															 style:UIBarButtonItemStyleDone 
															target:self action:@selector(closeThisView)];
	self.navigationItem.leftBarButtonItem = done;
	[done release];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.webView = nil;
}


- (void)dealloc {
	[webView release];
	[titleText release];
	[content release];
	
    [super dealloc];
}


@end
