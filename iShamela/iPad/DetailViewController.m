    //
//  DetailViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "AppManager.h"
#import "AboutViewController.h"
#import "Book.h"
#import "BookContent.h"
#import "DBManager.h"
#import "nAlertView.h"
#import "LangData.h"
#import "LanguagesViewController.h"
#import "WifiSharingViewController.h"
#import "RootViewController_iPad.h"
#import "StoreViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end


@implementation DetailViewController

@synthesize imageView;
@synthesize adMobViewController;
@synthesize translateView;
@synthesize rootViewController;
@synthesize toolbar;
@synthesize popoverController;
@synthesize statusLabel, webView, dbManager, translator, dataList;
@synthesize activityView, actionSheet;



#pragma mark -
#pragma mark Shopping

- (void)shopping
{

	StoreViewController *storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreView" bundle:[NSBundle mainBundle]];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:storeViewController];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release], navController = nil;
	[storeViewController release], storeViewController = nil;
}


#pragma mark -
#pragma mark Web View Delegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	statusLabel.text = NSLocalizedString(@"Loading", @"Loading Web View");
	
	return YES;
	
}

-(void) webViewDidFinishLoad:(UIWebView *)web
{
	[self updateStatus];
}

#pragma mark -
#pragma mark Translator


- (void)translate
{		
	NSString *selection = [NSString stringWithFormat:@"%@", [self.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"]];
	
	[UIMenuController sharedMenuController].menuVisible = NO;
	
	[self.webView stringByEvaluatingJavaScriptFromString:@"document.selection.empty();"];
	
	[activityView startAnimating];
	
	[translator doTranslate:selection FromLang:@"ar" ToLang:[translator selectedLanguage].langCode];
}


- (void) translator:(Translator *)sender ConnectionError:(NSError *)error
{
	[activityView stopAnimating];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:NSLocalizedString(@"Translate Connection Error", @"Translator Conection Error") 
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) translator:(Translator *)sender Failed:(NSString *)message
{ 
	[activityView stopAnimating];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:NSLocalizedString(@"Translate Failed HTTP:200", @"Translator error 200") 
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)displayResult:(NSString *)result
{
/*	UIAlertView *alert = [[nAlertView alloc] initWithTitle:NSLocalizedString(@"Translation", @"Translation")
												   message:nil
												  delegate:self
										 cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button")
										 otherButtonTitles:nil];
*/	//	alert.textView.text = [NSString stringWithFormat:@"%@", result];
	
	NSString *rhtml = [NSString stringWithFormat:@"<body><hr>%@</body>", result];
	[self.translateView loadHTMLString:rhtml baseURL:nil];
	
/*	AboutViewController *avc = [[AboutViewController alloc] init];
	avc.isDefault = NO;
	avc.titleText = NSLocalizedString(@"Translation", @"Translation");
	avc.content = rhtml;
	
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:avc];
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:nvc animated:YES];
	
	[nvc release];
	[avc release];
*/	
	
//	[alert show];
//	[alert release];	
}

- (void) translator:(Translator *)sender didFinishWithText:(NSString *)result
{
	[activityView stopAnimating];
	
	[self performSelectorOnMainThread:@selector(displayResult:) withObject:result waitUntilDone:NO];
}

#pragma mark -
#pragma mark DB Manager

- (void) dbPrepare:(DBManager *)manager
{
	if (manager == dbManager)
	{
		if (dataList == nil)
		{
			dataList = [[NSMutableArray alloc] init];
		}
		[dataList removeAllObjects];
		
		[actionSheet showInView:self.view];
	}
}

- (BOOL) dbGotRecord:(DBManager *)manager Statement:(sqlite3_stmt *)stmt Object:(NSObject *)obj
{
	if (manager == dbManager)
	{
		const char *bookID = (char *)sqlite3_column_text(stmt, 0);
		const char *bookNass = (char *)sqlite3_column_text(stmt, 1);
		const char *bookPart = (char *)sqlite3_column_text(stmt, 2);
		const char *bookPage = (char *)sqlite3_column_text(stmt, 3);
		const char *bookHNo = (char *)sqlite3_column_text(stmt, 4);
		
		BookContent *content = [BookContent bookWithId:(char *)bookID Nash:(char *)bookNass Part:(char *)bookPart Page:(char *)bookPage HNo:(char *)bookHNo];
		
		[dataList addObject:content];	
	}
	
	return YES;
}

- (void) dbFinalize:(DBManager *)manager
{
	if (manager == dbManager)
	{
		pageIndex = 1;
		if ([dataList count] > 0)
		{
			[self displayPage:pageIndex];
		}
		
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void) queryWithStartWithBook:(Book *)book StartID:(NSString *)startId EndID:(NSString *)endId
{
	NSString *sql = [NSString stringWithFormat:
					 @"SELECT * FROM b%@ WHERE id>=%@ AND id<%@",
					 book.bkId, startId, endId];
	
	if ([startId isEqualToString:endId])
	{
		sql = [NSString stringWithFormat:
			   @"SELECT * FROM b%@ WHERE id=%@",
			   book.bkId, startId];		
	}
	
	[dbManager fetchRecordsAsync:book.fileName Query:sql];
	
	if (popoverController != nil)
	{
		[popoverController dismissPopoverAnimated:YES];
	}	
}

- (void) queryWithPageIndex:(NSInteger)index DataList:(NSMutableArray *)list
{
	self.dataList = list;
	
	if (index < 1)
	{	
		index = 1;
	}
	pageIndex = index;
	
	[self displayPage:pageIndex];	

	if (popoverController != nil)
	{
		[popoverController dismissPopoverAnimated:YES];
	}
}

#pragma mark -
#pragma mark Split View 

- (void)updateStatus
{
	statusLabel.text = [NSString stringWithFormat:@"%i / %i", pageIndex, [dataList count]];
}

- (void) displayPage:(NSInteger)index
{
	BookContent *content = [dataList objectAtIndex:index - 1];
	
	NSString *html = @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=4.0;'/><div align='right'><P STYLE='word-wrap:break-word;width:100%;right:0;alignment:center' alight='center'>";
	html = [html stringByAppendingString:content.nash];
	html = [html stringByAppendingString:@"</P></div></meta>"];
	
	[webView loadHTMLString:html baseURL:nil];
	
	if (webView.hidden)
	{
		webView.hidden = NO;
		translateView.hidden = NO;
	}
	
	if ([dataList count] > 0)
	{
		if (prev.enabled == NO)
		{
			prev.enabled = YES;
		}
		
		if (next.enabled == NO)
		{
			next.enabled = YES;
		}
	}
	
	[self updateStatus];	
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
	if ([toolbar.items containsObject:barButtonItem])
	{
		NSMutableArray *items = [[toolbar items] mutableCopy];
		[items removeObject:barButtonItem];
		[toolbar setItems:items animated:YES];
		[items release];
	}
	
	self.popoverController = nil;
}

- (void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc 
{
	if ([[toolbar items] objectAtIndex:0] != barButtonItem)
	{
		barButtonItem.title = NSLocalizedString(@"Library", @"Library");

		NSMutableArray *items = [[toolbar items] mutableCopy];
		[items insertObject:barButtonItem atIndex:0];
		[toolbar setItems:items animated:YES];
		[items release];
	}
	self.popoverController = pc;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)nextPage
{
	pageIndex++;
	if (pageIndex > [dataList count])
	{
		pageIndex = [dataList count];
	}
	else 
	{
		[self displayPage:pageIndex];
	}
}

- (void)prevPage
{
	pageIndex--;
	if (pageIndex < 1)
	{
		pageIndex = 1;
	}
	else 
	{
		[self displayPage:pageIndex];
	}
}

- (void)displayAbout
{
	AboutViewController *avc = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:[NSBundle mainBundle]];
	avc.isDefault = YES;
	
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:avc];
	
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:nvc animated:YES];
	
	[nvc release];
	[avc release];
}

- (void)displayLanguageView
{
	LanguageViewController *lvc = [[LanguageViewController alloc] initWithStyle:UITableViewStylePlain];
	lvc.translator = translator;
	lvc.langButton = languageButton;

	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:lvc];
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:nvc animated:YES];
	[lvc release], lvc = nil;
	[nvc release], nvc = nil;
}

- (void)wifiSharing
{
	if (popoverController != nil)
	{
		[popoverController dismissPopoverAnimated:YES];
	}	
	
	WifiSharingViewController *wvc = [[WifiSharingViewController alloc] initWithNibName:@"WifiSharingView" bundle:[NSBundle mainBundle]];

	wvc.rootViewController = self.rootViewController;;
	
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:wvc];
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:nvc animated:YES];
	[wvc release];
	[nvc release];
}

- (void)prepareToolbar
{
	UIBarButtonItem *flexi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
	UIBarButtonItem *about = [[UIBarButtonItem alloc] init];
	about.target = nil; about.action = @selector(displayAbout);
	about.image = [UIImage imageNamed:@"iPhone_Help.png"];
	
	prev = [[UIBarButtonItem alloc] init];
	prev.target = self; prev.action = @selector(prevPage);
	prev.image = [UIImage imageNamed:@"leftarrow.png"];
	prev.enabled = NO;
	
	next = [[UIBarButtonItem alloc] init];
	next.target = self; next.action = @selector(nextPage);
	next.image = [UIImage imageNamed:@"rightarrow.png"];
	next.enabled = NO;
	
	UIBarButtonItem *status = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];

	[translator selectLanguage:[AppManager getDefaultLanguageCode]];
	
	languageButton = [[UIBarButtonItem alloc] initWithTitle:[translator selectedLanguage].langCode
													  style:UIBarButtonItemStyleBordered 			  
													 target:self 
													 action:@selector(displayLanguageView)];
	UIBarButtonItem *shopping = [[UIBarButtonItem alloc] init];
	shopping.image = [UIImage imageNamed:@"shopping_trolley-32.png"];
	shopping.target = self; shopping.action = @selector(shopping);
	
	
#if defined(LITE_SAHIH_MUSLIM)
	
	[toolbar setItems:[NSArray arrayWithObjects:languageButton, flexi, prev, status, next, flexi, activityButton, shopping, about, nil]];
	
#else
	
	UIBarButtonItem *wifi = [[UIBarButtonItem alloc] init];
	wifi.target = self; wifi.action = @selector(wifiSharing);
	wifi.image = [UIImage imageNamed:@"wireless32.png"];
	
	[toolbar setItems:[NSArray arrayWithObjects:languageButton, flexi, prev, status, next, flexi, activityButton, shopping, wifi, about, nil]];
	[wifi release];
	
#endif
	
	[shopping release];
	[activityButton release];
	[status release];
	[flexi release], [flexi release];
	[about release];
	[languageButton release];
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
	if (action == @selector(translate))
	{
		return YES;
	}
	return NO;		
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		 
	translator = [[Translator alloc] init];
	translator.delegate = self;

	UIMenuController *menuController = [UIMenuController sharedMenuController];
	UIMenuItem *translate = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"Translate Text Selection") action:@selector(translate)];
	
	[menuController setMenuItems:[NSArray arrayWithObjects:translate, nil]];	
	[translate release];
	
	dataList = [[NSMutableArray alloc] init];
	self.toolbar.tintColor = [AppManager getDefaultTintColor];
	
	statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.toolbar.frame.size.height)];
	statusLabel.text = NSLocalizedString(@"iShamela", @"iShamela App Name");
	statusLabel.textAlignment = UITextAlignmentCenter;
	statusLabel.font = [UIFont boldSystemFontOfSize:17];
	statusLabel.textColor = [UIColor whiteColor];
	statusLabel.backgroundColor = [UIColor clearColor];
	
	webView.hidden = YES;
	webView.delegate = self;
	translateView.hidden = YES;
	
	NSString *loadingStr = NSLocalizedString(@"Loading...", @"Loading...");
	actionSheet = [[UIActionSheet alloc] initWithTitle:loadingStr delegate:nil cancelButtonTitle:nil 
								destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;	
	
	[self prepareToolbar];
	
	dbManager = [[DBManager alloc] init];
	dbManager.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	self.popoverController = nil;
	self.toolbar = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.adMobViewController = nil;
	
	[popoverController release];
	[toolbar release];
	[prev release];
	[next release];
	[statusLabel release];
	[webView release];
	[dbManager release];
	[dataList release];
	[translator release];
	[activityView release];
	[actionSheet release];
	[languageButton release];
	[rootViewController release];
	[translateView release];
	
    [super dealloc];
}


@end
