//
//  Book.h
//  iShamela
//
//  Created by Suhendra Ahmad on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookContent : NSObject {
	NSString *bookId;
	NSString *nash;
	NSString *part;
	NSString *page;
	NSString *hno;
	NSString *bookName;
}

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *nash;
@property (nonatomic, copy) NSString *part;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *hno;
@property (nonatomic, copy) NSString *bookName;

+ (id) bookWithId: (char *)Id Nash:(char *)Nash Part: (char *)Part Page: (char *)Page HNo: (char *)HNo;

@end
