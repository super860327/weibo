//
//  OAuthWebViewController.m
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "OAuthWebViewController.h"
#import "Constants.h"
#import "WeiBoHttpManager.h"

@interface OAuthWebViewController ()

@end

@implementation OAuthWebViewController

@synthesize webV=_webV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey: USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    self.webV = [[UIWebView alloc]init];
    WeiBoHttpManager *httpManager = [[WeiBoHttpManager alloc]init];
    NSURL *url= [httpManager getOauthCodeUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [self.webV loadRequest:request];
    [request release];
    [httpManager release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webV release];
    [_webV release];
    [super dealloc];
}
@end
