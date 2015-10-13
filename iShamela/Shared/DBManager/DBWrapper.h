//
//  DBWrapper.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBWrapper : NSObject {
	sqlite3_stmt *statement;
	NSString *fileName;
	NSInteger type;
	NSObject *data;
}

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSObject *data;

-(sqlite3_stmt *)statement;
-(void)setStatement:(sqlite3_stmt *)stmt;

+ (id)initWithFileName:(NSString *)fileName Statement:(sqlite3_stmt *)stmt;

@end
