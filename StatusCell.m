//
//  StatusCell.m
//  Weibo
//
//  Created by super on 13-5-25.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "StatusCell.h"

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://tp1.sinaimg.cn/1686879832/50/1283204498/1"]]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_txtContent release];
    [_userName release];
    [_profile_image release];
    [_profile_image2 release];
    [super dealloc];
}
@end
