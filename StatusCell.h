//
//  StatusCell.h
//  Weibo
//
//  Created by super on 13-5-25.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *txtContent;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UIImageView *profile_image;
// retweeted_status.text
// retweeted_status.bmiddle_pic
@end
