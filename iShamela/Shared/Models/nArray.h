//
//  nArray.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/24/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nArray : NSObject {
@private
	NSMutableArray *data;
	int visibleCount;
	int remainderCount;
	
}

@property (nonatomic, assign) int visibleCount;
@property (nonatomic, assign) int remainderCount;

- (id)initWithVisibleCount:(int)count;
- (id)objectAtIndex:(int)index;
- (int)visibleObjectCount;
- (int)count;
- (void)addObject:(id)obj;
- (void)increaseWith:(int)step;
- (void)removeAllObjects;
- (int)remainderSwitchCount;

@end
