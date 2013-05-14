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

#define USER_STORE_ACCESS_TOKEN     @"SinaAccessToken"
#define DID_GET_TOKEN_IN_WEB_VIEW @"didGetTokenInWebView"

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
    
    // self.webV = [[UIWebView alloc]init];
    WeiBoHttpManager *httpManager = [[WeiBoHttpManager alloc]init];
    NSURL *url= [httpManager getOauthCodeUrl];
    NSLog(@"URL: %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    self.webV.delegate = self;
    [self.webV loadRequest:request];
    [request release];
    [httpManager release];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result =YES;
    NSURL *url = [request URL];
    NSArray *array =[[url absoluteString]componentsSeparatedByString:@"#"];
    if([array count]>1)
    {
        [self dialogDidSucceed:url];
        result = NO;
    }
    
    return result;
}
-(void)dialogDidSucceed:(NSURL*)url
{
    NSString *q = [url absoluteString];
   NSString *token = [self getStringFromUrl:q needle:@"access_token="];
    
    //用户点取消 error_code=21330
    NSString *errorCode = [self getStringFromUrl:q needle:@"error_code="];
    if (errorCode != nil && [errorCode isEqualToString: @"21330"]) {
        NSLog(@"Oauth canceled");
    }
    
    NSString *refreshToken  = [self getStringFromUrl:q needle:@"refresh_token="];
    NSString *expTime       = [self getStringFromUrl:q needle:@"expires_in="];
    NSString *uid           = [self getStringFromUrl:q needle:@"uid="];
    NSString *remindIn      = [self getStringFromUrl:q needle:@"remind_in="];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSDate *expirationDate =nil;
    NSLog(@"jtone \n\ntoken=%@\nrefreshToken=%@\nexpTime=%@\nuid=%@\nremindIn=%@\n\n",token,refreshToken,expTime,uid,remindIn);
    if (expTime != nil) {
        int expVal = [expTime intValue]-3600;
        if (expVal == 0)
        {
            
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
			NSLog(@"jtone time = %@",expirationDate);
        }
    }
    if (token) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web view load error: %@",error.description);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.webV release];
    [_webV release];
    [super dealloc];
}
@end
