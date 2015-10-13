//
//  RootViewController_iPad.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/7/10.
//  Copyright 2010 Azacode Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"

@class DetailViewController;

@interface RootViewController_iPad : RootViewController {
	DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
