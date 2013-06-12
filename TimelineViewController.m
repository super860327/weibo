//
//  ViewController2.m
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "TimelineViewController.h"
#import "Constants.h"
#import "OAuthWebViewController.h"
#import "StatusCell.h"
#import "ImageRecorder.h"


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
    [self.tableView registerClass:[StatusCell class] forCellReuseIdentifier:indentify];
    
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
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    Status *sts =[data objectAtIndex:indexPath.row];
    [cell setupCell:sts indexPath:indexPath theDelegate:self];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%i",indexPath.row);
    Status *sts= [data objectAtIndex:indexPath.row];
    
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(280 - fPadding, CGFLOAT_MAX);
    
    UIFont *cellFont =  [UIFont systemFontOfSize:14.0];
    CGSize size = [sts.text sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    float fHeight = size.height;
    if(sts.thumbnail_pic_url.length != 0)
    {
        
        ImageRecorder *record = [[PendingImageQueue instance].pendingdownloadimages objectForKey:sts.thumbnail_pic_url];
        if(record && record.image)
        {
            fHeight=fHeight+record.image.size.height;
        }
    }
    if(sts.retwitterThumbnail_pic_url.length != 0)
    {
        
        ImageRecorder *record = [[PendingImageQueue instance].pendingdownloadimages objectForKey:sts.retwitterThumbnail_pic_url];
        if(record && record.image)
        {
            fHeight=fHeight+record.image.size.height;
        }
    }
    
    if(sts.retwitterText.length != 0)
    {
        fHeight = fHeight + 15;
        size = [sts.retwitterText sizeWithFont:cellFont  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        fHeight = fHeight + size.height;
    }
    return fHeight + 28 + 15;
}

-(void)ImageDownloadDidFinish:(ImageDownloader *)download
{
    //UIImage* image= download.imageRecord.image;
    ImageRecorder *record = [[PendingImageQueue instance].pendingdownloadimages objectForKey:download.imageRecord.url];
    if(record)
    {
        NSLog(@"%@",record == download.imageRecord? @"YES":@"NO");
        //NSLog(@"%@",record.url);
//        NSLog(@"%@",record.indexPath);
//        NSLog(@"%i",record.indexPath.row);
        //record.image = image;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:record.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)dealloc
{
    [data release];
    [httpManager release];
    [super dealloc];
}

@end
