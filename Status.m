//
//  Status.m
//  Weibo
//
//  Created by super on 13-5-22.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "Status.h"

@implementation Status

@synthesize statusId=_statusId;
@synthesize statusKey=_statusKey;
@synthesize createdAt =_createdAt;
@synthesize text =_text;
@synthesize userName=_userName;
@synthesize imageView=_imageView;
@synthesize thumbnail_pic=_thumbnail_pic;

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
-(Status*)initWithJSONDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        self.statusId= [self getLongLongValueForKey:dic Key:@"id" delaultValue:-1];
        self.statusKey =[[NSNumber alloc]initWithLongLong:self.statusId];
        self.createdAt=[self getTimeValueForKey:dic Key:@"created_at" defaultValue:0];
        self.text =[self getStringValueForKey:dic Key:@"text" defaultValue:@""];
        
        NSString *thumb=[self getStringValueForKey:dic Key:@"thumbnail_pic" defaultValue:@""];
        if(thumb)
        {
            //self.thumbnail_pic=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]]];
        }
        
        NSDictionary* userDic = [dic objectForKey:@"user"];
		if (userDic)
        {
            self.userName=[self getStringValueForKey:userDic Key:@"name" defaultValue:@""];
            NSString *image_url=[self getStringValueForKey:userDic Key:@"profile_image_url" defaultValue:@""];
            //self.imageView = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
        }
    }
    return self;
}

-(long long)getLongLongValueForKey:(NSDictionary*)dic Key:(NSString*)key delaultValue:(long long)defaultValue
{
    return [dic objectForKey:key]==[NSNull null]?defaultValue:[[dic objectForKey:key]longLongValue];
}

- (time_t)getTimeValueForKey:(NSDictionary*)dic Key:(NSString *)key defaultValue:(time_t)defaultValue {
    NSString *stringTime   = [dic objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}

-(NSString *)getStringValueForKey:(NSDictionary*)dic Key:(NSString *)key defaultValue:(NSString *)defaultValue {
    return [dic objectForKey:key] == nil || [dic objectForKey:key] == [NSNull null]
    ? defaultValue : [dic objectForKey:key];
}
@end
