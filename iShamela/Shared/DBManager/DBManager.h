//
//  DBManager.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 Azacode Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class DBManager;

@protocol DBManagerDelegate <NSObject>

@optional
- (void)dbPrepare:(DBManager *)manager;
- (BOOL)dbGotRecord:(DBManager *)manager Statement:(sqlite3_stmt *)stmt Object:(NSObject *)obj;
- (void)dbFinalize:(DBManager *)manager;

- (BOOL)dbGotBookInfoRecord:(DBManager *)manager Statement:(sqlite3_stmt *)stmt;

@end

@interface DBManager : NSObject {
	sqlite3 *dbConnection;
	
	id <DBManagerDelegate> delegate;
	
	NSString *dbFileName;
	BOOL stopFetch;
}

@property (nonatomic, assign) BOOL stopFetch;
@property (nonatomic, copy) NSString *dbFileName;
@property (nonatomic, assign) id <DBManagerDelegate> delegate;

// Static Methods
+ (NSString *)getDownloadPath:(NSString *)filename;
+ (DBManager *)default;
+ (NSString *)getBuiltInDBPath:(NSString *)filename;
+ (NSString *)getUserDocumentPath;

// File Management
+ (void)copyBuiltInDBFiles: (NSString *)filename;

// Database Management
- (BOOL)openDb:(NSString *)filename;
- (void)closeDB;
- (void)fetchRecords:(NSString *)filename Query:(NSString *)query;

- (BOOL)fetchAllDbInfo:(NSString *)query;

- (void)fetchRecordsAsync:(NSString *)filename Query:(NSString *)query;
- (void)fetchRecordsAsyncWithFiles:(NSArray *)files Queries:(NSArray *)query Objects:(NSObject *)data;

@end
