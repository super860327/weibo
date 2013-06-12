//
//  ImageRecord.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "ImageRecorder.h"

@implementation ImageRecorder

@synthesize url=_url;
@synthesize image=_image;
//@synthesize imageRetwitter=_imageRetwitter;
@synthesize indexPath=_indexPath;
@synthesize imageType=_imageType;

-(id)initWithUrl:(NSString*)url index:(NSIndexPath*)indexpath Type:(enum ImageType)imageType
{
    self=[super init];
    if(self)
    {
        _url=[url copy];
        _indexPath=[indexpath retain];
        _imageType = imageType;
    }
    return self;
}

-(BOOL)hasDownload
{
    return self.image != nil;
}

-(void)dealloc
{
    [_url release];
    [_indexPath release];
    [_image release];
    //[_imageRetwitter release];
    [super dealloc];
}
@end
