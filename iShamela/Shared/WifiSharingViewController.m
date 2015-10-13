    //
//  WifiSharingViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/21/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "WifiSharingViewController.h"
#import "AppManager.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "RootViewController.h"

@implementation WifiSharingViewController


@synthesize switchOnOff, statusLabel, titleLabel;
@synthesize rootViewController;


#pragma mark -
#pragma mark HTTPServer

- (IBAction) startStopSharing:(id)sender
{
	if ([sender isOn])
	{
		[self startServer:YES];
	}
	else {
		[self startServer:NO];
	}

}

- (void)startServer:(BOOL)started
{
	if (started)
	{
		NSError *error;
		if (![httpServer start:&error])
		{
			NSLog(@"RootViewController:HTTPServer failed to start...%@", error);
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
															message:NSLocalizedString(@"Connection Error", @"Connection Error")
														   delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];			
		}
		[self displayInfoUpdate:nil];
	}
	else {
		[httpServer stop];
		statusLabel.text = @"";
	}
	
}

- (void)initServer
{
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
}

- (void)displayInfoUpdate:(NSNotification *)notification
{
	NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
	
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
	
	if (!localIP)
		info = NSLocalizedString(@"Wifi: No Connection!\n", @"Wifi: No Connection!\n");
	else
		info = [NSString stringWithFormat:@"http://iphone.local:%d		http://%@:%d\n", port, localIP, port];
	
	NSString *wwwIP = [addresses objectForKey:@"www"];
	
	if (wwwIP)
		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
	else
		info = [info stringByAppendingString:NSLocalizedString(@"Web: Unable to determine external IP\n", @"Web: Unable to determine external IP\n")];
	
	statusLabel.text = info;
	
}




#pragma mark -
#pragma mark View 

- (void)dismissModal
{
	[self.rootViewController reloadBooks];
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.titleLabel.text = NSLocalizedString(@"Start Sharing", @"Start Sharing");
	self.title = NSLocalizedString(@"File Sharing", @"File Sharing");
	
	self.navigationController.navigationBar.tintColor = [AppManager getDefaultTintColor];
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")
															 style:UIBarButtonItemStyleDone
															target:self 
															action:@selector(dismissModal)];
	
	self.navigationItem.leftBarButtonItem = done;
	[done release];
	
	[self initServer];
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
	self.statusLabel = nil;
	self.titleLabel = nil;
	self.switchOnOff = nil;
	self.rootViewController = nil;
}


- (void)dealloc {
	[statusLabel release];
	[titleLabel release];
	[httpServer release];
	[addresses release];
	[switchOnOff release];
	[rootViewController release];
	
    [super dealloc];
}


@end
