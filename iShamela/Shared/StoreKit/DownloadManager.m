//
//  DownloadManager.m
//  iShamela
//
//  Created by Suhendra Ahmad on 2/1/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "DownloadManager.h"


@implementation DownloadManager


@synthesize delegate;
@synthesize fileName;

#pragma mark -
#pragma mark NSURLConnection delegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
	
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(downloadManager:didReceiveResponse:)])
		{
			[self.delegate downloadManager:self didReceiveResponse:response];
		}
	}
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData setData:data];
	
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(downloadManager:didReceiveData:)])
		{
			[self.delegate downloadManager:self didReceiveData:data];
		}
	}	
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	[connection release];
	
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(downloadManager:failed:)])
		{
			
			[self.delegate downloadManager:self connectionError:error];
		}
	}
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
		
	if (self.delegate)
	{		
		if ([self.delegate respondsToSelector:@selector(downloadManager:didFinishWithData:)])
		{
			// delegate should retain data
			[self.delegate downloadManager:self didFinishWithData:responseData];
		}
	}
	
	[responseData release];
}


#pragma mark -
#pragma mark DownloadManager

- (void)startDownload:(NSString *)url fileName:(NSString *)filename
{
	self.fileName = filename;
	
	responseData = [[NSMutableData data] retain];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark Memory Allocations


- (id)init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}


- (void)dealloc
{
	[fileName release];
	[responseData release];
	
	[super dealloc];
}

@end
