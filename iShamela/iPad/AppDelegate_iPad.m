//
//  AppDelegate_iPad.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "DBManager.h"
#import "AppManager.h"
#import "DropboxSDK.h"

@implementation AppDelegate_iPad

@synthesize window;
@synthesize splitViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	//	NSLog(@"View = %d", view);	
	//	[DBManager copyBuiltInDBFiles:@"baitsulhatsis.aza"];
	//	[DBManager copyBuiltInDBFiles:@"silsilahsahihalbany.aza"];
	//	[DBManager copyBuiltInDBFiles:@"tadribarrowi.aza"];
	//	[DBManager copyBuiltInDBFiles:@"tahdzibuttahdzib.aza"];
	//	[DBManager copyBuiltInDBFiles:@"taqributtahdzib.aza"];
	//[DBManager copyBuiltInDBFiles:@"sharahbulugulmaram.aza"];
	
#if defined(LITE_SAHIH_MUSLIM)
	
	[DBManager copyBuiltInDBFiles:@"sahihmuslim.aza"];
	
#elif defined(LITE_RIYAD_US_SALIHEEN)
	
	[DBManager copyBuiltInDBFiles:@"riyadsaleheen.aza"];
	
#else 
	[DBManager copyBuiltInDBFiles:@"tafsiribnkatsir.aza"];	
	[DBManager copyBuiltInDBFiles:@"adabmufrad.aza"];
	[DBManager copyBuiltInDBFiles:@"arbaunnawawi.aza"];
	[DBManager copyBuiltInDBFiles:@"riyadsaleheen.aza"];
	[DBManager copyBuiltInDBFiles:@"sahihmuslim.aza"];
	[DBManager copyBuiltInDBFiles:@"bulugulmaram.aza"];
	[DBManager copyBuiltInDBFiles:@"umdatulahkaam.aza"];
	[DBManager copyBuiltInDBFiles:@"taisir.aza"];
#endif
		
	DBSession* dbSession = 
	[[[DBSession alloc]
	  initWithConsumerKey:[AppManager dropBoxKey]
	  consumerSecret:[AppManager dropBoxSecret]]
	 autorelease];
    [DBSession setSharedSession:dbSession];
	
	[window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[splitViewController release];
    [window release];
    [super dealloc];
}


@end
