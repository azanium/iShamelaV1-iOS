//
//  AppManager.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/19/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_FONT_SIZE 16

#define HOME_VIEW 0
#define TOC_VIEW 1
#define CHAPTER_VIEW 2
#define CONTENT_VIEW 3

@interface AppManager : NSObject {

}

+ (NSInteger)maxCharPerRow;
+ (NSString *)getCharsPerRow:(NSString *)text;
+ (UIFont *)getDefaultBoldFont;
+ (UIFont *)getDefaultFont;
+ (void)hideTableViewFooter:(UITableView *)tableView;

+ (void)setDefaultLanguageCode:(NSString *)code;
+ (NSString *)getDefaultLanguageCode;

+ (UIColor *)getDefaultTintColor;
+ (NSInteger) getDefaultIncreaseCount;

+ (NSInteger)getDefaultView;
+ (void)setDefaultView:(NSInteger)view;
+ (NSInteger)getDefaultAppView;
+ (void)setDefaultAppView:(NSInteger)view;

+ (NSDictionary *)getDefaultDictionary;
+ (void)setDefaultDictionary:(NSDictionary *)dictionary;

+ (NSInteger)getDefaultTOCRow;
+ (void)setDefaultTOCRow:(NSInteger)row;

+ (NSString *)getDefaultDBFileName;
+ (void)setDefaultDBFileName:(NSString *)filename;
+ (NSString *)getDefaultBookId;
+ (void)setDefaultBookId:(NSString *)bkId;
+ (NSString *)getDefaultDBStartId;
+ (void)setDefaultDBStartId:(NSString *)startId;
+ (NSString *)getDefaultDBEndId;
+ (void)setDefaultDBEndId:(NSString *)endId;

+ (BOOL)getBoolForKey:(NSString *)key;
+ (void)setBoolForKey:(NSString *)key Value:(BOOL)value;

+ (id)getObjectForKey:(NSString *)key;
+ (void)setObjectForKey:(NSString *)key Value:(id)value;

+ (NSString *)getAdMobsPublisherID;

+ (NSString *)dropBoxKey;
+ (NSString *)dropBoxSecret;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
