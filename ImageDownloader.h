//
//  ImageDownload.h
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageRecorder.h"

@protocol ImageDownloadComplete;

@interface ImageDownloader : NSOperation

@property(nonatomic,strong)ImageRecorder *imageRecord;
@property(nonatomic,assign)id<ImageDownloadComplete> delegate;

-(id)initWithImageRecord:(ImageRecorder*)record delegate:(id<ImageDownloadComplete>) theDelegate;

@end

@protocol ImageDownloadComplete <NSObject>

-(void)ImageDownloadDidFinish:(ImageDownloader*)download;
@end

