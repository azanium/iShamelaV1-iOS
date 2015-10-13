//
//  TOCViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/7/10.
//  Copyright 2010 Aza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iAdViewController.h"
#import "AdWhirlViewController.h"
#import "DBManager.h"

@class DBManager;
@class Book;
@class RootViewController;

@interface TOCViewController : AdWhirlViewController <UISearchBarDelegate, DBManagerDelegate, UISearchDisplayDelegate, UITableViewDelegate> {
@protected
	UITableView *aTableView;
	
	Book *book;
	DBManager *dbManager;
	NSMutableArray *dataList;
	NSMutableArray *dataListFiltered;
	UIActionSheet *actionSheet;
	
	NSInteger visibleFilteredCount;
	NSInteger remainderFilteredCount;
	NSInteger visibleCount;
	NSInteger remainderCount;
	NSInteger increaseStep;
	RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) RootViewController *rootViewController;

- (NSInteger)calcVisibilities:(NSMutableArray *)list;
- (NSInteger)calcFilteredVisibilities:(NSMutableArray *)list;
- (void)pushChapterControllerWithStartID:(NSString *)startId EndID:(NSString *)endId Title:(NSString *)title;
- (void)reloadDB;
- (void)switchDefaultView;

@end
