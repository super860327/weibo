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
    
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    Status *sts= [data objectAtIndex:indexPath.row];
    cell.txtContent.text =sts.text;
    cell.userName.text=sts.userName;
    cell.profile_image.image = sts.imageView;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240.0f;
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end
