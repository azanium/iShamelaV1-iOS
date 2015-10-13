//
//  LanguagesViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Translator;

@interface LanguageViewController : UITableViewController {

	Translator *translator;
	UIBarButtonItem *langButton;
}

@property (nonatomic, retain) UIBarButtonItem *langButton;
@property (nonatomic, retain) Translator *translator;

@end
