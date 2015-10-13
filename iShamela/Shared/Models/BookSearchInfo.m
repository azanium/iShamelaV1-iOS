//
//  BookSearchInfo.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/24/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "BookSearchInfo.h"


@implementation BookSearchInfo

@synthesize scopeIndex, book, toc, content;

+ (id) bookWithScopeIndex:(NSInteger)index Book:(Book *)bk toc:(TOC *)Toc content:(BookContent *)Content
{
	BookSearchInfo *info = [[BookSearchInfo alloc] init];
	
	info.book = bk;
	info.toc = Toc;
	info.content = Content;
	info.scopeIndex = index;
	
	return info;
}

- (void) dealloc
{
	[book release];
	[toc release];
	[content release];
	
	[super dealloc];
}

@end
