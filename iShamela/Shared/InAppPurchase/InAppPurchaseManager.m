//
//  InAppPurchaseManager.m
//  iShamela
//
//  Created by Suhendra Ahmad on 1/29/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "InAppPurchaseManager.h"


@implementation InAppPurchaseManager

+ (InAppPurchaseManager *)defaultManager
{
	InAppPurchaseManager *manager = [[[InAppPurchaseManager alloc] init] autorelease];
	return manager;				  
}

- (void)requestProUpgradeProductData
{
	NSSet *productIdentifiers = [NSSet setWithObject:@"com.azacode.iShamelaLiteSahihMuslim.Upgrade"];
	productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	productsRequest.delegate = self;
	[productsRequest start];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *products = response.products;
	proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
	NSLog(@"enter");
	if (proUpgradeProduct)
	{
		NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
	}
	
	for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
