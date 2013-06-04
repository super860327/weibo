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
    CGFloat yPosition =0.0f;
    
    Status *sts= [data objectAtIndex:indexPath.row];
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell)
    {
        cell = [[StatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
    UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
    CGSize size = [sts.text sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    float lblContentHeight = size.height;
    
    yPosition=5;
    int tag=1;
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
    avatarimage.image=[UIImage imageNamed:@"Icon.png"];
    avatarimage.frame = CGRectMake(15, yPosition, 24, 24);
    
    tag = tag+1;
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
    lblHeader.frame=CGRectMake(45, yPosition, 200, 30);
    lblHeader.text = sts.userName == nil ? @"匿名" : sts.userName;
    
    yPosition=28;
    tag = tag+1;
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
    float s= lblContentHeight;
    lbl.frame=CGRectMake(20, yPosition, 280, s);
    lbl.text = sts.text;
    
    tag = tag+1;
    yPosition=yPosition+lblContentHeight;
    if(sts.thumbnail_pic_url.length != 0)
    {
        UIImage* image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sts.thumbnail_pic_url]]];
        UIImageView* imageViewThumbnail = (UIImageView*)[cell.contentView viewWithTag:tag];
        if(!imageViewThumbnail)
        {
            imageViewThumbnail=[[UIImageView alloc]init];
            [cell.contentView addSubview:imageViewThumbnail];
            [imageViewThumbnail setTag:tag];
            [imageViewThumbnail release];
        }
        imageViewThumbnail.image=image;
        imageViewThumbnail.frame = CGRectMake((cell.frame.size.width-120)/2, yPosition, 120, 90);
    }
    else
    {
        UIImageView* imageViewThumbnail = (UIImageView*)[cell.contentView viewWithTag:tag];
        imageViewThumbnail.frame=CGRectMake(0, 0, 0, 0);
    }
    
    yPosition=28;
    tag = tag+1;
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
    if(sts.thumbnail_pic_url.length!=0) lblContentHeight = lblContentHeight+90.f;
    centerimage.frame = CGRectMake(0, 0, 320, lblContentHeight + yPosition);
    
    yPosition=centerimage.frame.origin.y + centerimage.frame.size.height;
    tag = tag+1;
    UIImageView* imageViewfoot = (UIImageView*)[cell.contentView viewWithTag:tag];
    if(!imageViewfoot)
    {
        imageViewfoot=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_foot_background.png"]];
        [cell.contentView addSubview:imageViewfoot];
        [imageViewfoot setTag:tag];
        [imageViewfoot release];
    }
    imageViewfoot.frame = CGRectMake(0, yPosition, 320, 15);
    cell.backgroundColor=[UIColor clearColor];
    return cell;
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
        fHeight=fHeight+90.f;
    }
    return fHeight+43;
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end
