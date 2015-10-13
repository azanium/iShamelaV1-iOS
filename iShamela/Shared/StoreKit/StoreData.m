//
//  StoreData.m
//  iShamela
//
//  Created by Suhendra Ahmad on 2/2/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "StoreData.h"


@implementation StoreData

@synthesize bookName, bookID, fileName;
@synthesize price, description;
@synthesize isDownloading, isDownloaded;
@synthesize isPurchased;

+ (id) storeWithProduct:(SKProduct *)skproduct
{
	StoreData *store = [[[StoreData alloc] initWithProduct:skproduct] autorelease];
	
	return store;
}

- (id)initWithProduct:(SKProduct *)skproduct
{
	if ((self = [super init]))
	{		
		self.bookName = skproduct.localizedTitle;
		self.bookID = skproduct.productIdentifier;
		self.description = skproduct.localizedDescription;
		self.price = [skproduct.price stringValue];
		self.isPurchased = NO;
		self.isDownloaded = NO;
		self.isDownloading = NO;
	}
	return self;
}

- (void) dealloc
{
	[bookName release];
	[bookID release];
	[price release];
	[description release];
	[fileName release];
	
	[super dealloc];
}

@end
