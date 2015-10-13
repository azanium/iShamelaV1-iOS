//
//  ChapterViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdMobViewController.h"
//#import "iAdViewController.h"
#import "AdWhirlViewController.h"
#import "TOCViewController.h"
#import "DBManager.h"

@class RootViewController;

@interface ChapterViewController : AdWhirlViewController <UITableViewDelegate, DBManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
	UITableView *aTableView;
	
@protected
	NSString *startID;
	NSString *endID;
	
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
@property (nonatomic, copy) NSString *startID;
@property (nonatomic, copy) NSString *endID;
@property (nonatomic, retain) RootViewController *rootViewController;

- (NSInteger)calcVisibilities:(NSMutableArray *)list;
- (NSInteger)calcFilteredVisibilities:(NSMutableArray *)list;

@end
