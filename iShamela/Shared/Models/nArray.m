//
//  nArray.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/24/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "nArray.h"


@implementation nArray

@synthesize visibleCount, remainderCount;

- (id) initWithVisibleCount:(int)count
{
	if (self = [super init])
	{
		visibleCount = count;
		
		data = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) objectAtIndex:(int)index
{
	if (index >= 0 && index < [data count])
	{
		return [data objectAtIndex:index];
	}
	return nil;		
}

- (int)visibleObjectCount
{
	if ([data count] == 0)
	{
		return 0;
	}

	if (visibleCount > [data count])
	{
		visibleCount = [data count];
	}
	
	remainderCount = [data count] - visibleCount;
	
	return visibleCount;
}

- (int) remainderSwitchCount
{
	if ([data count] > 0)
	{
		return remainderCount > 0 ? 1 : 0;
	}
	
	return 0;
}

- (int) count
{
	return [data count];
}

- (void) addObject:(id)obj
{
	[data addObject:obj];
}

- (void) removeAllObjects
{
	[data removeAllObjects];
}

- (void)increaseWith:(int)step
{
	visibleCount += step;
	
	if (visibleCount > [data count])
	{
		visibleCount = [data count];
	}
	
	remainderCount = [data count] - visibleCount;
}

- (void) dealloc
{
	[data release];
	
	[super dealloc];
}

@end
