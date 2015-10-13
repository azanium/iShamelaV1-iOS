//
//  AdViewController.h
//  Untitled
//
//  Created by Suhendra Ahmad on 1/28/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AdMobDelegateProtocol.h"

#define DEFAULT_AD 1 // iAd = 0, AdMob = 1

@interface iAdViewController : UIViewController <ADBannerViewDelegate, AdMobDelegate> {
	UIView *_contentView;
	id _adBannerView;
	BOOL _adBannerViewIsVisible;
	
	AdMobView *adMobAd;
	UIView *contentView;
	BOOL isOnTop;
	BOOL isAvailable;
}

// After the interface
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

// AdMob
@property (nonatomic) BOOL isAvailable;
@property (nonatomic) BOOL isOnTop;
@property (nonatomic, retain) IBOutlet AdMobView *adMobView;

- (void)createAdMobAdViewOnTop:(BOOL)onTop;

- (int)getBannerHeight:(UIDeviceOrientation)orientation;
- (int)getBannerHeight;
- (void)createiAdBannerView;
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;

- (void)createAdBannerViewOnTop: (BOOL)onTop;

@end
