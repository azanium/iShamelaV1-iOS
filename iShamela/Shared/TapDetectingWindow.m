//
//  TapDetectingWindow.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "TapDetectingWindow.h"

@implementation TapDetectingWindow

@synthesize viewToObserve;
@synthesize controllerThatObserves;

- (id)initWithViewToObserver:(UIView *)view andDelegate:(id)delegate {
    if(self == [super init]) {
        self.viewToObserve = view;
        self.controllerThatObserves = delegate;
		waitForNextTap = NO;
    }
    return self;
}

- (void)dealloc {
    [viewToObserve release];
    [super dealloc];
}

- (void)forwardTap:(id)touch {
    [controllerThatObserves userDidTapWebView:touch];
}

- (void)resetTap
{
	waitForNextTap = NO;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (viewToObserve == nil || controllerThatObserves == nil)
        return;
    NSSet *touches = [event allTouches];
    if (touches.count != 1)
        return;
    UITouch *touch = touches.anyObject;
    if (touch.phase != UITouchPhaseEnded)
        return;
    if ([touch.view isDescendantOfView:viewToObserve] == NO)
        return;
    CGPoint tapPoint = [touch locationInView:viewToObserve];
    NSLog(@"TapPoint = %f, %f", tapPoint.x, tapPoint.y);
    NSArray *pointArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", tapPoint.x],
						   [NSString stringWithFormat:@"%f", tapPoint.y], nil];
    if (touch.tapCount == 1) {
		if (!waitForNextTap)
		{
			waitForNextTap = YES;
			[self performSelector:@selector(forwardTap:) withObject:pointArray afterDelay:0.5];
			[self.nextResponder touchesEnded:touches withEvent:event];
			
			[self performSelector:@selector(resetTap) withObject:nil afterDelay:1.0f];
		}
    }
    else if (touch.tapCount > 1) {
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap:) object:pointArray];
    }
}

@end