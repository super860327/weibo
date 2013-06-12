//
//  StatusCell.h
//  Weibo
//
//  Created by super on 13-5-25.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "ImageRecorder.h"
#import "ImageDownloader.h"
#import "PendingImageQueue.h"

@interface StatusCell : UITableViewCell
{
    id<ImageDownloadComplete> _delegate;
}

//@property (retain, nonatomic) IBOutlet UILabel *userName;
//@property (retain, nonatomic) IBOutlet UIImageView *profile_image;
//@property (retain, nonatomic) IBOutlet UITextView *ContentView;
//@property (retain, nonatomic) IBOutlet UILabel *textContent;
@property (nonatomic,copy)  NSString* thumbnail_pic_url;

-(void)setupCell:(Status*)sts indexPath:(NSIndexPath*)indexPath theDelegate:(id<ImageDownloadComplete>)delegate;

@end
