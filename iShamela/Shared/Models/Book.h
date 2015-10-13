//
//  Book.h
//  iShamela
//
//  Created by Suhendra Ahmad on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Book : NSObject {
	NSString *bkId;
	NSString *bookName;
	NSString *betaka;
	NSString *info;
	NSString *author;
	NSString *authorInfo;
	NSString *tafseerName;
	NSString *islamShort;
	NSString *fileName;
	BOOL selected;
}

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *bkId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *betaka;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorInfo;
@property (nonatomic, copy) NSString *tafseerName;
@property (nonatomic, copy) NSString *islamShort;
@property (nonatomic, assign) BOOL selected;

+ (id)bookWithFileName:(NSString *)FileName BookId:(char *)BookId BookName:(char *)BookName Betaka:(char *)Betaka Info:(char *)Info Author:(char *)Author 
		  AuthorInfo:(char *)AuthorInfo TafseerName:(char *)TafseerName IslamShort: (char *)IslamShort;


+ (id)bookWithBookId:(char *)BookId BookName:(char *)BookName Betaka:(char *)Betaka Info:(char *)Info Author:(char *)Author 
		  AuthorInfo:(char *)AuthorInfo TafseerName:(char *)TafseerName IslamShort: (char *)IslamShort;

@end
