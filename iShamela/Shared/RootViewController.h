//
//  RootViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 Aza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
//#import "AdMobViewController.h"
//#import "iAdViewController.h"
#import "AdWhirlViewController.h"

#define TITLE_SCOPE 0
#define AUTHOR_SCOPE 1
#define TOC_SCOPE 2
#define CONTENT_SCOPE 3

@class HTTPServer;
@class nArray;
@class Book;

@interface RootViewController : AdWhirlViewController <DBManagerDelegate, UITableViewDataSource,
 UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
	 UITableView *aTableView;
	 
	 NSMutableArray *bookList;
	 nArray *dataListFiltered;
	 
	 DBManager *dbBook;
	 DBManager *dbTOC;
	 DBManager *dbContent;	 
	 DBManager *dbManager;
	 UIImage *image;
	 
	 //NSInteger visibleFilteredCount;
	 //NSInteger remainderFilteredCount;
	 NSInteger increaseStep;	 
	 
	 UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) IBOutlet UITableView *aTableView;

- (void)reloadBooks;
- (void)displaySettings;
- (void)displayAbout;

- (void)wifiSharing;
- (void)switchDefaultView;
- (void)displayTOC:(NSInteger)row animate:(BOOL)isAnimate;
- (void)pushWebViewControllerWithTitle:(NSString *)title PageIndex:(NSInteger)pageIndex Array:(NSMutableArray *)array Book:(Book *)book;

@end
