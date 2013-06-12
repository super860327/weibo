//
//  ImageRecord.h
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ImageType{ TwitterImage, ReTwitterImage};

@interface ImageRecorder : NSObject

@property (nonatomic,copy,readonly)NSString *url;
@property (nonatomic,strong)UIImage *image;
//@property (nonatomic,strong)UIImage *imageRetwitter;
@property (nonatomic,copy,readonly)NSIndexPath *indexPath;
@property (nonatomic,assign,readonly)enum ImageType imageType;

-(id)initWithUrl:(NSString*)url index:(NSIndexPath*)indexpath Type:(enum ImageType)imageType;

-(BOOL)hasDownload;

@end

