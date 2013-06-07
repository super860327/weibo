//
//  ImageDownload.h
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageRecord.h"
@protocol ImageDownloadComplete;

@interface ImageDownload : NSOperation

@property(nonatomic,strong)ImageRecord *imageRecord;
@property(nonatomic,assign)id<ImageDownloadComplete> delegate;

-(id)initWithImageRecord:(ImageRecord*)record delegate:(id<ImageDownloadComplete>) theDelegate;

@end

@protocol ImageDownloadComplete <NSObject>

-(void)ImageDownloadDidFinish:(ImageDownload*)download;
@end