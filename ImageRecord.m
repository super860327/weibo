//
//  ImageRecord.m
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "ImageRecord.h"

@implementation ImageRecord

@synthesize name=_name;
@synthesize url=_url;
@synthesize image=_image;
@synthesize indexPath=_indexPath;

-(id)initWithName:(NSString*)name url:(NSString*)url index:(NSIndexPath*)indexpath
{
    self=[super init];
    if(self)
    {
        self.name=name;
        self.url=url;
        self.indexPath=indexpath;
    }
    return self;
}

-(BOOL)hasDownload
{
    return self.image != nil;
}
@end
