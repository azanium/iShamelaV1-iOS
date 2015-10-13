//
//  DBWrapper.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DBWrapper.h"


@implementation DBWrapper

@synthesize type;
@synthesize fileName;
@synthesize data;

+ (id)initWithFileName:(NSString *)fileName Statement:(sqlite3_stmt *)stmt
{
	DBWrapper *wrapper = [[[DBWrapper alloc] init] autorelease];
	
	wrapper.fileName = fileName;
	wrapper.statement = stmt;
	
	return wrapper;
}

- (sqlite3_stmt *)statement
{
	return statement;
}							

- (void)setStatement:(sqlite3_stmt *)stmt
{
	statement = stmt;
}

@end
