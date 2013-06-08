//
//  ViewController2.h
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoHttpManager.h"
#import "PendingImageQueue.h"
#import "ImageDownload.h"
#import "Status.h"

@interface TimelineViewController : UITableViewController<WeiBoHttpManagerDelegate,ImageDownloadComplete>
{
    NSMutableArray *data;
    WeiBoHttpManager *httpManager;
    NSMutableDictionary *imageRecords;
    PendingImageQueue *pendingImageQueue;
}
@end
