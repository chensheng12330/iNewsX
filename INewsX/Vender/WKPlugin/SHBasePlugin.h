//
//  SHBasePlugin.h
//  Wallet
//
//  Created by sherwin.chen on 2017/8/1.
//  Copyright © 2017年 txitech. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "NSDictionary+JSONString.h"

#define SHBP [SHBasePlugin sharedCommon]

@interface SHBasePlugin : NSObject

@property (nonatomic, weak) UIViewController *mWebViewController;
@property (nonatomic, weak) WKWebView *mWebView;

+(SHBasePlugin*) sharedCommon;

- (void) setWebView:(WKWebView*) webView
      viewController:(UIViewController*) viewController;

//字典转换成JS 所用的 json
- (NSString*) dictionaryToJson:(NSDictionary *)dict;

//JS转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 
- (NSString*) getJSCodeWithJSFuction:(NSString*) fuctionName
                               param:(NSString*)paramStr;

- (NSString*) getJSCodeWithJSFuction:(NSString*) fuctionName
                           paramDict:(NSDictionary*)paramDict;


//! 辅助函数,对回调数据设置状态值.
-(NSMutableDictionary*) getErrorCBDictionaryWithStatus:(NSString*) status
                                               message:(NSString*) message;

//!辅助函数,对回调数据设置成功的状态值.
-(void) setOKStatusCBDictionary:(NSMutableDictionary*) cbDictionary;

@end
