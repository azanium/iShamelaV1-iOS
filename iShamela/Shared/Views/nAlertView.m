//
//  nAlertView.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "nAlertView.h"

@interface UITextView (Private)
-(BOOL) canBecomeFirstResponder;
@end

@implementation UITextView(Private)

-(BOOL) canBecomeFirstResponder
{
	return NO;
}

@end


@implementation nAlertView

@synthesize textView;

-(BOOL) canBecomeFirstResponder
{
	return NO;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		textView = [[UITextView alloc] initWithFrame:CGRectZero];
		textView.text = @"Wow";//self.message;
		textView.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
		textView.textColor = [UIColor blackColor];
		//[self addSubview:textView];
		
    }
    return self;
}

- (void)setFrame:(CGRect)rect
{
	rect.size.height = 310;
	[super setFrame:rect];
}

- (void)layoutSubviews
{
	CGFloat buttonTop;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIThreePartButton"]) {
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			buttonTop = view.frame.origin.y;
		}
	}
	
	buttonTop -= 7; buttonTop -= 200;
	
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(12, buttonTop, self.frame.size.width - 53, 200)];
	container.backgroundColor = [UIColor whiteColor];
	container.clipsToBounds = YES;
	[self addSubview:container];
	
	textView.frame = container.bounds;
	[container addSubview:textView];
	//return;
	/*
	UIGraphicsBeginImageContext(container.frame.size);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.9, 0.9, 0.9, 1.0);
	CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, -3), 3.0);
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
	UIImageView *imageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
	[container addSubview:imageView];
	[imageView release];
	UIGraphicsEndImageContext();
	//[super layoutSubviews];
	*/
}

- (void) drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[self layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[textView release];
		
    [super dealloc];
}


@end
