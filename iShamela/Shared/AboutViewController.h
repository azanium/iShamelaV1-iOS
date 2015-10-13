//
//  AboutViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
	UIWebView *webView;
	NSString *titleText;
	NSString *content;
	BOOL isDefault;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isDefault;

@end
