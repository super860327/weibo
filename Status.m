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
@synthesize thumbnail_pic_url=_thumbnail_pic;
@synthesize retwitterText=_retwitterText;
@synthesize retwitterThumbnail_pic_url=_retwitterThumbnail_pic_url;

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
        
       self.thumbnail_pic_url =[self getStringValueForKey:dic Key:@"thumbnail_pic" defaultValue:@""];
        
        NSDictionary* userDic = [dic objectForKey:@"user"];
		if (userDic)
        {
            self.userName = [self getStringValueForKey:userDic Key:@"name" defaultValue:@""];
        }
        NSDictionary *reTwitter = [dic objectForKey:@"retweeted_status"];
        if(reTwitter)
        {
            self.retwitterText = [self getStringValueForKey:reTwitter Key:@"text" defaultValue:@""];
            self.retwitterThumbnail_pic_url=[self getStringValueForKey:reTwitter Key:@"thumbnail_pic" defaultValue:@""];
            //if(self.retwitterThumbnail_pic_url)NSLog(@"url:%@",self.retwitterThumbnail_pic_url);
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
