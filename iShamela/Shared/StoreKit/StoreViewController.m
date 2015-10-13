//
//  StoreViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 2/1/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "StoreViewController.h"
#import "AppManager.h"
#import "DBManager.h"
#import "StoreData.h"

#define kTableProductName 0
#define kTableProductPrice 1
#define kTableProductDescription 2
#define kTableProductBuy 3

#define kDownloadedTag @"Downloaded"
#define kPurchasedTag @"Purchased"

@interface UIActionSheet (Extension)
- (void)setNumberOfRows : (NSInteger)rows;
@end

@implementation StoreViewController

@synthesize aTableView;
@synthesize progressView;
@synthesize toolBar;

NSString *dropBoxFolder = @"/ishamela";


#pragma mark -
#pragma mark Store Kit Payment

- (void)processPurchaseDownload:(SKPaymentTransaction *)transaction
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSLog(@"StoreKit: Transaction Successful with ID : %@", transaction.transactionIdentifier);
	
	[self downloadFile:[NSString stringWithFormat:@"/ishamela/%@", downloadFileName] 
				toPath:[DBManager getDownloadPath:downloadFileName]];
	
	NSLog(@"StoreKit: Start Downloading file : %@ - into %@",[NSString stringWithFormat:@"/ishamela/%@", downloadFileName],
		  [DBManager getDownloadPath:downloadFileName]);
	
	[AppManager setBoolForKey:[NSString stringWithFormat:@"%@%@", downloadStoreData.bookID, kPurchasedTag]
						Value:YES];
	
	downloadStoreData.isDownloading = YES;
	
	[aTableView reloadData];
	
	isDownloading = YES;
	
	if (downloadLabel != nil)
	{
		downloadLabel.text = downloadStoreData.bookName;
	}
	[self showDownloadInfo:YES];
}

- (void)setupStore
{
	[self loadStore];
	
	downloader = [[DownloadManager alloc] init];
	[downloader setDelegate:self];
	[downloader startDownload:@"http://www.azacode.com/ishamela/books.plist" fileName:@"books.plist"];
}

- (void)loadStore
{
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

- (void)purchase:(NSString *)productId
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productId];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
	downloadStoreData.isDownloading = YES;
	
	[aTableView reloadData];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
	// NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
		// TODO: save something here
		[AppManager setObjectForKey:@"transaction" Value:transaction];
    }
    else
    {
		// send out a notification for the failed transaction
		NSLog(@"StoreKit: Transaction Failed");
		
		
		[AppManager showAlertWithTitle:NSLocalizedString(@"Error", @"Error") 
							   message:NSLocalizedString(@"Transaction failed, please try again", @"Transaction failed, please try again")];
		
    }
	
	isDownloading = NO;
	downloadStoreData.isDownloading = NO;
	
	[aTableView reloadData];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	//[self finishTransaction:transaction wasSuccessful:YES];
	[self processPurchaseDownload:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		[self finishTransaction:transaction wasSuccessful:NO];
	}
	else 
	{
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	}
	
	isDownloading = NO;
	downloadStoreData.isDownloading = NO;
	
	[aTableView reloadData];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//	[self finishTransaction:transaction wasSuccessful:YES];
	
	[self processPurchaseDownload:transaction];
}

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
				
			default:
				break;
		}
	}
}


#pragma mark -
#pragma mark Store Kit ProductsRequest

- (void)requestProducts
{
	if ([productSet count] > 0)
	{
		SKProductsRequest *request = [[SKProductsRequest alloc] 
									  initWithProductIdentifiers:productSet];//[NSSet setWithObject: @"com.azacode.iShamela.aqeedahwasitiyah"]];
		request.delegate = self;
		[request start];
		
		NSLog(@"StoreKit: ProductsRequest: Started...");
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
														message:NSLocalizedString(@"Connection Error", @"Connection Error") 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
	}
	
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"StoreKit: ProductsRequest Received...");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSArray *myProducts = response.products;
	if ([response.invalidProductIdentifiers count] > 0)
	{
		NSLog(@"StoreKit: Invalid Product Count : %i", [response.invalidProductIdentifiers count]);
		NSLog(@"StoreKit: Invalid Product ID : %@", [response.invalidProductIdentifiers objectAtIndex:0]);
	}
	
	NSLog(@"StoreKit: Products Count = %i", [myProducts count]);
	if ([myProducts count] > 0)
	{
		[productsList removeAllObjects];
		
		for (SKProduct *product in myProducts)
		{
			StoreData *store = [StoreData storeWithProduct:product];
			
			store.fileName = (NSString *)[bookList objectForKey:store.bookID];
			store.isDownloaded = [AppManager getBoolForKey:[NSString stringWithFormat:@"%@%@",store.bookID, kDownloadedTag]];
			store.isPurchased = [AppManager getBoolForKey:[NSString stringWithFormat:@"%@%@", store.bookID, kPurchasedTag]];
			
			[productsList addObject:store];
		}
		
		[aTableView reloadData];
	}
}


#pragma mark -
#pragma mark Action Sheet

- (void)showDownloadInfo:(BOOL)show
{
	[UIView beginAnimations:@"downloadinfo" context:nil];
	[UIView setAnimationDuration:0.3];
	
	if (show)
	{
		CGRect frame = aTableView.frame;
		frame.size.height -= self.toolBar.frame.size.height;
		aTableView.frame = frame;
	}
	else {
		CGRect frame = aTableView.frame;
		frame.size.height += self.toolBar.frame.size.height;
		aTableView.frame = frame;
	}

	progressView.progress = 0;
	
	[self.toolBar setHidden:!show];
	
	[UIView commitAnimations];
}

- (void)createDownloadInfo
{
	downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.toolBar.frame.size.width, 20)];
	downloadLabel.text = @"Please Wait";
	downloadLabel.backgroundColor = [UIColor clearColor];
	downloadLabel.textColor = [UIColor whiteColor];
	downloadLabel.textAlignment = UITextAlignmentCenter;
	downloadLabel.font = [UIFont systemFontOfSize:15];
	downloadLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[self.toolBar addSubview:downloadLabel];
	
	progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 25, 220, 90)];
	progressView.progressViewStyle = UIProgressViewStyleBar;
	progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	
	[self.toolBar addSubview:progressView];
	
	/*
	if (!actionSheet)
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Please wait", @"Please wait") 
												  delegate:self
										 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
									destructiveButtonTitle:nil
										 otherButtonTitles:nil];
		//[actionSheet setNumberOfRows:6];
		//[actionSheet setMessage:NSLocalizedString(@"Downloading", @"Downloading")];

		//if (!progressView)
		{
			progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 70, 220, 90)];
		}
		
		[progressView setProgressViewStyle:UIProgressViewStyleDefault];
		
		[actionSheet addSubview:progressView];
		
		[actionSheet showInView:aTableView];
	}*/
	
}

#pragma mark -
#pragma mark DropBox Methods

- (DBRestClient *)restClient
{
	if (!restClient) {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
		[restClient createFolder:dropBoxFolder];
	}

	return restClient;	
}

- (void)cancelDownload
{	
	if (downloadFileName != nil) {
		[restClient cancelFileLoad:downloadFileName];
	}
}

- (void)downloadFile:(NSString *)dropBoxFile toPath:(NSString *)destPath
{
	[self.restClient loadFile:dropBoxFile
					 intoPath:destPath];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	isDownloading = YES;
	[aTableView reloadData];
}

- (void) linkDropBox
{
	if ([[DBSession sharedSession] isLinked] == NO)
	{
		NSLog(@"DropBox: Start Link");
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[self.restClient loginWithEmail:@"azacode@yahoo.com" password:@"dementor3003"];
	}
	else {
		NSLog(@"DropBox: Already Linked");
		
		[self setupStore];
	}

}

//Delegate methods called when download is complete
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath{
	
	SKPaymentTransaction *transaction = [AppManager getObjectForKey:@"transaction"];

	[self finishTransaction:transaction wasSuccessful:YES];

	[self showDownloadInfo:NO];
	
	[AppManager setBoolForKey:[NSString stringWithFormat:@"%@%@", downloadStoreData.bookID, kDownloadedTag] 
						Value:YES];

	downloadStoreData.isDownloaded = YES;
	downloadStoreData.isDownloading = NO;
	
	NSString *string = [NSString stringWithContentsOfFile:destPath
											  encoding:NSStringEncodingConversionAllowLossy
												 error:nil];
	NSLog(@"DropBox: File Downloaded: %@", string);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	isDownloading = NO;
	
	[aTableView reloadData];
	
	//[AppManager showAlertWithTitle:@"" message:NSLocalizedString(@"Purchase Download Complete", @"Purchase Download Complete")];	
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error{
	NSLog(@"DropBox: File Donwload Error: %@", [error localizedDescription]);

	downloadStoreData.isDownloading = NO;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	isDownloading = NO;
	[AppManager showAlertWithTitle:@"" message:NSLocalizedString(@"Connection Error", @"Connection Error")];
	
	isDownloading = NO;
	[aTableView reloadData];
	[self showDownloadInfo:NO];
}

- (void) restClientDidLogin:(DBRestClient *)client
{	
	NSLog(@"DropBox: Logged In");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self setupStore];
}

- (void) restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath
{
	NSLog(@"DropBox: Download Progress: %f", progress);
	
	isDownloading = YES;
	
	if (progressView != nil)
	{
		[progressView setProgress:progress];
	}
	
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath{
	NSLog(@"Uploaded File: %@", @"File uploaded to DropBox");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	isDownloading = NO;
	[aTableView reloadData];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error{
	NSLog(@"UploadedFile With Error: %@", [error localizedDescription]);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[AppManager showAlertWithTitle:@"" message:NSLocalizedString(@"Connection Error", @"Connection Error")];
	isDownloading = NO;
	[aTableView reloadData];
}

#pragma mark -
#pragma mark DownloadManager

- (void) downloadData:(NSData *)data
{
	[data retain];
	
	NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"books.plist"];
	BOOL success = [data writeToFile:filePath atomically:NO];
	
	if (success)
	{
		NSLog(@"DownloadManager: books.plist Download completed");
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *finalPath = [path stringByAppendingPathComponent:@"books.plist"];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath])
		{
			NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:finalPath];
			
			if (plist != nil)
			{				
				NSArray *books = [plist objectForKey:@"Books"];
				
				for (NSDictionary *dict in books)
				{
					NSString *bkid = [dict objectForKey:@"BookID"];
					NSString *bkName = [dict objectForKey:@"BookName"];
					NSLog(@"books.plist: Got Book with ID = '%@' and Name = '%@'", bkid, bkName);
										
					[productSet addObject:bkid];
					
					[bookList setValue:bkName forKey:bkid];
				}
				
				NSLog(@"books.plist: Total Books = %i", [books count]);
				
				[self requestProducts];
			}
		}
	}
}

- (void)downloadProduct:(NSData *)data
{
	
}

- (void) downloadManager:(DownloadManager *)manager didFinishWithData:(NSData *)data
{
	if (downloader == manager)
	{
		[self performSelectorOnMainThread:@selector(downloadData:) withObject:data waitUntilDone:NO];
	}
}

- (void) downloadManager:(DownloadManager *)manager didReceiveResponse:(NSURLResponse *)response
{
}

- (void) downloadManager:(DownloadManager *)manager didReceiveData:(NSData *)data
{
}

- (void) downloadManager:(DownloadManager *)manager connectionError:(NSError *)error
{
	[AppManager showAlertWithTitle:@"Download" message:NSLocalizedString(@"Connection Error", @"Connection Error")];
}




#pragma mark -
#pragma mark TableView Delegate & Data Source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIFont *cellFont;
	NSString *cellText = @"";
	
	StoreData *product = [productsList objectAtIndex:indexPath.section];
		
	if (indexPath.row == 0)
	{
		cellText = product.bookName;
	}
	else if (indexPath.row == 1)
	{
		cellText = product.price;
	}
	else if (indexPath.row == 2)
	{
		cellText = product.description;
	}
	else if (indexPath.row == 3)
	{
		if (isDownloading)
		{
			cellText = NSLocalizedString(@"Please Wait", @"Please Wait");
		}
		else {
			cellText = NSLocalizedString(@"Buy this Product", @"Buy this Product");
		}

	}
			
	cellFont = [UIFont fontWithName:@"Verdana" size:15];
	
	CGRect bounds = tableView.frame;
	
	CGSize constraintSize = CGSizeMake(bounds.size.width / 2, MAXFLOAT);
	CGSize cellSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
	return cellSize.height + 20;
	
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [productsList count];
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
	return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"StoreViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

	StoreData *product = [productsList objectAtIndex:indexPath.section];
	
	NSString *titleText = @"";
	NSString *detailText = @"";
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	switch (indexPath.row) {
		case kTableProductName:
		{
			titleText = NSLocalizedString(@"Product", @"Product");
			detailText = product.bookName;
		}
		break;

		case kTableProductPrice:
		{
			titleText = NSLocalizedString(@"Price", @"Price");
			detailText = product.price;
		}
		break;

		case kTableProductDescription:
		{
			titleText = NSLocalizedString(@"Description", @"Description");
			detailText = product.description;	
		} 
		break;
			
		case kTableProductBuy:
		{
			titleText = @"$";

			cell.selectionStyle = (!isDownloading) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;

			if (isDownloading)
			{
				detailText = NSLocalizedString(@"Please Wait", @"Please Wait");
			}
			else {
				detailText = NSLocalizedString(@"Buy this Product", @"Buy this Product");
			}
			
		} 
		break;

		default:
			break;
	}
	
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.text = titleText;
	cell.detailTextLabel.text = detailText;
	cell.detailTextLabel.numberOfLines = 0;
		
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if ([self canMakePurchases])
	{
		StoreData *product = [productsList objectAtIndex:indexPath.section];
	
		if (product.isDownloaded)
		{
			[AppManager showAlertWithTitle:@"" message:NSLocalizedString(@"Product already downloaded", @"Product already downloaded")];
		
			[tableView reloadData];

			return;
		}
		
		if (isDownloading)
		{
			return;
		}
		
		NSString *productId = product.bookID;
		NSString *productName = product.fileName;//[bookList objectForKey:@"BookName"];
		
		NSLog(@"Purchase Product: %@, %@", productId, productName);
		
		[self purchase:productId];

		[tableView reloadData];
		
		downloadFileName = productName;
		downloadStoreData = product;
		
		isDownloading = YES;
	}
	
}

#pragma mark -
#pragma mark View Delegate

- (void)dismissThisView
{
	[self cancelDownload];
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)prepareToolbars
{	
	self.navigationController.navigationBar.tintColor = [AppManager getDefaultTintColor];
	self.toolBar.tintColor = [AppManager getDefaultTintColor];

	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")
															 style:UIBarButtonItemStyleDone 
															target:self action:@selector(dismissThisView)];
	
	self.navigationItem.leftBarButtonItem = done;
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	
	self.navigationItem.rightBarButtonItem = activityButton;
	
	[activityButton release];
	[done release];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"iShamela Store", @"iShamela Store");
	
	[self prepareToolbars];
	
	isDownloading = NO;
	bookList = [[NSMutableDictionary alloc] init];
	productsList = [[NSMutableArray alloc] init];
	productSet = [[NSMutableSet alloc] init];
	downloadingList = [[NSMutableArray alloc] init];
	
	[self createDownloadInfo];
	[self showDownloadInfo:NO];
	
	[self linkDropBox];
	
	//NSString *path = [DBManager getDownloadPath:@"usoolussalaasah.aza"];
	//[self downloadFile:@"/ishamela/usoolussalaasah.aza" toPath:path];

	//[self requestProducts];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.aTableView = nil;
	self.progressView = nil;
	self.toolBar = nil;
}


- (void)dealloc {
	self.aTableView = nil;
	self.toolBar = nil;
	
	[downloadFileName release];
	[downloadingList release];
	[bookList release];
	[downloader release];
	[appDownloader release];
	[productSet release];
	[productsList release];
	[downloadLabel release];
	[progressView release];
	
    [super dealloc];
}


@end
