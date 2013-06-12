//
//  ImageDownload.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

@synthesize imageRecord = _imageRecord;
@synthesize delegate = _delegate;

-(id)initWithImageRecord:(ImageRecorder*)record delegate:(id<ImageDownloadComplete>)theDelegate
{
    if(self = [super init])
    {
        _imageRecord =[record retain];
        _delegate = theDelegate;
    }
    return self;
}

-(void)dealloc
{
    [_imageRecord release];
    [super dealloc];
}

-(void)main
{
    if(self.isCancelled)return;
    
    if(self.imageRecord.hasDownload)return;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageRecord.url]];
    self.imageRecord.image = [UIImage imageWithData:data];
    
    //    switch (self.imageRecord.imageType) {
    //        case TwitterImage:
    //        {
    //            if(!self.imageRecord.image)
    //            {
    //                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageRecord.url]];
    //                self.imageRecord.image = [UIImage imageWithData:data];
    //            }
    //        }
    //            break;
    //        case ReTwitterImage:
    //        {
    //            if(!self.ReTwitterImage)
    //            {
    //                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageRecord.image]];
    //                self.imageRecord.imageRetwitter=[UIImage imageWithData:data];
    //            }
    //        }
    //        default:
    //            break;
    //    }
    
    if(self.isCancelled)return;
    
    [(NSObject*)self.delegate performSelectorOnMainThread:@selector(ImageDownloadDidFinish:) withObject:self waitUntilDone:YES];
    
}

@end

