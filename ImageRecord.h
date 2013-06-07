//
//  ImageRecord.h
//  Weibo
//
//  Created by super on 13-6-6.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageRecord : NSOperation

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,retain)NSIndexPath *indexPath;

-(id)initWithName:(NSString*)name url:(NSString*)url index:(NSIndexPath*)indexpath;

-(BOOL)hasDownload;

@end
