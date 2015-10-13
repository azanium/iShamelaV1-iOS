//
//  AppManager.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <iAd/ADBannerView.h>
#import "AppManager.h"
#import "DropboxSDK.h"

@implementation AppManager


static NSInteger gDefaultView = 0;

+ (NSInteger)maxCharPerRow
{
	return 200;
}

+ (NSString *)getCharsPerRow:(NSString *)text
{
	if ([text length] < [AppManager maxCharPerRow])
	{
		return [NSString stringWithString:text];
	}
		
	return [[text substringToIndex:[AppManager maxCharPerRow]] stringByAppendingString:@"\n..."];
}

+ (UIFont *)getDefaultBoldFont
{
	return [UIFont boldSystemFontOfSize:DEFAULT_FONT_SIZE];
}

+ (UIFont *)getDefaultFont
{
	return [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
}

+ (void)setDefaultLanguageCode:(NSString *)code
{
	[[NSUserDefaults standardUserDefaults] setValue:code forKey:@"DefaultLang"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDefaultLanguageCode
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] valueForKey:@"DefaultLang"];
}

+ (UIColor *)getDefaultTintColor
{
	return [UIColor colorWithRed:153/255.0 green:102/255.0 blue:51/255.0 alpha:0.5];
}


+ (NSInteger) getDefaultIncreaseCount {
	
	NSInteger c = [[NSUserDefaults standardUserDefaults] integerForKey:@"increase_step"];
	if (c == 0)
	{
		c = 50;
		[[NSUserDefaults standardUserDefaults] setInteger:c forKey:@"increase_step"];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	return c;
}


+ (NSInteger) getDefaultView
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"View"];
}

+ (void)setDefaultView:(NSInteger)view
{
	[[NSUserDefaults standardUserDefaults] setInteger:view forKey:@"View"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger) getDefaultAppView
{
	return gDefaultView;
}

+ (void) setDefaultAppView:(NSInteger)view
{
	gDefaultView = view;
}

+ (NSInteger) getDefaultTOCRow
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"TOCRow"];
}

+ (void) setDefaultTOCRow:(NSInteger)row
{
	[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"TOCRow"];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSDictionary *) getDefaultDictionary
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Dictionary"];
	
	if (dic == nil)
	{
		dic = [[[NSDictionary alloc] init] autorelease];
	}
	
	return dic;
}

+ (void) setDefaultDictionary:(NSDictionary *)dictionary
{
	[[NSUserDefaults standardUserDefaults] setValue:dictionary forKey:@"Dictionary"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)hideTableViewFooter:(UITableView *)tableView
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
	view.backgroundColor = [UIColor clearColor];
	[tableView setTableFooterView:view];
	[view release];
}


+ (NSString *)getDefaultDBFileName
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"DBFileName"];
}

+ (void)setDefaultDBFileName:(NSString *)filename
{
	[[NSUserDefaults standardUserDefaults] setValue:filename forKey:@"DBFileName"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDefaultBookId
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"BookId"];
}

+ (void)setDefaultBookId:(NSString *)bkId
{
	[[NSUserDefaults standardUserDefaults] setValue:bkId forKey:@"BookId"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDefaultDBStartId
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"DBStartId"];
}

+ (void)setDefaultDBStartId:(NSString *)startId
{
	[[NSUserDefaults standardUserDefaults] setValue:startId forKey:@"DBStartId"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDefaultDBEndId
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"DBEndId"];
}

+ (void)setDefaultDBEndId:(NSString *)endId
{
	[[NSUserDefaults standardUserDefaults] setValue:endId forKey:@"DBEndId"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getBoolForKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] synchronize];

	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setBoolForKey:(NSString *)key Value:(BOOL)value
{
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObjectForKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObjectForKey:(NSString *)key Value:(id)value
{
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getAdMobsPublisherID
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return @"a14d4264d1e45ad"; // iPad
	}
	return @"a14d42b672839c9"; // iPhone
}

+ (NSString *)dropBoxKey
{
    return @"ph2e7ju9xswofbc";
}

+ (NSString *)dropBoxSecret
{
	return @"jygnauionrkxilj";
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message 
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release], alert = nil;
}

@end
