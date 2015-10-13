//
//  WifiSharingViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/21/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPServer;
@class RootViewController;

@interface WifiSharingViewController : UIViewController {
	UILabel *titleLabel;
	UILabel *statusLabel;
	UISwitch *switchOnOff;
	
	HTTPServer *httpServer;
	NSDictionary *addresses;
	RootViewController *rootViewController;
}

@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UISwitch *switchOnOff;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

- (IBAction)startStopSharing:(id)sender;

- (void)startServer:(BOOL)started;
- (void)initServer;
- (void)displayInfoUpdate:(NSNotification *)notification;


@end
