//
//  CustomURLSchemeHandler.m
//  IGWallet
//
//  Created by sherwin.chen on 2020/3/17.
//  Copyright © 2020 sherwin.chen. All rights reserved.
//  https://www.jianshu.com/p/6bae04c91297  WKURLSchemeHandler请求范围说明

#include <CoreServices/CoreServices.h>
#import "CustomURLSchemeHandler.h"

@implementation CustomURLSchemeHandler

//当 WKWebView 开始加载自定义scheme的资源时，会调用
//
- (void)webView:(WKWebView *)webView
startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask API_AVAILABLE(ios(11.0))
{

    /**  请求协议示例.
     .jpg .png .icon  优先级低队列
     .js .css
     */

    NSURLRequest *request = urlSchemeTask.request;
    NSString *path = [request.URL path];
    NSLog(@"URL = %@, allKey = %@", request.URL, [request.allHTTPHeaderFields allKeys]);
    NSData *data = nil;
    NSString *host = [request.URL host];

    if (host.length <= 1) {
        return;
    }

    NSString *mime = nil;  // 根据文件类型.

    if([path containsString:@"app.css"]){

        data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app" ofType:@"css"]];
    }
    else if([path containsString:@"jquery.js"]){

        data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js"]];
    }
    else if([path containsString:@"style.css"]){

        data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"]];
    }

//    if ([path containsString:SHFN_inAppDir]) {
//        filePath = [[SHDLFM pathForAppMain] stringByAppendingPathComponent:path];
//    }
//    else {
//        filePath = [[SHDLFM documentsPath] stringByAppendingPathComponent:path];
//    }
//
//    if([SHDLFM fileExistsAtPath:filePath]){
//        mime = [self mimeTypeForFileAtPath:filePath];
//        data = [NSData dataWithContentsOfFile:filePath];
//    }

    if (data == nil) {
        NSError *err = [[NSError alloc] initWithDomain:@"资源路径无法解析." code:-4003 userInfo:nil];
        [urlSchemeTask didFailWithError:err];
    } else {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:@"text/plain" expectedContentLength:data.length textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:data];
        [urlSchemeTask didFinish];
        NSLog(@"资源获取成功 %@.文件大小: %ld",path, data.length);
    }
    return;
}


- (void)webView:(WKWebView *)webVie stopURLSchemeTask:(id)urlSchemeTask {
    NSLog(@"stop = %@",urlSchemeTask);
}

//path为要获取MIMEType的文件路径
- (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    NSLog(@"%@",MIMEType);
    return (__bridge NSString *)(MIMEType);
}

@end
