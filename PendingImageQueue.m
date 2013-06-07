//
//  PendingImageQueue.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "PendingImageQueue.h"

@implementation PendingImageQueue

@synthesize pendingdownloadimages=_pendingdownloadimages;
@synthesize downloadQueue=_downloadQueue;

-(NSOperationQueue*)downloadQueue
{
    if(!_downloadQueue)
    {
        _downloadQueue = [[NSOperationQueue alloc]init];
    }
    return _downloadQueue;
}

-(NSMutableDictionary*)pendingdownloadimages
{
    if(!_pendingdownloadimages)
    {
        _pendingdownloadimages = [[NSMutableDictionary alloc]init];
    }
    return _pendingdownloadimages;
}

-(void)dealloc
{
    self.downloadQueue=nil;
    self.pendingdownloadimages = nil;
    [super dealloc];
}

@end
