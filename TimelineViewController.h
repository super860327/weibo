//
//  ViewController2.h
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoHttpManager.h"

@interface TimelineViewController : UITableViewController<WeiBoHttpManagerDelegate>
{
    NSMutableArray *data;
    WeiBoHttpManager *httpManager;
}
@end
