//
//  BookDetailViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/30/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;
@class TOC;
@class BookContent;


@interface BookDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {

@private 
	NSArray *dataList;
}

@property (nonatomic, retain) NSArray *dataList;

- (id)initWithArray:(NSArray *)array;

@end
