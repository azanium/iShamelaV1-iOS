//
//  StoreData.h
//  iShamela
//
//  Created by Suhendra Ahmad on 2/2/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface StoreData : NSObject {
	NSString *bookName;
	NSString *bookID;
	NSString *price;
	NSString *description;
	NSString *fileName;
	BOOL isDownloading;
	BOOL isDownloaded;
	BOOL isPurchased;
}

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL isDownloaded;
@property (nonatomic, assign) BOOL isPurchased;

- (id)initWithProduct:(SKProduct *)skproduct;
+ (id)storeWithProduct:(SKProduct *)skproduct;

@end
