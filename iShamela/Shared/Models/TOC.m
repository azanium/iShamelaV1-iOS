//
//  TOC.m
//  iShamela
//
//  Created by Suhendra Ahmad on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TOC.h"


@implementation TOC


@synthesize bookId, bookTitle, bookLevel, bookSub;


+ (id)TOCWithId: (char *)bookID Title: (char *)title Level: (char *)level Sub: (char *)sub {
	
	TOC *toc = [[TOC alloc] init];
	
	toc.bookId = [NSString stringWithUTF8String: bookID];
	toc.bookTitle = [NSString stringWithUTF8String: title]; 
	toc.bookLevel = [NSString stringWithUTF8String: level];
	
	return toc;
}

- (void) dealloc {
	
	[bookId release];
	[bookTitle release];
	[bookLevel release];
	[bookSub release];
	
	[super dealloc];
}

@end
