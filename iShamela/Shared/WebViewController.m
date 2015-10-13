    //
//  WebViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "Book.h"
#import "BookContent.h"
#import "TapDetectingWindow.h"
#import "nAlertView.h"
#import "LanguagesViewController.h"
#import "LangData.h"
#import "AppManager.h"

@implementation WebViewController

@synthesize dataList, webView, book, startID, endID, titleText, loadDB, pageIndex, languageButton;
@synthesize activityView;


#pragma mark -
#pragma mark Translator

- (void)translate
{
	NSString *selection = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];

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

- (void) translator:(Translator *)sender didFinishWithText:(NSString *)result
{
	[activityView stopAnimating];
	
	nAlertView *alert = [[nAlertView alloc] initWithTitle:NSLocalizedString(@"Translation", @"Translation")
												  message:nil
												 delegate:self
										cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button")
										otherButtonTitles:nil];
	alert.textView.text = result;
	[alert show];
	[alert release];

}

#pragma mark -
#pragma mark WebView delegate

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
#pragma mark DB Manager

- (void) dbPrepare:(DBManager *)manager
{
	if (manager == dbManager)
	{
		[dataList removeAllObjects];
		
		[actionSheet showInView:self.view];
	}
}

- (void) dbFinalize:(DBManager *)manager
{
	if (manager == dbManager)
	{
		pageIndex = 1;
		if ([dataList count] > 0)
		{
			[self displayPage:1];
		}
		
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
}

-(BOOL) dbGotRecord:(DBManager *)manager Statement:(sqlite3_stmt *)stmt Object:(NSObject *)data
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

#pragma mark -
#pragma mark Initialization

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

- (void)updateStatus
{
	statusLabel.text = [NSString stringWithFormat:@"%i / %i", pageIndex, [dataList count]];
}

- (void)displayPage:(NSInteger)page
{
	BookContent *content = [dataList objectAtIndex:page - 1];

	NSString *html = @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=4.0;'/><div align='right'><P STYLE='word-wrap:break-word;width:100%;right:0;alignment:center' alight='center'>";
	html = [html stringByAppendingString:content.nash];
	html = [html stringByAppendingString:@"</P></div></meta>"];

	[webView loadHTMLString:html baseURL:nil];

	[self updateStatus];
}

- (void)nextPage:(id)sender
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

- (void)prevPage:(id)sender
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

- (void) userDidTapWebView:(NSArray *)tapPoint 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.navigationController.toolbarHidden = !self.navigationController.toolbarHidden;
	self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
	[UIView commitAnimations];
}

- (void)displayLanguageView
{
	LanguageViewController *lvc = [[LanguageViewController alloc] initWithStyle:UITableViewStylePlain];
	lvc.translator = translator;
	lvc.langButton = languageButton;
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:lvc];
	
	[self.navigationController presentModalViewController:nvc animated:YES];
	[lvc release], lvc = nil;
	[nvc release], nvc = nil;
}

- (void)prepareToolbars
{
	UIBarButtonItem *flexi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];// initWithTitle:@"Hello" style:UIBarButtonSystemItemAction target:nil action:nil];//:statusLabel];//BarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
	UIBarButtonItem *prev = [[UIBarButtonItem alloc] init];
	prev.target = self; prev.action = @selector(prevPage:);
	prev.image = [UIImage imageNamed:@"leftarrow.png"];
	
	UIBarButtonItem *next = [[UIBarButtonItem alloc] init];
	next.target = self; next.action = @selector(nextPage:);
	next.image = [UIImage imageNamed:@"rightarrow.png"];
	
	[translator selectLanguage:[AppManager getDefaultLanguageCode]];
	
	languageButton = [[UIBarButtonItem alloc] initWithTitle:[translator selectedLanguage].langCode
													  style:UIBarButtonItemStyleBordered 			  
													 target:self 
													 action:@selector(displayLanguageView)];
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	/*
	UIImageView *imageBookmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookmarksClicked-32.png"]];
	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithCustomView:imageBookmark];
	bookmark.target = self; bookmark.action = @selector(addBookmark:);
	*/
	self.toolbarItems = [NSArray arrayWithObjects:languageButton, flexi, prev, fixed, next, flexi, activityButton, nil];
//	self.navigationItem.rightBarButtonItem = bookmark;
	
	[flexi release], [prev release], [fixed release], [flexi release];	
	[activityButton release];
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
	
#if defined(LITE_VERSION)
	self.contentView = webView;
	[super createAdOnTop:NO];
#endif
	
	translator = [[Translator alloc] init];
	translator.delegate = self;
	
	UIMenuController *menuController = [UIMenuController sharedMenuController];
	UIMenuItem *translate = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"Translate Text Selection") action:@selector(translate)];

	[menuController setMenuItems:[NSArray arrayWithObjects:translate, nil]];
	
	[translate release];
		
	CGRect frame = self.navigationController.toolbar.frame;
	statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, frame.size.height)];
	statusLabel.text = @"-";
	statusLabel.textAlignment = UITextAlignmentCenter;
	statusLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	statusLabel.textColor = [UIColor whiteColor];
	statusLabel.backgroundColor = [UIColor clearColor];
	
	langLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, frame.size.height)];
	langLabel.text = @"id";
	langLabel.textAlignment = UITextAlignmentCenter;
	langLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	langLabel.textColor = [UIColor whiteColor];
	langLabel.backgroundColor = [UIColor clearColor];

	[self prepareToolbars];
	
	NSString *loadingStr = NSLocalizedString(@"Loading...", @"Loading...");
	actionSheet = [[UIActionSheet alloc] initWithTitle:loadingStr delegate:nil cancelButtonTitle:nil 
								destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	webSheet = [[UIActionSheet alloc] initWithTitle:loadingStr delegate:nil cancelButtonTitle:nil 
								destructiveButtonTitle:nil otherButtonTitles:nil];
	webSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	CGRect f = webSheet.frame;
	f.origin.y = 0;
	webSheet.frame = f;
	
	//tapWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	//tapWindow.viewToObserve = webView;
	//tapWindow.controllerThatObserves = self;
	
	self.title = self.titleText;

	
	dbManager = [[DBManager alloc] init];
	dbManager.delegate = self;
	
	if (self.loadDB)
	{
		dataList = [[NSMutableArray alloc] init];

		NSString *sql = [NSString stringWithFormat:
						 @"SELECT * FROM b%@ WHERE id>=%@ AND id<%@",
						 book.bkId, startID, endID];
		
		if ([startID isEqualToString:endID])
		{
			sql = [NSString stringWithFormat:
				   @"SELECT * FROM b%@ WHERE id=%@",
				   book.bkId, startID];		
		}
		
		[dbManager fetchRecordsAsync:book.fileName Query:sql];
	}
	else {
		if (pageIndex < 1)
		{	
			pageIndex = 1;
		}
		[self displayPage:pageIndex];
	}

}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[AppManager setDefaultView:CONTENT_VIEW];
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view ifs it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.webView = nil;
}


- (void)dealloc {
	self.view = nil;
	self.contentView = nil;

	[dataList release];
	[webView release];
	[dbManager release];
	[book release];
	[startID release];
	[endID release];
	[actionSheet release];
	[statusLabel release];
	[webSheet release];
	[translator release];
	[langLabel release];
	[languageButton release];
	[activityView release];
	
    [super dealloc];
}


@end
