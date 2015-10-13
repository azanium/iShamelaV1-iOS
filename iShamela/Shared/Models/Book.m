//
//  Book.m
//  iShamela
//
//  Created by Suhendra Ahmad on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Book.h"


@implementation Book


@synthesize fileName, bkId, bookName, betaka, info, author, authorInfo, tafseerName, islamShort;
@synthesize selected;

#pragma mark -
#pragma mark Init

+ (id)bookWithFileName:(NSString *)FileName BookId:(char *)BookId BookName:(char *)BookName Betaka:(char *)Betaka Info:(char *)Info Author:(char *)Author 
AuthorInfo:(char *)AuthorInfo TafseerName:(char *)TafseerName IslamShort: (char *)IslamShort
{
	Book *book = [[Book alloc] init];
	
	book.fileName = FileName;
	book.bkId = [NSString stringWithUTF8String: BookId];
	book.bookName = [NSString stringWithUTF8String: BookName];
	book.betaka = [NSString stringWithUTF8String: Betaka];
	book.info = [NSString stringWithUTF8String: Info];
	book.author = [NSString stringWithUTF8String: Author];
	book.authorInfo = [NSString stringWithUTF8String: AuthorInfo];
	book.tafseerName = [NSString stringWithUTF8String: TafseerName];
	book.islamShort = [NSString stringWithUTF8String: IslamShort];
	
	return book;
}


+ (id)bookWithBookId: (char *)BookId BookName:(char *)BookName Betaka:(char *)Betaka Info:(char *)Info Author:(char *)Author 
		  AuthorInfo:(char *)AuthorInfo TafseerName:(char *)TafseerName IslamShort: (char *)IslamShort
{
	Book *book = [[[Book alloc] init] autorelease];
	
	book.bkId = [NSString stringWithUTF8String: BookId];
	book.bookName = [NSString stringWithUTF8String: BookName];
	book.betaka = [NSString stringWithUTF8String: Betaka];
	book.info = [NSString stringWithUTF8String: Info];
	book.author = [NSString stringWithUTF8String: Author];
	book.authorInfo = [NSString stringWithUTF8String: AuthorInfo];
	book.tafseerName = [NSString stringWithUTF8String: TafseerName];
	book.islamShort = [NSString stringWithUTF8String: IslamShort];
	
	return book;
}

-(void) dealloc
{
	[bkId release];
	[bookName release];
	[betaka release];
	[info release];
	[author release];
	[authorInfo release];
	[tafseerName release];
	[islamShort release];
	[fileName release];
	
	[super dealloc];
}


@end
