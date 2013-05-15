//
//  WeiBoHttpManager.m
//  Weibo
//
//  Created by super on 13-5-13.
//  Copyright (c) 2013年 super. All rights reserved.
//

#import "WeiBoHttpManager.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"

@implementation WeiBoHttpManager

@synthesize authToken;
@synthesize requestQueue;

-(id)init
{
    self=[super init];
    if(self)
    {
        requestQueue = [[ASINetworkQueue alloc]init];
        [requestQueue setRequestDidFinishSelector:@selector(requestDidFinish)];
        [requestQueue setRequestDidFailSelector:@selector(requestDidFail)];
    }
    return self;
}
-(void)dealloc
{
    [requestQueue release];
    [super dealloc];
}
-(void)requestDidFinish:(ASIHTTPRequest*)request
{
//    request.requestID
}

-(void)requestDidFail:(ASIHTTPRequest*)request
{
    NSInteger errorCode= [[request error] code];
    NSLog(@"Error Code: %i, Error Message: %@", errorCode, request.error);
}


-(NSURL*)getOauthCodeUrl //留给webview用
{
    //https://api.weibo.com/oauth2/authorize
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   SINA_APP_KEY,                    @"client_id",       //申请的appkey
								   @"token",                        @"response_type",   //access_token
								   @"http://hi.baidu.com/jt_one",   @"redirect_uri",    //申请时的重定向地址
								   @"mobile",                       @"display",         //web页面的显示方式
                                   nil];
	
	NSURL *url = [self generateURL:SINA_API_AUTHORIZE params:params];
    return url;
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
			[escaped_value release];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}
-(void)getUserID
{
    //https://api.weibo.com/2/account/get_uid.json
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    NSString                *baseUrl = [NSString  stringWithFormat:@"%@/account/get_uid.json",SINA_V2_DOMAIN];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:SinaGetUserID];
    [requestQueue addOperation:request];
    [request release];
}
- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(RequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:dict];
    [dict release];
}

@end
