//
//  BookSearchInfo.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/24/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOOK_DIC_ID @"Book"
#define TOC_DIC_ID @"TOC"
#define CONTENT_DIC_ID @"Content";

@class Book;
@class TOC;
@class BookContent;

@interface BookSearchInfo : NSObject {
	Book *book;
	TOC *toc;
	BookContent *content;
	NSInteger scopeIndex;
}

@property (nonatomic, assign) NSInteger scopeIndex;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) TOC *toc;
@property (nonatomic, retain) BookContent *content;


+ (id) bookWithScopeIndex:(NSInteger)index Book:(Book *)bk toc:(TOC *)Toc content:(BookContent *)Content;

@end
