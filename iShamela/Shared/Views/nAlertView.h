//
//  nAlertView.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface nAlertView : UIAlertView {
	UITextView *textView;
}

@property (nonatomic, retain) UITextView *textView;

@end
