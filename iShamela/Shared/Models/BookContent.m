//
//  Book.m
//  iShamela
//
//  Created by Suhendra Ahmad on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookContent.h"


@implementation BookContent

@synthesize bookId, nash, part, page, hno, bookName;

+ (id) bookWithId: (char *)Id Nash:(char *)Nash Part: (char *)Part Page: (char *)Page HNo:(char *)HNo
{
	BookContent *book = [[BookContent alloc] init];
	
	book.bookId = [NSString stringWithUTF8String: Id == nil ? "" : Id];
	book.nash = [NSString stringWithUTF8String: Nash == nil ? "" : Nash];
	book.part = [NSString stringWithUTF8String: Part == nil ? "" : Part];
	book.page = [NSString stringWithUTF8String: Page == nil ? "" : Page];
	book.hno = [NSString stringWithUTF8String: HNo == nil ? "" : HNo];
	
	return book;
}

- (void) dealloc 
{
	[bookId release];
	[nash release];
	[page release];
	[part release];
	[hno release];
	[bookName release];
	
	[super dealloc];
}

@end
