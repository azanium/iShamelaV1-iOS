//
//  nCell.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/6/10.
//  Copyright 2010 Azacode Inc. All rights reserved.
//

#import "nCell.h"


@implementation nCell

#pragma mark -
#pragma mark Properties

@synthesize primaryLabel;
@synthesize secondaryLabel;
@synthesize icon;
@synthesize level;

#pragma mark -
#pragma mark UITableViewCell 

- (id)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		
		CGRect bounds = self.contentView.bounds;
		CGRect f;
		
		// Initialization code
		UIView *view = [[UIView alloc] init];
		view.frame = self.contentView.frame;
		view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		view.opaque = YES;
		
		f = CGRectMake(0, 0, bounds.size.width - 15, bounds.size.height);

		primaryLabel = [[UILabel alloc] initWithFrame:f];
		primaryLabel.backgroundColor = [UIColor clearColor];
		primaryLabel.textAlignment = UITextAlignmentRight;
		primaryLabel.font = [UIFont systemFontOfSize:15];
		primaryLabel.contentMode = UIViewContentModeRight;
		
		secondaryLabel = [[UILabel alloc] init];
		secondaryLabel.backgroundColor = [UIColor clearColor];
		secondaryLabel.textAlignment = UITextAlignmentRight;
		secondaryLabel.font = [UIFont systemFontOfSize:14];
		secondaryLabel.textColor = [UIColor darkGrayColor];
		
		icon = [[UIImageView alloc] init];		

		[view addSubview:primaryLabel];

		[self.contentView addSubview:view];
		[view release];

		bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient.png"]];
		bgImage.contentMode = UIViewContentModeScaleToFill;
		self.backgroundView = bgImage;
		[bgImage release];
				
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		cellStyle = 1;
		
	}
	
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {


		// Initialization code
		UIView *view = [[UIView alloc] init];
		view.frame = self.contentView.frame;
		view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
		view.opaque = YES;
		
		primaryLabel = [[UILabel alloc] init];
		primaryLabel.backgroundColor = [UIColor clearColor];
		primaryLabel.textAlignment = UITextAlignmentRight;
		primaryLabel.font = [UIFont boldSystemFontOfSize:15];
	
		
		secondaryLabel = [[UILabel alloc] init];
		secondaryLabel.backgroundColor = [UIColor clearColor];
		secondaryLabel.textAlignment = UITextAlignmentRight;
		secondaryLabel.font = [UIFont systemFontOfSize:11];
		secondaryLabel.textColor = [UIColor darkGrayColor];
		
		icon = [[UIImageView alloc] init];		
		
		[view addSubview:primaryLabel];
		[view addSubview:secondaryLabel];
		[view addSubview:icon];
		
		bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient.png"]];
		bgImage.contentMode = UIViewContentModeScaleToFill;
		self.backgroundView = bgImage;
		[bgImage release];

		[self.contentView addSubview:view];
		[view release];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		cellStyle = 0;
    }
    return self;
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	
	if (!self.editing)
	{
	
	CGRect bounds = self.contentView.bounds;
	CGRect f;
	
	if (cellStyle == 0)
	{
		
		f = CGRectMake(bounds.size.width - 35, 8, 32, 32);
		icon.frame = f;
				
		f = CGRectMake(0, 3, bounds.size.width - 40, 32);
		primaryLabel.frame = f;

		f = CGRectMake(0, 35, bounds.size.width - 40, 15);
		secondaryLabel.frame = f;		
	}
	else if (cellStyle == 1)
	{
		float offset = level == 0 ? 0 : 5;
		f = CGRectMake(0, 0, bounds.size.width - offset, bounds.size.height);
		
		UIColor *color = level == 0 ? [UIColor blackColor] : [UIColor darkGrayColor];
		primaryLabel.frame = f;
		primaryLabel.textColor = color;
	}
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	for (UIView *view in self.contentView.subviews)
	{
		view.backgroundColor = [UIColor clearColor];
	}
}

- (void)dealloc {
	[primaryLabel release];
	[secondaryLabel release];
	[icon release];
	
    [super dealloc];
}


@end
