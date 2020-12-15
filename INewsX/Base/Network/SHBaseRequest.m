//
//  SHBaseRequest.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import "SHBaseRequest.h"

@interface SHBaseRequest () <YTKRequestDelegate>

@end

@implementation SHBaseRequest

- (instancetype)init
{
    if (self = [super init])
    {
        self.mArguments = [NSMutableDictionary dictionary];
        self.delegate = self;
    }
    return self;
}

- (void)setSafeArgument:(id)value forKey:(NSString*)key
{
    if (value == NULL || [value isKindOfClass:[NSNull class]] || key == NULL || [key isKindOfClass:[NSNull class]])
    {
        NSLog(@"--401-->setSafeArgument:key: 参数为空,检测调用代码块...");
        return;
    }

    [self.mArguments setObject:value forKey:key];
    return;
}


/**  公共头部设置  */
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    /*
     @"token":kSharedUser.token.length>0 ? kSharedUser.token:@""
     */
    //appId   => 设备ID值
    //version => app当前版本
    //system: 0 安卓， 1 ios , 2 微信，  3 js
    //current:当前登录用户Id
    //token：当前登录用户Id对应的token

    /*

     Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0) Gecko/20100101 Firefox/63.0
     text/html,application/xhtml+xml,application/xml;q=0.9,*
     @"User-C": @"572R5piT5Y+35paH56ug",
     */
//    NSMutableDictionary *headerDictionary=@{
//                                            @"User-Agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0)",
//                                            @"Accept":@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
//                                     }.mutableCopy;

    /*
     @"User-D": @"Q9duE1ybWG0v0LK7T7nd2e0UMEA5a8d2nnfgTh/O7/kLobJcMsq7Q1/J0sv35EGo",
     @"User-N": @"/gv3ptixznNuPZGK2rxlWa+ql4kn60ovuSkt3LEVh1Y7yZdSS7sKRDOOGfpo1zdR",
     @"X-Trace-Id": @"1541989782_7583658624_C6593DFA-CCBC-462C-BC03-10F087B39EA9",
    @"User-C": @"5oiR",
    @"User-Agent": @"NewsApp/30.1 iOS/11.4 (iPhone10,3)",
    @"Accept-Language": @"zh-Hans;q=1.0",
    @"Accept-Encoding": @"gzip;q=1.0, compress;q=0.5",


     */

    NSMutableDictionary *headerDictionary=@{
                                            @"User-D": @"Q9duE1ybWG0v0LK7T7nd2e0UMEA5a8d2nnfgTh/O7/kLobJcMsq7Q1/J0sv35EGo",
                                            @"User-N": @"/gv3ptixznNuPZGK2rxlWa+ql4kn60ovuSkt3LEVh1Y7yZdSS7sKRDOOGfpo1zdR",
                                            @"X-Trace-Id": @"1541989782_7583658624_C6593DFA-CCBC-462C-BC03-10F087B39EA9",
                                            @"User-C": @"5oiR",
                                            @"User-Agent": @"NewsApp/64.1 iOS/14.0 (iPhone10,3)",
                                            @"Accept-Language": @"zh-Hans;q=1.0",
                                            @"Accept-Encoding": @"gzip;q=1.0, compress;q=0.5",
                                            @"Accept":@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
                                            }.mutableCopy;

    return headerDictionary;
}

//! 请求超时时间
- (NSTimeInterval)requestTimeoutInterval
{
    return 30; //秒
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;    //默认post请求
}

- (id)requestArgument
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [self.mArguments enumerateKeysAndObjectsUsingBlock:^(NSObject * _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key.description, obj.description];
        [mstr appendFormat:@"%@&", str];
    }];
    [mstr appendString:@"key=123"];
    ///[self setSafeArgument:mstr.md5String forKey:@"sessionKey"];
    
    //加入token
    
    //[self setSafeArgument:kSharedUser.token  forKey:@"token"];
    //[self setSafeArgument:kSharedUser.userId forKey:@"user_id"];
    
    return self.mArguments;
}

#pragma mark - YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request
{
    NSLog(@"====请求 ====\n请求URL:%@\n", request.requestUrl);

//    NSDictionary *info = request.responseJSONObject;
//    NSString *strStatus= info[@"status"];
//    if ([strStatus integerValue] == 9999)
//    {
//        // token 验证失败，需要重新登陆。
//        [LTCommon showLogInViewControllerEx];
//    }

    return;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (void)requestFailed:(__kindof YTKBaseRequest *)request
{
    NSLog(@"====请求失败====\n请求URL:%@\n错误信息:%@", request.requestUrl, request.responseString);    
}


@end
