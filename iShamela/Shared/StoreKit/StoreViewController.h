//
//  StoreViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 2/1/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "DownloadManager.h"
#import "DropboxSDK.h"

@class StoreData;

@interface StoreViewController : UIViewController <
UITableViewDelegate, UITableViewDataSource,	// TableView delegate and data source
DownloadManagerDelegate,  // Download Manager delegate
DBRestClientDelegate,     // Drop Box Rest Client Delegate
UIActionSheetDelegate,
SKProductsRequestDelegate, SKPaymentTransactionObserver> // StoreKit delegates

{
	NSMutableSet *productSet;
	NSMutableArray *productsList;
	NSMutableDictionary *bookList;
	NSMutableArray *downloadingList;

	UITableView *aTableView;
	UIActivityIndicatorView *activityView;
	UIProgressView *progressView;
	UIActionSheet *actionSheet;
	UIToolbar *toolbar;
	UILabel *downloadLabel;
	
	DownloadManager *downloader;
	DownloadManager *appDownloader;
	
	NSFileHandle *file1;
	
	DBRestClient *restClient;
	
	BOOL isDownloading;
	NSString *downloadFileName;
	StoreData *downloadStoreData;
	
}

@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

// DropBox
- (DBRestClient *)restClient;
- (void)linkDropBox;

- (void)showDownloadInfo:(BOOL)show;
- (void)downloadFile:(NSString *)dropBoxFile toPath:(NSString *)destPath;

// StoreKit
- (void)setupStore;
- (void)requestProducts;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchase:(NSString *)productId;

@end
