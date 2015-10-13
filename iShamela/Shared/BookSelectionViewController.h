//
//  BookSelectionViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/30/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookSelectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

@private 
	NSArray *bookList;
}

@property (nonatomic, retain) NSArray *bookList;

@end
