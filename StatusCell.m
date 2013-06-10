//
//  StatusCell.m
//  Weibo
//
//  Created by super on 13-5-25.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "StatusCell.h"
#import "PendingImageQueue.h"
#import "ImageDownload.h"

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupCell:(Status*)sts indexPath:(NSIndexPath*)indexPath theDelegate:(id<ImageDownloadComplete>)delegate
{
    NSInteger tag = 0;
	CGFloat height = 0;
    CGFloat nextPositionY = 0;
    
    _delegate = delegate;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor clearColor];
    
    [self setupAvatarImage:sts theTag:++tag thePosition:CGPointMake(15, 5) ];
    [self setupUserName:sts theTag:++tag thePosition:CGPointMake(45, 5)];
	
	nextPositionY = 30;
    height = [self setupTwitterText:sts theTag:++tag thePosition:CGPointMake(20, nextPositionY)];
    
	nextPositionY += height;
    height = [self setupTwitterImage :indexPath :sts :++tag :CGPointMake(20, nextPositionY)];
	
	nextPositionY += height;
    height = [self setupReTwitterImage:indexPath :sts :++tag :CGPointMake(0, nextPositionY)];
	
	nextPositionY += height;
    height =[self setupReTwitterText:sts theTag:++tag thePosition:CGPointMake(20, nextPositionY)];
	
	nextPositionY += height;
    [self setupCellBackgroundImage :nextPositionY :sts :++tag :CGPointMake(0, 0) ];
	
	[self setupCellFooterImage :++tag :CGPointMake(0, nextPositionY)];
    
}

-(void)setupUserName:(Status*)sts theTag:(NSInteger) tag thePosition:(CGPoint) position
{
    UILabel *lblHeader =(UILabel*)[self.contentView viewWithTag:tag];
    if(!lblHeader)
    {
        lblHeader = [[UILabel alloc]init];
        lblHeader.backgroundColor=[UIColor clearColor];
        [lblHeader setFont:[UIFont fontWithName:@"Arial" size:14]];
        lblHeader.textColor=[UIColor brownColor];
        [self.contentView addSubview:lblHeader];
        lblHeader.tag = tag;
    }
    lblHeader.frame=CGRectMake(position.x, position.y, 200, 30);
    lblHeader.text = sts.userName.length == 0 ? @"匿名" : sts.userName;
}

-(void)setupAvatarImage:(Status*)sts theTag:(NSInteger) tag thePosition:( CGPoint) position
{
	UIImageView* avatarimage = (UIImageView*)[self.contentView viewWithTag:tag];
    if(!avatarimage)
    {
        avatarimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon.png"]];
        avatarimage.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:avatarimage];
        [avatarimage setTag:tag];
        avatarimage.contentMode= UIViewContentModeScaleToFill;
        [avatarimage release];
    }
    avatarimage.frame = CGRectMake(position.x, position.y, 24, 24);
}

-(CGFloat)setupTwitterText:(Status *)sts theTag:(NSInteger)tag thePosition:(CGPoint)position
{
	UILabel *lbl =(UILabel*)[self.contentView viewWithTag:tag];
    if(!lbl)
    {
        lbl = [[UILabel alloc]init];
        lbl.backgroundColor=[UIColor clearColor];
        [lbl setFont:[UIFont fontWithName:@"Arial" size:14]];
        lbl.tag = tag;
        lbl.lineBreakMode= NSLineBreakByWordWrapping;
        lbl.numberOfLines = 10;
        [self.contentView addSubview:lbl];
        [lbl release];
    }
	float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
    UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
    CGSize size = [sts.text sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    lbl.frame=CGRectMake(position.x, position.y, 280, size.height);
    lbl.text = sts.text;
	return size.height;
}

-(CGFloat)setupTwitterImage:(NSIndexPath*)indexPath :(Status *)sts :(NSInteger) tag :(CGPoint) position
{
    CGFloat height =0;
	if(sts.thumbnail_pic_url.length == 0)
    {
	    UIImageView *imageViewThumbnail = (UIImageView*)[self.contentView viewWithTag:tag];
        if(imageViewThumbnail)
        {
		    imageViewThumbnail.hidden = YES;
            imageViewThumbnail.frame = CGRectMake(0,0,0,0);
        }
    }
    else
    {
        ImageRecord *record = [[PendingImageQueue instance].pendingdownloadimages objectForKey:sts.thumbnail_pic_url];
        if(record)
        {
            if (record.image)
            {
                UIImage* image= record.image;
                UIImageView *imageViewThumbnail = (UIImageView*)[self.contentView viewWithTag:tag];
                if(!imageViewThumbnail)
                {
                    imageViewThumbnail=[[UIImageView alloc]init];
                    [self.contentView addSubview:imageViewThumbnail];
                    [imageViewThumbnail setTag:tag];
                    [imageViewThumbnail release];
                }
                imageViewThumbnail.hidden = NO;
                imageViewThumbnail.image = image;
                CGFloat w = image.size.width;
                height = image.size.height;
                imageViewThumbnail.frame = CGRectMake((self.frame.size.width-w)/2, position.y, w, height);//do some fix
            }
        }
        else
        {
            NSString *pic_url=[[PendingImageQueue instance].pendingdownloadimages objectForKey:sts.thumbnail_pic_url];
            if (!pic_url)
            {
                PendingImageQueue *q = [PendingImageQueue instance];
                ImageRecord *record=[[ImageRecord alloc]initWithName:sts.thumbnail_pic_url url:sts.thumbnail_pic_url index:indexPath];
                ImageDownload *load = [[ImageDownload alloc]initWithImageRecord:record delegate:_delegate];
                [q.downloadQueue addOperation:load];
                [q.pendingdownloadimages setObject:record forKey:record.url];
                [record release];
                [load release];
            }
        }
    }
    return height;
}

-(CGFloat)setupReTwitterImage:(NSIndexPath*)indexPath :(Status *)sts :(NSInteger) tag :(CGPoint) position
{
    CGFloat height =15;
	if(sts.retwitterText == nil || sts.retwitterText.length == 0)
    {
	    UIImageView *imageViewReTwitter = (UIImageView*)[self.contentView viewWithTag:tag];
        if(imageViewReTwitter)
        {
		    imageViewReTwitter.hidden = YES;
            imageViewReTwitter.frame = CGRectMake(0,0,0,0);
            
        }
        height = 0;
    }
    else
    {
        UIImageView *imageViewReTwitter = (UIImageView*)[self.contentView viewWithTag:tag];
        
        if(!imageViewReTwitter)
        {
            imageViewReTwitter = [[UIImageView alloc]init];
            imageViewReTwitter.image = [UIImage imageNamed:@"timeline_rt_border_t.png"];
            imageViewReTwitter.tag = tag;
            [self.contentView addSubview:imageViewReTwitter];
        }
        imageViewReTwitter.frame = CGRectMake(position.x, position.y, 280, height);
        imageViewReTwitter.hidden = NO;
    }
    
    return height;
}

-(CGFloat)setupReTwitterText:(Status *)sts theTag:(NSInteger)tag thePosition:(CGPoint)position
{
    CGFloat height = 0;
    if(sts.retwitterText)
    {
        UILabel *lbl =(UILabel*)[self.contentView viewWithTag:tag];
        if(!lbl)
        {
            lbl = [[UILabel alloc]init];
            lbl.backgroundColor=[UIColor clearColor];
            [lbl setFont:[UIFont fontWithName:@"Arial" size:14]];
            lbl.tag = tag;
            lbl.lineBreakMode= NSLineBreakByWordWrapping;
            lbl.numberOfLines = 10;
            [self.contentView addSubview:lbl];
            [lbl release];
        }
        float fPadding = 16.0; // 8.0px x 2
        CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
        UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
        CGSize size = [sts.retwitterText sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        lbl.frame=CGRectMake(position.x, position.y, 280, size.height);
        lbl.text = sts.retwitterText;
        height=size.height;
    }
    else
    {
        UILabel *lbl =(UILabel*)[self.contentView viewWithTag:tag];
        if(lbl)
        {
            lbl.frame=CGRectMake(position.x, position.y, 0, 0);
            lbl.text =@"";
        }
    }
	return height;
}

-(CGFloat)setupCellBackgroundImage:(CGFloat)lblContentHeight :(Status *)sts :(NSInteger) tag :(CGPoint) position
{
	UIImageView* centerimage = (UIImageView*)[self.contentView viewWithTag:tag];
    if(!centerimage)
    {
        centerimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_center_background.png"]];
        [self.contentView addSubview:centerimage];
        [centerimage setTag:tag];
        centerimage.contentMode= UIViewContentModeScaleToFill;
        [self.contentView sendSubviewToBack:centerimage];
        [centerimage release];
    }
    if(sts.thumbnail_pic_url.length!=0)
    {
        ImageRecord *record =[[PendingImageQueue instance].pendingdownloadimages objectForKey:sts.thumbnail_pic_url];
        if(record)
        {
            if(record.image)
            {
                lblContentHeight = lblContentHeight;
            }
        }
    }
    centerimage.frame = CGRectMake(0, 0, 320, lblContentHeight + position.y);
    return lblContentHeight;
}

-(CGFloat)setupCellFooterImage:(NSInteger) tag :(CGPoint) position
{
    CGFloat height = 15;
	UIImageView* imageViewfoot = (UIImageView*)[self.contentView viewWithTag:tag];
    if(!imageViewfoot)
    {
        imageViewfoot=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_foot_background.png"]];
        [self.contentView addSubview:imageViewfoot];
        [imageViewfoot setTag:tag];
        [imageViewfoot release];
    }
    imageViewfoot.frame = CGRectMake(position.x, position.y, 320, height);
	return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    // Configure the view for the selected state
}

- (void)dealloc
{
    [_userName release];
    [_profile_image release];
    [_ContentView release];
    [_textContent release];
    [super dealloc];
}
@end
