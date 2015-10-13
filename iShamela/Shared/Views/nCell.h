//
//  nCell.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface nCell : UITableViewCell {
	UILabel *primaryLabel;
	UILabel *secondaryLabel;
	UIImageView *icon;
	UIImageView *bgImage;
	NSInteger level;
	NSInteger cellStyle;
}

@property (nonatomic, retain) UILabel *primaryLabel;
@property (nonatomic, retain) UILabel *secondaryLabel;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, assign) NSInteger level;

- (id)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
