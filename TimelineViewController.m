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
    data=[[NSMutableArray alloc]init];
    httpManager=[[WeiBoHttpManager alloc]initWithDelegete:self];
    [httpManager start];
    
    
    self.title =@"Super";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentify];
    
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_ACCESS_TOKEN];
    if(authToken ==nil || [self isNeedToRefreshTheToken])
    {
        OAuthWebViewController *webController = [[OAuthWebViewController alloc]initWithNibName:@"OAuthWebViewController" bundle:nil];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
        [webController release];
    }
    //[self getUserID];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUserID];
}
-(void)getHomeline:(NSMutableArray *)statusarr
{
    //    //data = [statusarr copy];
    //    for (Status *sts in statusarr) {
    //        [data addObject:sts.text];
    //    }
    data=statusarr;
    [self.tableView reloadData];
}
-(void)getUserID
{
    [httpManager getUserID];
    [httpManager getHomeline:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
}

-(BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate =[[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_EXPIRATION_DATE];
    if(expirationDate ==nil)return YES;
    
    BOOL boolValue1=(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    BOOL boolValue2=(expirationDate != nil);
    return boolValue1 && boolValue2;
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
        UINib *nib =[UINib nibWithNibName:@"Status" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:indentify];
        nibsRegistered = YES;
    }
    
    StatusCell  *cell = [tableView dequeueReusableCellWithIdentifier:indentify forIndexPath:indexPath];
    
    Status *sts= [data objectAtIndex:indexPath.row];
    cell.text.text =sts.text;
    
    return cell;
}
-(void)dealloc
{
    [httpManager release];
    [super dealloc];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
