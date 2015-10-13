//
//  AdWhirlViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 1/29/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlDelegateProtocol.h"
#import "AdMobDelegateProtocol.h"

@class AdWhirlView;

@interface AdWhirlViewController : UIViewController <AdWhirlDelegate> {
	AdWhirlView *adView;
	UIView *contentView;
	UIInterfaceOrientation currLayouttOrientation;
	BOOL isAvailable;
	BOOL isOnTop;
	BOOL isVisible;
	UIViewController *currentViewController;
}

@property (nonatomic, retain) IBOutlet UIViewController *currentViewController;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL isOnTop;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) AdWhirlView *adView;

- (void)adjustAdSize;
- (void)createAdOnTop:(BOOL)isOnTop;

- (void)requestNewAd;
- (void)requestNewConfig;
- (void)rollOver;
- (void)toggleRefreshAd:(BOOL)toggle;

@end
