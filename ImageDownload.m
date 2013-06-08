//
//  ImageDownload.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload

@synthesize imageRecord = _imageRecord;
@synthesize delegate = _delegate;

-(id)initWithImageRecord:(ImageRecord*)record delegate:(id<ImageDownloadComplete>)theDelegate
{
    if(self=[super init])
    {
        self.imageRecord = record;
        //NSLog(@"1. %@",self.imageRecord.indexPath);
        self.delegate = theDelegate;
    }
    return self;
}

-(void)main
{
    if(self.isCancelled)return;
    
    if(self.imageRecord.hasDownload)return;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageRecord.url]];
    self.imageRecord.image = [UIImage imageWithData:data];
    
    if(self.isCancelled)return;
   
    [(NSObject*)self.delegate performSelectorOnMainThread:@selector(ImageDownloadDidFinish:) withObject:self waitUntilDone:YES];
    
}

@end

