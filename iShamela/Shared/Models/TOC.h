//
//  TOC.h
//  iShamela
//
//  Created by Suhendra Ahmad on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TOC : NSObject {
	NSString *bookId;
	NSString *bookTitle;
	NSString *bookLevel;
	NSString *bookSub;
}


@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *bookLevel;
@property (nonatomic, copy) NSString *bookSub;

+ (id)TOCWithId: (char *)bookID Title: (char *)title Level: (char *)level Sub: (char *)sub;

@end
