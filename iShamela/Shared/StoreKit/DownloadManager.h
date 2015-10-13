//
//  DownloadManager.h
//  iShamela
//
//  Created by Suhendra Ahmad on 2/1/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadManager;

@protocol DownloadManagerDelegate <NSObject>

@optional
- (void)downloadManager:(DownloadManager *)manager failed:(NSString *)message;
- (void)downloadManager:(DownloadManager *)manager connectionError:(NSError *)error;
- (void)downloadManager:(DownloadManager *)manager didReceiveResponse:(NSURLResponse *)response;
- (void)downloadManager:(DownloadManager *)manager didReceiveData:(NSData *)data;

@required

- (void)downloadManager:(DownloadManager *)manager didFinishWithData:(NSData *)data;

@end


@interface DownloadManager : NSObject {
	id <DownloadManagerDelegate> delegate;
	
	NSMutableData *responseData;
	NSString *fileName;
}

@property (nonatomic, retain) id <DownloadManagerDelegate> delegate;
@property (nonatomic, retain) NSString *fileName;

- (void)startDownload: (NSString *)url fileName:(NSString *)filename;

@end
