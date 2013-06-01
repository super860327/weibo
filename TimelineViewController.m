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
    //data=[[NSMutableArray alloc]init];
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
    static BOOL nibsRegistered = NO;
    CGFloat yPosition =0.0f;
    
    if(!nibsRegistered)
    {
        UINib *nib =[UINib nibWithNibName:@"StatusCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:indentify];
        nibsRegistered = YES;
    }
    
    Status *sts= [data objectAtIndex:indexPath.row];
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    cell.userName.text=sts.userName;
    
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
    UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
    CGSize size = [sts.text sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    float fHeight = size.height;
    
    yPosition=28;
    UIImageView* centerimage = (UIImageView*)[cell.contentView viewWithTag:2];
    if(!centerimage)
    {
        centerimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_center_background.png"]];
        [cell.contentView addSubview:centerimage];
        [centerimage setTag:2];
        centerimage.contentMode= UIViewContentModeScaleToFill;
        [centerimage release];
    }
    centerimage.frame = CGRectMake(0, 0, 320, fHeight+28);
    
    UIImageView* avatarimage = (UIImageView*)[cell.contentView viewWithTag:4];
    if(!avatarimage)
    {
        avatarimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon.png"]];
        avatarimage.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:avatarimage];
        [avatarimage setTag:4];
        avatarimage.contentMode= UIViewContentModeScaleToFill;
        [avatarimage release];
    }
    avatarimage.frame = CGRectMake(15, 5, 24, 24);
    
    UILabel *lblHeader =(UILabel*)[cell.contentView viewWithTag:1];
    if(!lblHeader)
    {
        lblHeader = [[UILabel alloc]init];
        lblHeader.backgroundColor=[UIColor clearColor];
        [lblHeader setFont:[UIFont fontWithName:@"Arial" size:14]];
        lblHeader.textColor=[UIColor brownColor];
        [cell.contentView addSubview:lblHeader];
    }
    lblHeader.frame=CGRectMake(45, 5, 200, 30);
    lblHeader.text = sts.userName == nil ? @"匿名" : sts.userName;
    
    UILabel *lbl =(UILabel*)[cell.contentView viewWithTag:1];
    if(!lbl)
    {
        lbl = [[UILabel alloc]init];
        lbl.backgroundColor=[UIColor clearColor];
        [lbl setFont:[UIFont fontWithName:@"Arial" size:14]];
        lbl.tag = 1;
        lbl.lineBreakMode= NSLineBreakByWordWrapping;
        lbl.numberOfLines = 10;
        [cell.contentView addSubview:lbl];
        [lbl release];
    }
    lbl.frame=CGRectMake(20, yPosition, 280, fHeight);
    lbl.text = sts.text;
    
    
    yPosition=28+fHeight;
    UIImageView* imageViewfoot = (UIImageView*)[cell.contentView viewWithTag:3];
    if(!imageViewfoot)
    {
        imageViewfoot=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"block_foot_background.png"]];
        [cell.contentView addSubview:imageViewfoot];
        [imageViewfoot setTag:3];
        [imageViewfoot release];
    }
    imageViewfoot.frame = CGRectMake(0, yPosition, 320, 15);
    
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
    return fHeight+40;
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end
