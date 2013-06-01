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
    UILabel *lbl =(UILabel*)[cell.contentView viewWithTag:1];
    if(!lbl)
    {
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, 280, fHeight)];
        
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:14.0];
        lbl.layer.borderWidth = 2.0;
        lbl.tag = 1;
        lbl.lineBreakMode= NSLineBreakByWordWrapping;
        lbl.numberOfLines = 10;
        [cell.contentView addSubview:lbl];
        [lbl release];
    }
    lbl.frame=CGRectMake(20, 28, 280, fHeight);
    lbl.text = sts.text;
    
    if(indexPath.row%2==0)
    {
        cell.contentView.backgroundColor= [UIColor redColor];
    }
    else
    {
        cell.contentView.backgroundColor= [UIColor blueColor];
        
    }
    //NSLog(@"lbl height %f, string: %@",fHeight,sts.text);
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
    NSLog(@"index %d, Height %f",indexPath.row,fHeight);
    return fHeight+35;
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end
