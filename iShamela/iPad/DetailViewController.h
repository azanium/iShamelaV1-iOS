//
//  DetailViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h"
#import "DBManager.h"
#import "Translator.h"
#import "AdViewController.h"

@class Book;
@class DBManager;
@class RootViewController_iPad;

@interface DetailViewController : UIViewController <	
	UISplitViewControllerDelegate, 
	UIPopoverControllerDelegate, 
	DBManagerDelegate,
	TranslatorDelegate, 
	UIWebViewDelegate
> 
{
	AdViewController *adMobViewController;
	
	UIImageView *imageView;
	UIToolbar *toolbar;
	UIWebView *webView;
	UIWebView *translateView;
	UIPopoverController	*popoverController;
	
	UIBarButtonItem *prev;
	UIBarButtonItem *next;
	
	UILabel *statusLabel;
	
	NSMutableArray *dataList;
	NSInteger pageIndex;
	DBManager *dbManager;
	Translator *translator;
	
	UIActivityIndicatorView *activityView;
	UIActionSheet *actionSheet;
	UIBarButtonItem *languageButton;
	RootViewController_iPad *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet AdViewController *adMobViewController;
@property (nonatomic, retain) IBOutlet UIWebView *translateView;
@property (nonatomic, retain) IBOutlet RootViewController_iPad *rootViewController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) Translator *translator;
@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIActionSheet *actionSheet;

- (void)queryWithStartWithBook:(Book *)book StartID:(NSString *)startId EndID:(NSString *)endId;
- (void)queryWithPageIndex:(NSInteger)index DataList:(NSMutableArray *)list;
- (void)displayPage:(NSInteger)index;
- (void)updateStatus;

@end
