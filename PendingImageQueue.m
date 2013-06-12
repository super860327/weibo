//
//  PendingImageQueue.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "PendingImageQueue.h"

static PendingImageQueue *_instance = nil;

@implementation PendingImageQueue

@synthesize pendingdownloadimages=_pendingdownloadimages;
@synthesize downloadQueue=_downloadQueue;

-(id)init
{
    if(_instance)return _instance;
    self=[super init];
    return self;
}

+(PendingImageQueue*)instance
{
    if(!_instance)
    {
        _instance = [[PendingImageQueue alloc]init];
    }
    return _instance;
}

-(id)retain
{
    return self;
}

-(id)autorelease
{
    return self;
}

-(oneway void)release
{
}

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
    self.downloadQueue = nil;
    self.pendingdownloadimages = nil;
    [super dealloc];
}

@end
