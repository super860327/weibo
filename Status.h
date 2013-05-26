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
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) UIImage *imageView;

-(Status*)initWithJSONDictionary:(NSDictionary *)dic;

@end
