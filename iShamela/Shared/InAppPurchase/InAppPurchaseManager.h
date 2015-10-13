//
//  InAppPurchaseManager.h
//  iShamela
//
//  Created by Suhendra Ahmad on 1/29/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>  {
	SKProduct *proUpgradeProduct;
	SKProductsRequest *productsRequest;

}

+ (InAppPurchaseManager *)defaultManager;
- (void)requestProUpgradeProductData;


@end
