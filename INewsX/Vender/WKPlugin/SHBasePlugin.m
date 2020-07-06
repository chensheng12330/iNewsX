//
//  SHBasePlugin.m
//  Wallet
//
//  Created by sherwin.chen on 2017/8/1.
//  Copyright © 2017年 txitech. All rights reserved.
//

#import "SHBasePlugin.h"

static SHBasePlugin *_sharedBasePlugin = nil;

@interface SHBasePlugin ()

@end

@implementation SHBasePlugin

+(SHBasePlugin*) sharedCommon
{
    if (!_sharedBasePlugin) {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedBasePlugin = [[self alloc] init];
        });
    }
    return _sharedBasePlugin;
}

- (void) setWebView:(WKWebView*) webView
     viewController:(UIViewController*) viewController {
    self.mWebView = webView;
    self.mWebViewController = viewController;
    return;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dict
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&parseError];//注意这里options参数必须传0，否则回调回报语法错误
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString*) getJSCodeWithJSFuction:(NSString*) fuctionName
                               param:(NSString*) paramStr {
    
    if (fuctionName.length<1) {
        return nil;
    }

    if (paramStr.length>0) {
        paramStr = [paramStr stringByReplacingOccurrencesOfString:@"'" withString: @"\\'"];
    }

    
    NSString *jsCode = [NSString stringWithFormat:@"try{if(typeof(eval(%@))==\"function\"){%@('%@');}}catch(e){\"404\"}",fuctionName,fuctionName,paramStr.length<1? @"":paramStr];
    
    return jsCode;
}

- (NSString*) getJSCodeWithJSFuction:(NSString*) fuctionName
                           paramDict:(NSDictionary*)paramDict {

    NSError *parseError = nil;
    //注意这里options参数必须传0，否则回调回报语法错误
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDict
                                                       options:0
                                                         error:&parseError];

    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return [self getJSCodeWithJSFuction:fuctionName param:jsonStr];
}

-(NSMutableDictionary*) getErrorCBDictionaryWithStatus:(NSString*) status
                message:(NSString*) message
{

    NSMutableDictionary* cbDictionary =  [NSMutableDictionary new];
    
    cbDictionary[@"status"]  = status;
    cbDictionary[@"message"] = message;
    
    return cbDictionary;
}


-(void) setOKStatusCBDictionary:(NSMutableDictionary*) cbDictionary {
    
    cbDictionary[@"status"]  = @"0";
    cbDictionary[@"message"] = @"操作成功";
    
}

@end
