//
//  TapDetectingWindow.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TapDetectingWindowDelegate

- (void)userDidTapWebView:(NSArray *)tapPoint;

@end


@interface TapDetectingWindow : UIWindow {
	
	BOOL waitForNextTap;
	UIView *viewToObserve;
	id <TapDetectingWindowDelegate> controllerThatObserves;
}

@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectingWindowDelegate> controllerThatObserves;

@end