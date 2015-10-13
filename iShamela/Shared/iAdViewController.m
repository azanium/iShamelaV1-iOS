    //
//  AdViewController.m
//  Untitled
//
//  Created by Suhendra Ahmad on 1/28/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "iAdViewController.h"
#import "AdMobView.h"

@implementation iAdViewController

@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;
@synthesize isAvailable;
@synthesize isOnTop;
@synthesize adMobView = adMobAd;

#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherIdForAd:(AdMobView *)adView {
#if defined(LITE_SAHIH_MUSLIM)
	return @"a14d42b672839c9"; // this should be prefilled; if not, get it from www.admob.com
#else
	return @"a14d42e9fcccb1e"; // riyad saliheen
#endif
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return self;
}

- (UIColor *)adBackgroundColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:0.498 green:0.565 blue:0.667 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

// To receive test ads rather than real ads...

// Test ads are returned to these devices.  Device identifiers are the same used to register
// as a development device with Apple.  To obtain a value open the Organizer
// (Window -> Organizer from Xcode), control-click or right-click on the device's name, and
// choose "Copy Device Identifier".  Alternatively you can obtain it through code using
// [UIDevice currentDevice].uniqueIdentifier.
//
// For example:
//    - (NSArray *)testDevices {
//      return [NSArray arrayWithObjects:
//              ADMOB_SIMULATOR_ID,                             // Simulator
//              //@"28ab37c3902621dd572509110745071f0101b124",  // Test iPhone 3GS 3.0.1
//              //@"8cf09e81ef3ec5418c3450f7954e0e95db8ab200",  // Test iPod 2.2.1
//              nil];
//    }

 - (NSArray *)testDevices {
 return [NSArray arrayWithObjects: ADMOB_SIMULATOR_ID, nil];
 }
 
 - (NSString *)testAdActionForAd:(AdMobView *)adMobView {
 return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
 }


// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
	if (!self.isAvailable)
	{
		return;
	}
	
	NSLog(@"AdMob: Did receive ad");
	
	// get the view frame
	CGRect frame = self.view.frame;
	
	if (!self.isOnTop)
	{
		// put the ad at the bottom of the screen
		adMobAd.frame = CGRectMake(0, frame.size.height - 48, frame.size.width, 48);
		adMobAd.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;

		[self.view addSubview:adMobAd];
		
		[UIView beginAnimations:@"AdMobAd" context:nil];
		[UIView setAnimationDuration:0.3];
		
		frame = self.contentView.frame;
		frame.size.height -= 48;
		self.contentView.frame = frame;
		
		[UIView commitAnimations];
	}
	else 
	{
		// put the ad at the bottom of the screen
		adMobAd.frame = CGRectMake(0, 0, frame.size.width, 48);
		
		[self.view addSubview:adMobAd];
		
		[UIView beginAnimations:@"AdMobAd" context:nil];
		[UIView setAnimationDuration:0.3];
		
		frame = self.contentView.frame;
		frame.origin.y += 48;
		frame.size.height -= 48;
		self.contentView.frame = frame;
		
		[UIView commitAnimations];		
	}
	
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
	if (self.isAvailable)
	{
		NSLog(@"AdMob: Did fail to receive ad");
		[adMobAd removeFromSuperview];  // Not necessary since never added to a view, but doesn't hurt and is good practice
		[adMobAd release];
		adMobAd = nil;
	}
	// we could start a new ad request here, but in the interests of the user's battery life, let's not
}

#pragma mark -
#pragma mark AdMobs

- (void) createAdMobAdViewOnTop:(BOOL)onTop {
	self.isAvailable = NO;
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		self.isOnTop = onTop;
		adMobAd = [AdMobView requestAdWithDelegate:self];
		[adMobAd retain];
		self.isAvailable = YES;
	}
}


#pragma mark -
#pragma mark Banner View 

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible) {                
        _adBannerViewIsVisible = YES;
		NSLog(@"iAd loaded");
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = NO;
		NSLog(@"iAd didFail: %@", [error localizedDescription]);
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createiAdBannerView {
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		Class classAdBannerView = NSClassFromString(@"ADBannerView");
		if (classAdBannerView != nil) {
			self.adBannerView = [[[classAdBannerView alloc] 
								  initWithFrame:CGRectZero] autorelease];
			[_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
															  ADBannerContentSizeIdentifier320x50, 
															  ADBannerContentSizeIdentifier480x32, nil]];
			if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
				[_adBannerView setCurrentContentSizeIdentifier:
				 ADBannerContentSizeIdentifier480x32];
			} else {
				[_adBannerView setCurrentContentSizeIdentifier:
				 ADBannerContentSizeIdentifier320x50];            
			}
			[_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0, 
												 -[self getBannerHeight])];
			[_adBannerView setDelegate:self];
			
			[self.view addSubview:_adBannerView];
		}
	}
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		// AdMob
		if (adMobAd != nil)
		{

		}
		
		// iAd
		if (_adBannerView != nil) 
		{
			if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) 
			{
				[_adBannerView setCurrentContentSizeIdentifier:
				 ADBannerContentSizeIdentifier480x32];
			} 
			else 
			{
				[_adBannerView setCurrentContentSizeIdentifier:
				 ADBannerContentSizeIdentifier320x50];
			}          
			
			[UIView beginAnimations:@"fixupViews" context:nil];
			
			if (_adBannerViewIsVisible) 
			{
				CGRect contentViewFrame = self.contentView.frame;
				
				CGRect adBannerViewFrame = [_adBannerView frame];
				
				adBannerViewFrame.origin.x = 0;
				adBannerViewFrame.origin.y = 0;
				
				[_adBannerView setFrame:adBannerViewFrame];
				
				contentViewFrame.origin.y = [self getBannerHeight:toInterfaceOrientation];
				contentViewFrame.size.height = self.view.frame.size.height - [self getBannerHeight:toInterfaceOrientation];
				
				self.contentView.frame = contentViewFrame;
			} 
			else 
			{
				CGRect adBannerViewFrame = [_adBannerView frame];
				adBannerViewFrame.origin.x = 0;
				adBannerViewFrame.origin.y = 
				-[self getBannerHeight:toInterfaceOrientation];
				[_adBannerView setFrame:adBannerViewFrame];
				CGRect contentViewFrame = _contentView.frame;
				contentViewFrame.origin.y = 0;
				contentViewFrame.size.height = self.view.frame.size.height;
				self.contentView.frame = contentViewFrame;            
			}
			[UIView commitAnimations];
		}  
		
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//[self createAdBannerView];
}

- (void) viewWillAppear:(BOOL)animated
{
	[self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[self fixupAdView:toInterfaceOrientation];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.contentView = nil;
	self.adBannerView = nil;
}

- (void)createAdBannerViewOnTop:(BOOL)onTop
{
	if (DEFAULT_AD == 0) // iAd
	{
		[self createiAdBannerView];
	}
	else if (DEFAULT_AD == 1)
	{
		[self createAdMobAdViewOnTop:onTop];
	}
	
}


- (void)dealloc {
    [super dealloc];
	
	self.contentView = nil;
	self.adBannerView = nil;
	
	[adMobAd release];
}


@end
