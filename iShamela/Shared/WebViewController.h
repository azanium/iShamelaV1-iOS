//
//  WebViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Translator.h"
//#import "AdMobViewController.h"
//#import "iAdViewController.h"
#import "AdWhirlViewController.h"

@class Book;

@interface WebViewController : AdWhirlViewController <DBManagerDelegate, UIAlertViewDelegate, UIWebViewDelegate, TranslatorDelegate> {
	UIWebView *webView;
	
	Book *book;
	DBManager *dbManager;
	NSMutableArray *dataList;
	
	NSString *startID;
	NSString *endID;
	
	UIActionSheet *actionSheet;
	UIActionSheet *webSheet;
	UILabel *statusLabel;
	UILabel *langLabel;
	
	NSInteger pageIndex;
	NSString *titleText;
	BOOL loadDB;
	
	Translator *translator;
	
	UIBarButtonItem *languageButton;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) Book *book;
@property (nonatomic, copy) NSString *startID;
@property (nonatomic, copy) NSString *endID;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) BOOL loadDB;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) UIBarButtonItem *languageButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void)updateStatus;
- (void)displayPage:(NSInteger)page;

@end
