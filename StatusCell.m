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

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_userName release];
    [_profile_image release];
    [_ContentView release];
    [_textContent release];
    [super dealloc];
}
@end
