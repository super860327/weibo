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
#import "SBJsonParser.h"
#import "Status.h"

@implementation WeiBoHttpManager

@synthesize authToken;
@synthesize requestQueue;

-(id)init
{
    self=[super init];
    if(self)
    {
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        //[requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
    }
    return self;
}
-(void)dealloc
{
    [requestQueue release];
    [super dealloc];
}
- (void)start
{
	if( [requestQueue isSuspended] )
		[requestQueue go];
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    //    request.requestID
    NSLog(@"%@", request.responseString);
    NSDictionary *userInformation =[request userInfo];
    RequestType requestType =[[userInformation objectForKey:USER_INFO_KEY_TYPE]intValue];
    NSString *responseString=[request responseString];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    id returnObject =[parser objectWithString:responseString];
    [parser release];
    
    if([returnObject isKindOfClass:[NSDictionary class]])
    {
        //        NSString *errorString = [returnObject objectForKey:@""];
    }
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    else {
        return;
    }
    switch (requestType)
    {
        case SinaGetUserID:
        {
            NSNumber *userID = [userInfo objectForKey:@"uid"];
            
            //NSString *userid = [NSString stringWithFormat:@"%@",userID];
            [[NSUserDefaults standardUserDefaults]setObject:userID forKey:USER_STORE_USER_ID];
            break;
        }
        case SinaGetHomeLine:
        {
            NSArray *arr=[userInfo objectForKey:@"statuses"];
            if(arr==nil || [arr isEqual:[NSNull null]])
            {
                return;
            }
            NSMutableArray *statusArr =[[NSMutableArray alloc]initWithCapacity:0];
            for (id item in arr) {
                Status *sts= [[Status alloc] initWithJSONDictionary:item];
                NSLog(@"%@",sts.text);
                //                 Status *sts=Status
                //                NSLog(@"",item);
            }
            break;
        }
        default:
            break;
    }
}

-(void)requestFailed:(ASIHTTPRequest*)request
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
-(void)getHomeline:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    authToken=[[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_ACCESS_TOKEN];
    NSString *userId =[[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:authToken, @"access_token",nil];
    if(sinceID>=0)
    {
        NSString *tempString =[NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID>=0) {
        NSString *tempString=[NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    
    NSString *baseUrl=[NSString stringWithFormat:@"%@/statuses/home_timeline.json",SINA_V2_DOMAIN];
    NSURL *url=[self generateURL:baseUrl params:params];
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url];
    [url release];
    [self setGetUserInfo:request withRequestType:SinaGetHomeLine];
    
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
