//
//  WeiBoHttpManagerDelegate.h
//  Weibo
//
//  Created by super on 13-5-27.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeiBoHttpManagerDelegate<NSObject>

-(void)getHomeline:(NSMutableArray*)statusarr;

@end