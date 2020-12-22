//
//  HLLWKURLProtocol.h
//  HLLWKURLProtocol
//
//  Created by henry.song on 2020/8/27.
//  Copyright © 2020 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface HLLWKURLProtocol : NSObject

@property (nonatomic, readonly, copy) NSURLRequest *request;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request;
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;
- (void)startLoading:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)stopLoading;

@end


@interface WKWebViewConfiguration(ssRegisterURLProtocol)

- (void)ssRegisterURLProtocol:(Class)protocolClass;

@end
