//
//  PendingImageQueue.h
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingImageQueue : NSOperation

@property (nonatomic,retain)NSMutableDictionary *pendingdownloadimages;
@property (nonatomic,retain)NSOperationQueue *downloadQueue;

@end
