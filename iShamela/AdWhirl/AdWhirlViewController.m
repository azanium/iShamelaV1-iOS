    //
//  AdWhirlViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 1/29/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "AdWhirlViewController.h"
#import "AdWhirlView.h"
#import "AdWhirlView+.h"
#import "AdWhirlLog.h"
#import "AdWhirlConstants.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"

@implementation AdWhirlViewController

@synthesize currentViewController;
@synthesize isVisible;
@synthesize isOnTop;
@synthesize contentView;
@synthesize adView;

- (void) createAdOnTop:(BOOL)onTop
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		self.isOnTop = YES;
		self.isVisible = NO;
		
		self.adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
		self.adView.currentViewController = self.currentViewController;
		self.adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self.view addSubview:self.adView];
		
		if (getenv("ADWHIRL_FAKE_DARTS")) 
		{
			const char *dartcstr = getenv("ADWHIRL_FAKE_DARTS");
			NSArray *rawdarts = [[NSString stringWithCString:dartcstr encoding:NSUTF8StringEncoding]
								 componentsSeparatedByString:@" "];	
			
			NSMutableArray *darts = [[NSMutableArray alloc] initWithCapacity:[rawdarts count]];
			
			for (NSString *dartstr in rawdarts)
			{
				if ([dartstr length] == 0) 
				{
					continue;
				}
				[darts addObject:[NSNumber numberWithDouble:[dartstr doubleValue]]];
			}
			self.adView.testDarts = darts;
		}
		
		UIDevice *device = [UIDevice currentDevice];
		if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
			[device isMultitaskingSupported])
		{
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(enterForeground:) 
														 name:UIApplicationWillEnterForegroundNotification 
													   object:nil];
		}
		
		isAvailable = YES;
		[self toggleRefreshAd:YES];
	}
}

- (void)adjustAdSize
{
	if (!isVisible)
	{
		adView.hidden = YES;
		if (self.contentView != nil)
		{
			CGRect contentFrame = self.contentView.frame;
			contentFrame.origin.y = 0;
			contentFrame.size.height = self.view.bounds.size.height;
			self.contentView.frame = contentFrame;
		}
	}
	else if (adView != nil && isAvailable && isVisible)
	{
		adView.hidden = NO;
		/*
		[UIView beginAnimations:@"AdResize" context:nil];
		[UIView setAnimationDuration:0.4];
		
		CGSize adSize = [adView actualAdSize];
		CGRect newFrame = adView.frame;
		newFrame.size.height = adSize.height;
		newFrame.size.width = adSize.width;
		newFrame.origin.y = (self.view.bounds.size.width - adSize.width) / 2;
		adView.frame = newFrame;
		
		UIView commitAnimations];*/
		
		if (isOnTop)
		{
			CGSize adSize = [adView actualAdSize];
			CGRect newFrame = adView.frame;
			newFrame.size.height = adSize.height;
			newFrame.size.width = adSize.width;
			newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2;
			newFrame.origin.y = 0;//self.view.bounds.size.height - adSize.height;
			adView.frame = newFrame;
			
			if (self.contentView != nil)
			{
				[UIView beginAnimations:@"AdResize" context:nil];
				[UIView setAnimationDuration:0.4];

				CGRect contentFrame = self.contentView.frame;
				contentFrame.origin.y = adSize.height;
				contentFrame.size.height = self.view.bounds.size.height - adSize.height;
				self.contentView.frame = contentFrame;
				
				[UIView commitAnimations];
			}
			
		}
		else 
		{
			if (self.contentView != nil)
			{
				CGSize adSize = [adView actualAdSize];
				
				[UIView beginAnimations:@"AdResize" context:nil];
				[UIView setAnimationDuration:0.4];
				
				CGRect contentFrame = self.contentView.frame;
				contentFrame.size.height = self.view.bounds.size.height - adSize.height;
				self.contentView.frame = contentFrame;				
				
				[UIView commitAnimations];
				
				CGRect newFrame = CGRectMake(0, contentFrame.size.height, adSize.width, adSize.height);
				//newFrame.size.height = adSize.height;
				//newFrame.size.width = adSize.width;
				//newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2;
				//newFrame.origin.y = self.view.bounds.size.height - adSize.height;
				adView.frame = newFrame;
				

			}
		}

		
	}
}

- (void)requestNewAd
{
	[adView requestFreshAd];
}

- (void)requestNewConfig
{
	[adView updateAdWhirlConfig];
}

- (void)rollOver
{
	[adView rollOver];
}

- (void)toggleRefreshAd:(BOOL)toggle
{
	if (toggle)
	{
		[adView doNotIgnoreAutoRefreshTimer];
	}
	else {
		[adView ignoreAutoRefreshTimer];
	}

}

#pragma mark AdWhirlDelegate methods

- (NSString *)adWhirlApplicationKey {
	return kSampleAppKey;
}

- (NSString *) admobPublisherID {
#if (LITE_SAHIH_MUSLIM)
	return @"a14d42b672839c9"; // this should be prefilled; if not, get it from www.admob.com
#else
	return @"a14d42e9fcccb1e"; // riyad saliheen
#endif
	
}

- (UIViewController *)viewControllerForPresentingModalView {
	//return self;
	
	//return currentViewController;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		[((AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]) navigationController];
	}


	return self;
}

- (NSURL *)adWhirlConfigURL {
	return [NSURL URLWithString:kSampleConfigURL];
}

- (NSURL *)adWhirlImpMetricURL {
	return [NSURL URLWithString:kSampleImpMetricURL];
}

- (NSURL *)adWhirlClickMetricURL {
	return [NSURL URLWithString:kSampleClickMetricURL];
}

- (NSURL *)adWhirlCustomAdURL {
	return [NSURL URLWithString:kSampleCustomAdURL];
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
	NSLog(@"Got ad from %@, size %@", [adWhirlView mostRecentNetworkName], NSStringFromCGSize([adWhirlView actualAdSize]));
	if (isAvailable)
	{
		self.isVisible = YES;
		[self adjustAdSize];
	}
}

- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
	NSLog(@"Failed to receive ad from %@, %@. Error: %@", [adWhirlView mostRecentNetworkName], 
														  yesOrNo? @"will use backup" : @"will NOT use backup",
													      adWhirlView.lastError == nil? @"no error" : [adWhirlView.lastError localizedDescription]);
	if (isAvailable)
	{
		self.isVisible = NO;
		[self adjustAdSize];
	}
}

- (void)adWhirlReceivedRequestForDeveloperToFufill:(AdWhirlView *)adWhirlView {
	UILabel *replacement = [[UILabel alloc] initWithFrame:kAdWhirlViewDefaultFrame];
	replacement.backgroundColor = [UIColor redColor];
	replacement.textColor = [UIColor whiteColor];
	replacement.textAlignment = UITextAlignmentCenter;
	replacement.text = @"Generic Notification";
	[adWhirlView replaceBannerViewWith:replacement];
	[replacement release];
	[self adjustAdSize];
	NSLog(@"Generic Notification");
}

- (void)adWhirlReceivedNotificationAdsAreOff:(AdWhirlView *)adWhirlView {
	NSLog(@"Ads Are Off");
}

- (void)adWhirlWillPresentFullScreenModal {
	NSLog(@"SimpleView: will present full screen modal");
}

- (void)adWhirlDidDismissFullScreenModal {
	NSLog(@"SimpleView: did dismiss full screen modal");
}

- (void)adWhirlDidReceiveConfig:(AdWhirlView *)adWhirlView {
	NSLog(@"Received config. Requesting ad...");
}

- (BOOL)adWhirlTestMode {
	return NO;
}

- (UIColor *)adWhirlAdBackgroundColor {
	return [UIColor purpleColor];
}

- (UIColor *)adWhirlTextColor {
	return [UIColor cyanColor];
}

- (CLLocation *)locationInfo {
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
	CLLocation *location = [locationManager location];
	[locationManager release];
	return location;
}

- (NSDate *)dateOfBirth {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:1979];
	[comps setMonth:11];
	[comps setDay:6];
	NSDate *date = [gregorian dateFromComponents:comps];
	[gregorian release];
	[comps release];
	return date;
}

- (NSString *)postalCode {
	return @"31337";
}

- (NSUInteger)incomeLevel {
	return 99999;
}

- (NSString *)googleAdSenseCompanyName {
	return @"AZACODE";
}

- (NSString *)googleAdSenseAppName {
	return @"iShamela";
}

- (NSString *)googleAdSenseApplicationAppleID {
	return @"0";
}

- (NSString *)googleAdSenseKeywords {
	return @"iShamela,Shamela,Sahih,Riyad,Saliheen,Muslim,Bukhary";
}

- (NSURL *)googleAdSenseAppWebContentURL {
	return [NSURL URLWithString:@"http://azacode.wordpress.com"];
}

- (NSArray *)googleAdSenseChannelIDs {
	return [NSArray arrayWithObjects:@"0282698142", nil];
}

//extern NSString* const kGADAdSenseTextImageAdType;
//- (NSString *)googleAdSenseAdType {
//  return kGADAdSenseTextImageAdType;
//}

- (NSString *)googleAdSenseHostID {
	return @"HostID";
}

- (UIColor *)googleAdSenseAdTopBackgroundColor {
	return [UIColor orangeColor];
}

- (UIColor *)googleAdSenseAdBorderColor {
	return [UIColor redColor];
}

- (UIColor *)googleAdSenseAdLinkColor {
	return [UIColor cyanColor];
}

- (UIColor *)googleAdSenseAdURLColor {
	return [UIColor orangeColor];
}

- (UIColor *)googleAdSenseAlternateAdColor {
	return [UIColor greenColor];
}

- (NSURL *)googleAdSenseAlternateAdURL {
	return [NSURL URLWithString:@"http://www.adwhirl.com"];
}

- (NSNumber *)googleAdSenseAllowAdsafeMedium {
	return [NSNumber numberWithBool:YES];
}


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
/*
- (NSArray *)testDevices {
	return [NSArray arrayWithObjects: ADMOB_SIMULATOR_ID, nil];
}

- (NSString *)testAdActionForAd:(AdMobView *)adMobView {
	return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
}*/


#pragma mark -
#pragma Multitasking

- (void)enterForeground:(NSNotification *)notification 
{
	AWLogDebug(@"Entering Foreground");
	[self.adView updateAdWhirlConfig];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
	//[super viewDidAppear:animated];
	[self.adView rotateToOrientation:[UIDevice currentDevice].orientation];
	[self adjustAdSize];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self.adView rotateToOrientation:toInterfaceOrientation];
	[self adjustAdSize];
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
	self.adView.delegate = nil;
	self.adView = nil;
	self.contentView = nil;
	self.currentViewController = nil;
	
    [super dealloc];
}


@end
