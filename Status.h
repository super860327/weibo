//
//  Status.h
//  Weibo
//
//  Created by super on 13-5-22.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject

@property long long statusId;
@property (nonatomic,strong) NSNumber *statusKey;
@property time_t createdAt;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) UIImage *imageView;
@property (nonatomic,copy) NSString *thumbnail_pic_url;

@property (nonatomic,copy)NSString *retwitterText;
@property (nonatomic,copy) NSString *retwitterThumbnail_pic_url;

-(Status*)initWithJSONDictionary:(NSDictionary *)dic;

@end
