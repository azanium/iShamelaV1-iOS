//
//  DBManager.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "DBWrapper.h"

@interface DBManager (PrivateMethods)
- (void)invokeGotRecordDelegate:(DBWrapper *)wrapper;
@end

@implementation DBManager

#pragma mark -
#pragma mark Properties

@synthesize dbFileName, stopFetch;
@synthesize delegate;

#pragma mark -
#pragma mark Static Methods

static DBManager *_dbManager = nil;

+ (DBManager *)default
{
	if (_dbManager == nil) {
		_dbManager = [[[DBManager alloc] init] autorelease];
	}
	
	return _dbManager;
}

+ (NSString *)getBuiltInDBPath:(NSString *)filename 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *dir = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:filename];
}

+ (NSString *)getDownloadPath:(NSString *)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *dir = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:filename];
}

+ (NSString *)getUserDocumentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentPath = [paths objectAtIndex: 0];
	
	return documentPath;
}


#pragma mark -
#pragma mark File Management

+ (void)copyBuiltInDBFiles:(NSString *)filename 
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dbPath = [DBManager getBuiltInDBPath:filename];
	
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	NSError *error;
	
	if (!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
		{
			NSAssert(0, @"copyBuiltInDBFiles: failed to copy builtin db");
		}
	}
}

#pragma mark -
#pragma mark  SQlite Operations

- (BOOL)openDb:(NSString *)filename 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
	
	[self closeDB];
	
	if (sqlite3_open([documentPath UTF8String], &dbConnection) != SQLITE_OK)
	{
		NSLog(@"openDB: failed to open database");
		
		return NO;
	}

	self.dbFileName = filename;
	
	return YES;
}

- (void)closeDB
{
	if (dbConnection)
	{
		sqlite3_close(dbConnection);
	}
}

- (void)invokeGotRecordDelegate:(DBWrapper *)arg
{	
	if (arg.type == 0)
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(dbGotRecord:Statement:Object:)])
			{
				sqlite3_stmt *stmt = arg.statement;
				NSString *filename = arg.fileName;
				NSObject *data = arg.data;

				self.dbFileName = filename;
				
				[self.delegate dbGotRecord:self Statement:stmt Object:data];
			}
		}
	}
	else if (arg.type == 1)
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(dbFinalize:)])
			{
				[self.delegate dbFinalize:self];
			}
		}
	}
	else if (arg.type == 2)
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(dbPrepare:)])
			{
				[self.delegate dbPrepare:self];
			}
		}
	}
}

- (void)fetchRecordsWithDictionary: (NSDictionary *)args
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *files = [args objectForKey:@"filenames"];
	if (files != nil)
	{
		[files retain];
	}
	
	NSArray *queries = [args objectForKey:@"queries"];
	if (queries != nil)
	{
		[queries retain];
	}

	NSArray *objects = [args objectForKey:@"objects"];
	if (objects != nil)
	{
		[objects retain];
	}
	
	DBWrapper *wrapper = [[DBWrapper alloc] init];
	
	// Call the delegate prepare
	wrapper.type = 2;
	[self performSelectorOnMainThread:@selector(invokeGotRecordDelegate:) 
						   withObject:wrapper
						waitUntilDone:YES];
	
	NSString *filename;
	NSString *query;
	for (int i = 0; i < [files count]; i++)
	{
		filename = [files objectAtIndex:i];
		query = [queries objectAtIndex:i];
		NSObject *data = objects == nil ? nil : [objects objectAtIndex:i];
		
		[self closeDB];
		
		sqlite3_stmt *stmt = NULL;
		
		[self openDb:filename];
		
		const char *sql = [query UTF8String];
		
		
		BOOL done = NO;
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(stmt) == SQLITE_ROW && !done && !self.stopFetch) {
				wrapper.fileName = filename;
				wrapper.statement = stmt;
				wrapper.data = data;
				wrapper.type = 0;
				[self performSelectorOnMainThread:@selector(invokeGotRecordDelegate:) 
									   withObject:wrapper
									waitUntilDone:YES];
			}
		} else {
			NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
		}
		
		sqlite3_finalize(stmt);
		
		if (self.stopFetch)
		{
			done = YES;
		}
				
	}
	
	wrapper.type = 1;
	[self performSelectorOnMainThread:@selector(invokeGotRecordDelegate:) 
						   withObject:wrapper
						waitUntilDone:YES];
	
	[wrapper release];
	[files release];
	[queries release];
	[objects release];
	
	[pool release];
	
}

- (void)fetchRecordsAsync:(NSString *)filename Query:(NSString *)query
{
	self.stopFetch = NO;
	
	NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:filename], @"filenames", 
						  [NSArray arrayWithObject:query], @"queries", nil];
	[NSThread detachNewThreadSelector:@selector(fetchRecordsWithDictionary:) toTarget:self withObject:args];
}

- (void)fetchRecords:(NSString *)filename Query:(NSString *)query;
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self closeDB];
	
	sqlite3_stmt *stmt = NULL;
	
	[self openDb:filename];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW && !done) {
			if (self.delegate)
			{
				self.dbFileName = filename;
				[self.delegate dbGotRecord:self Statement:stmt Object:nil];
			}			
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(stmt);
	
	[pool release];
}

- (void)fetchRecordsAsyncWithFiles:(NSArray *)files Queries:(NSArray *)queries Objects:(NSArray *)data
{
	self.stopFetch = NO;
	
	NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:files, @"filenames", 
						  queries, @"queries", 
						  data, @"objects", nil];
	[NSThread detachNewThreadSelector:@selector(fetchRecordsWithDictionary:) toTarget:self withObject:args];
	
}

- (BOOL)fetchAllDbInfo:(NSString *)query
{
	NSString *docPath = [DBManager getUserDocumentPath];

	NSError *error;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:&error];
	
	BOOL success = YES;
	
	[self closeDB];
	
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(dbPrepare:)])
		{
			[self.delegate dbPrepare:self];
		}
	}
	
	for (NSString *file in files)
	{
		sqlite3_stmt *stmt = NULL;
		const char *sql = [query UTF8String];
	
		[self openDb:file];
		
		BOOL done = NO;
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL) == SQLITE_OK)
		{
			while (sqlite3_step(stmt) == SQLITE_ROW && !done) {
				if (self.delegate)
				{
					if ([self.delegate respondsToSelector:@selector(dbGotBookInfoRecord:Statement:)])
					{
						self.dbFileName = file;
						[self.delegate dbGotBookInfoRecord:self Statement:stmt];
					}
				}
			}
		}
		else {
			NSLog(@"fetchAllDbInfo: Sqlite prepare failed...");
			success = NO;
		}
		
		sqlite3_finalize(stmt);
	}
	
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(dbFinalize:)])
		{
			[self.delegate dbFinalize:self];
		}
	}
	
	return success;
}


#pragma mark -
#pragma mark User Defaults


- (void) dealloc
{
	[dbFileName release];
	self.delegate = nil;
	
	[super dealloc];
}

@end
