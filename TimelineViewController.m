//
//  ViewController2.m
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "TimelineViewController.h"
#import "Constants.h"
#import "OAuthWebViewController.h"
#import "WeiBoHttpManager.h"
#import "Status.h"
#import "StatusCell.h"
#import "QuartzCore/QuartzCore.h"
#import "PendingImageQueue.h"
#import "ImageRecord.h"
#import "ImageDownload.h"

#define indentify @"Cell"

@interface TimelineViewController()

@end

@implementation TimelineViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    httpManager=[[WeiBoHttpManager alloc]initWithDelegete:self];
    imageRecords=[[NSMutableDictionary alloc]init];
    pendingImageQueue=[[PendingImageQueue alloc]init];
    [httpManager start];
    
    self.title =@"Super";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentify];
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_ACCESS_TOKEN];
    if(authToken == nil || [self isNeedToRefreshTheToken])
    {
        OAuthWebViewController *webController = [[OAuthWebViewController alloc]initWithNibName:@"OAuthWebViewController" bundle:nil];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
        [webController release];
    }
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getUserID];
}
-(void)getHomeline:(NSMutableArray *)statusarr
{
    data = statusarr;
    [self.tableView reloadData];
}
-(void)getUserID
{
    [httpManager getUserID];
    [httpManager getHomeline:0 maxID:0 count:20 page:1 baseApp:0 feature:0];
}

-(BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate =[[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_EXPIRATION_DATE];
    
    return (expirationDate == nil || NSOrderedAscending == [expirationDate compare:[NSDate date]]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = 0;
    
    Status *sts= [data objectAtIndex:indexPath.row];
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell)
    {
        cell = [[StatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	[self setupAvatarImage :cell status:sts theTag:++tag thePosition:CGPointMake(15, 5) ];
    [self setupUserName:cell status:sts theTag:++tag thePosition:CGPointMake(45, 5)];
    CGFloat textHeight = [self setupTwitterText:cell status:sts theTag:++tag thePosition:CGPointMake(20, 28)];
    CGFloat imageHeight = [self setupTwitterImage:cell :indexPath :sts :++tag :CGPointMake(20, textHeight + 28)];
    [self setupCellBackgroundImage:cell :28 + imageHeight + textHeight :sts :++tag :CGPointMake(0, 0) ];
	[self setupCellFooterImage:cell :++tag :CGPointMake(0, 28 + imageHeight + textHeight)];
	
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)setupUserName:(UITableViewCell*)cell status:(Status*)sts theTag:(NSInteger) tag thePosition:(CGPoint) position
{
    UILabel *lblHeader =(UILabel*)[cell.contentView viewWithTag:tag];
    if(!lblHeader)
    {
        lblHeader = [[UILabel alloc]init];
        lblHeader.backgroundColor=[UIColor clearColor];
        [lblHeader setFont:[UIFont fontWithName:@"Arial" size:14]];
        lblHeader.textColor=[UIColor brownColor];
        [cell.contentView addSubview:lblHeader];
        lblHeader.tag = tag;
    }
    lblHeader.frame=CGRectMake(position.x, position.y, 200, 30);
    lblHeader.text = sts.userName.length == 0 ? @"匿名" : sts.userName;
}

-(void)setupAvatarImage:(UITableViewCell*)cell status:(Status*)sts theTag:(NSInteger) tag thePosition:( CGPoint) position
{
	UIImageView* avatarimage = (UIImageView*)[cell.contentView viewWithTag:tag];
    if(!avatarimage)
    {
        avatarimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon.png"]];
        avatarimage.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:avatarimage];
        [avatarimage setTag:tag];
        avatarimage.contentMode= UIViewContentModeScaleToFill;
        [avatarimage release];
    }
    avatarimage.frame = CGRectMake(position.x, position.y, 24, 24);
}

-(CGFloat)setupTwitterText:(UITableViewCell*)cell status:(Status *)sts theTag:(NSInteger)tag thePosition:(CGPoint)position
{
	UILabel *lbl =(UILabel*)[cell.contentView viewWithTag:tag];
    if(!lbl)
    {
        lbl = [[UILabel alloc]init];
        lbl.backgroundColor=[UIColor clearColor];
        [lbl setFont:[UIFont fontWithName:@"Arial" size:14]];
        lbl.tag = tag;
        lbl.lineBreakMode= NSLineBreakByWordWrapping;
        lbl.numberOfLines = 10;
        [cell.contentView addSubview:lbl];
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

-(CGFloat)setupTwitterImage:(UITableViewCell*)cell :(NSIndexPath*)indexPath :(Status *)sts :(NSInteger) tag :(CGPoint) position
{
    CGFloat height =0;
	if(sts.thumbnail_pic_url.length == 0)
    {
	    UIImageView *imageViewThumbnail = (UIImageView*)[cell.contentView viewWithTag:tag];
        if(imageViewThumbnail)
        {
		    imageViewThumbnail.hidden = YES;
            imageViewThumbnail.frame = CGRectMake(0,0,0,0);
        }
    }
    else
    {
        ImageRecord *record = [imageRecords objectForKey:sts.thumbnail_pic_url];
        if(record && record.image)
        {
            UIImage* image= record.image;
            UIImageView *imageViewThumbnail = (UIImageView*)[cell.contentView viewWithTag:tag];
            if(!imageViewThumbnail)
            {
                imageViewThumbnail=[[UIImageView alloc]init];
                [cell.contentView addSubview:imageViewThumbnail];
                [imageViewThumbnail setTag:tag];
                [imageViewThumbnail release];
            }
            imageViewThumbnail.hidden = NO;
            imageViewThumbnail.image = image;
            CGFloat w = image.size.width;
            height = image.size.height;
            imageViewThumbnail.frame = CGRectMake((cell.frame.size.width-w)/2, position.y, w, height);//do some fix
        }
        else
		{
            NSString *pic_url=[pendingImageQueue.pendingdownloadimages objectForKey:sts.thumbnail_pic_url];
            if (!pic_url)
			{
                ImageRecord *record=[[ImageRecord alloc]initWithName:sts.thumbnail_pic_url url:sts.thumbnail_pic_url index:indexPath];
                ImageDownload *load = [[ImageDownload alloc]initWithImageRecord:record delegate:self];
                [pendingImageQueue.downloadQueue addOperation:load];
                [imageRecords setObject:record forKey:record.url];
                [record release];
                [load release];
            }
        }
    }
    return height;
}

-(CGFloat)setupCellBackgroundImage:(UITableViewCell*)cell :(CGFloat)lblContentHeight :(Status *)sts :(NSInteger) tag :(CGPoint) position
{
	UIImageView* centerimage = (UIImageView*)[cell.contentView viewWithTag:tag];
    if(!centerimage)
    {
        centerimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_center_background.png"]];
        [cell.contentView addSubview:centerimage];
        [centerimage setTag:tag];
        centerimage.contentMode= UIViewContentModeScaleToFill;
        [cell.contentView sendSubviewToBack:centerimage];
        [centerimage release];
    }
    if(sts.thumbnail_pic_url.length!=0)
    {
        ImageRecord *record = [imageRecords objectForKey:sts.thumbnail_pic_url];
        if(record.image)
        {
            lblContentHeight = lblContentHeight;
        }
    }
    centerimage.frame = CGRectMake(0, 0, 320, lblContentHeight + position.y);
    return lblContentHeight;
}

-(CGFloat)setupCellFooterImage:(UITableViewCell*)cell :(NSInteger) tag :(CGPoint) position
{
    CGFloat height = 15;
	UIImageView* imageViewfoot = (UIImageView*)[cell.contentView viewWithTag:tag];
    if(!imageViewfoot)
    {
        imageViewfoot=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_foot_background.png"]];
        [cell.contentView addSubview:imageViewfoot];
        [imageViewfoot setTag:tag];
        [imageViewfoot release];
    }
    imageViewfoot.frame = CGRectMake(position.x, position.y, 320, height);
	return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status *sts= [data objectAtIndex:indexPath.row];
    
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
    
    UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
    CGSize size = [sts.text sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    float fHeight = size.height;
    if(sts.thumbnail_pic_url.length != 0)
    {
        ImageRecord *record = [imageRecords objectForKey:sts.thumbnail_pic_url];
        if(record && record.image)
        {
            fHeight=fHeight+record.image.size.height;
        }
    }
    return fHeight + 28 + 15;
}

-(void)ImageDownloadDidFinish:(ImageDownload *)download
{
    UIImage* image= download.imageRecord.image;
    ImageRecord *record = [imageRecords objectForKey:download.imageRecord.url];
    if(record)
    {
        record.image = image;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:download.imageRecord.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end

