//
//  HLLWKURLProtocol.m
//  HLLWKURLProtocol
//
//  Created by henry.song on 2020/8/27.
//  Copyright © 2020 hll. All rights reserved.
//

#import "HLLWKURLProtocol.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

// 缓存文件地址
#define WebCacheData_Path  @"/Library/WebCacheData"

typedef BOOL (^HTTPDNSCookieFilter)(NSHTTPCookie *, NSURL *);

@interface NSURLRequest(requestId)

@property (nonatomic,assign) BOOL ss_stop;
- (NSString *)requestId;
- (NSString *)requestRepresent;

@end

static char *kNSURLRequestSSTOPKEY = "kNSURLRequestSSTOPKEY";

@implementation NSURLRequest(requestId)

- (BOOL)ss_stop
{
    return [objc_getAssociatedObject(self, kNSURLRequestSSTOPKEY) boolValue];
}

- (void)setSs_stop:(BOOL)ss_stop
{
    objc_setAssociatedObject(self, kNSURLRequestSSTOPKEY, @(ss_stop), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)requestId
{
    return [@([self hash]) stringValue];
}

- (NSString *)requestRepresent
{
    return [NSString stringWithFormat:@"%@---%@",self.URL.absoluteString,self.HTTPMethod];
}

@end


@interface WKWebView(handlesURLScheme)


@end

@implementation WKWebView(handlesURLScheme)


+ (BOOL)handlesURLScheme:(NSString *)urlScheme
{
    return NO;
}

@end



@interface HLLWKURLProtocol ()

@property (nonatomic, readwrite, copy) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSData               *data;
@property (nonatomic, strong) NSError              *error;
@property (nonatomic, strong) NSMutableDictionary *supportArray;

@end

@implementation HLLWKURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    ///只缓存get请求
    if (request.HTTPMethod && ![request.HTTPMethod.uppercaseString isEqualToString:@"GET"]) {
        return NO;
    }



    /// 不缓存 ajax 请求
    NSString *hasAjax = [request valueForHTTPHeaderField:@"X-Requested-With"];
    if (hasAjax != nil) {
        return NO;
    }
//
//    NSString *pathExtension = [request.URL.absoluteString componentsSeparatedByString:@"?"].firstObject.pathExtension.lowercaseString;
//    NSArray *validExtension = @[ @"jpg", @"jpeg", @"gif", @"png", @"webp", @"bmp", @"tif", @"ico", @"js", @"css", @"html", @"htm", @"ttf", @"svg"];
//    if (pathExtension && [validExtension containsObject:pathExtension]) {
//        return YES;
//    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
//    NSString *hasAjax = [request valueForHTTPHeaderField:@"X-Requested-With"];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    if (request.HTTPBody.length > 0) {
        NSDictionary *headers = @{
                                  @"X-TCloud-Authorization": @"customize",
                                  @"X-TCloud-Auth-Type":@"customize",
                                  @"X-TCloud-Auth-Namespace":@"customize"
                                  };
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
            [mutableRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
    return [mutableRequest copy];
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}

- (NSMutableDictionary *)supportArray {
    if (!_supportArray) {
        _supportArray = [[NSMutableDictionary alloc] init];
        
        //只缓存JS/CSS 即可.
        NSObject *obj = [[NSObject alloc] init];
        [_supportArray setObject:obj  forKey:@"application/javascript"];
        [_supportArray setObject:obj  forKey:@"application/ecmascript" ];
        [_supportArray setObject:obj  forKey:@"application/x-ecmascript" ];
        [_supportArray setObject:obj  forKey:@"application/x-javascript" ];
        [_supportArray setObject:obj  forKey:@"application/json" ];
        [_supportArray setObject:obj  forKey:@"text/ecmascript" ];
        [_supportArray setObject:obj  forKey:@"text/javascript" ];
        [_supportArray setObject:obj  forKey:@"text/javascript1.0"];
        [_supportArray setObject:obj  forKey:@"text/javascript1.1" ];
        [_supportArray setObject:obj  forKey:@"text/javascript1.2" ];
        [_supportArray setObject:obj  forKey:@"text/javascript1.3" ];
        [_supportArray setObject:obj  forKey:@"text/javascript1.4" ];
        [_supportArray setObject:obj  forKey:@"text/javascript1.5" ];
        [_supportArray setObject:obj  forKey:@"text/jscript" ];
        [_supportArray setObject:obj  forKey:@"text/livescript" ];
        [_supportArray setObject:obj  forKey:@"text/x-ecmascript" ];
        [_supportArray setObject:obj  forKey:@"text/x-javascript" ];
        [_supportArray setObject:obj  forKey:@"text/css" ];
        
        /*
        [_supportArray setObject:obj  forKey:@"image/gif" ];
        [_supportArray setObject:obj  forKey:@"image/jpeg" ];
        [_supportArray setObject:obj  forKey:@"text/html"];
//


        [_supportArray setObject:obj  forKey:@"image/png"];
        [_supportArray setObject:obj  forKey:@"image/svg+xml"];
        [_supportArray setObject:obj  forKey:@"image/bmp"];
        [_supportArray setObject:obj  forKey:@"image/webp"];
        [_supportArray setObject:obj  forKey:@"image/tiff"];
        [_supportArray setObject:obj  forKey:@"image/vnd.microsoft.icon"];
        [_supportArray setObject:obj  forKey:@"image/x-icon"];
         */
    
    }
    return _supportArray;
}

// 是否支持缓存
- (BOOL)isSupportCache:(NSString *)mimeType{
    if(self.supportArray[mimeType] ){
        return YES;
    }
    return NO;
}

static NSString* _gFilePath;

- (NSString *)filePath {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_gFilePath==NULL) {
            
            NSString *documentPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(), WebCacheData_Path];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSError *error;
            // 文件夹不存在就创建
            if (![fileManager fileExistsAtPath:documentPath]) {
                [fileManager createDirectoryAtPath:documentPath
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&error];
                if (error) { return ; }
            }
            
            _gFilePath = documentPath;
            
        }
    });
    
    return _gFilePath;
}

- (void)clearAllCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self filePath] error:nil];
}

- (NSString *)md5String:(NSString *)string {
    if(string == nil || [string length] == 0){
        return nil;
    }
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (void)startLoading:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    if ([self.request.URL.absoluteString containsString:@"google"]) {
        completionHandler(nil,nil,[NSError errorWithDomain:@"abc" code:404 userInfo:nil]);
        return;
    }
    // 有缓存读缓存
    NSString *urlStringMD5 = [self md5String:self.request.URL.absoluteString];
    NSString *mimeType = [[NSUserDefaults standardUserDefaults] objectForKey:urlStringMD5];
    NSString *filePath = [[self filePath] stringByAppendingPathComponent:urlStringMD5];
    //如果缓存存在，并是支持的mimeType，则返回缓存数据，否则使用系统默认处理
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] && mimeType) {
        NSLog(@"\n------------------------------\n>>> 读缓存URL: %@,\n >>> mimeType: %@\n", self.request.URL, mimeType);
        
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
        
        NSMutableDictionary *dict = [self.request.allHTTPHeaderFields mutableCopy];
        [dict addEntriesFromDictionary:@{@"Content-type":mimeType,
                                         @"Content-length":[NSString stringWithFormat:@"%ld",fileData.length]}];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:dict];
        completionHandler(fileData,response,nil);
        
        self.data = fileData;
        self.response = response;
        self.error = nil;
        [self finishLoading];
        return;
    }
    
    // 无缓存就请求
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data,response,error);
        self.data = data;
        self.response = response;
        self.error = error;
        
        [self finishLoading];

        if (!error && self.data) {
            // 写缓存
            NSString *tempMimeType = self.response.MIMEType;
            // 支持缓存的类型
            if ([self isSupportCache:tempMimeType]) {
                
                NSString *curURLStringMD5 = [self md5String:self.request.URL.absoluteString];
                
                [[NSUserDefaults standardUserDefaults] setValue:tempMimeType forKey:curURLStringMD5];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *path = [self filePath];
                
           
                [self.data writeToFile:[path stringByAppendingPathComponent:curURLStringMD5]
                            atomically:YES];
                
                NSLog(@"\n------------------------------\n>>> 已缓存URL: %@,\n>>> mimeType: %@\n", self.request.URL, mimeType);
            } else {
                NSLog(@"\n------------------------------\n>>> 不支持URL: %@, \n>>> mimeType: %@\n", self.request.URL, mimeType);
            }
        }
    }];
    
    self.dataTask = task;
    [task resume];
    
    return;
}

- (void)stopLoading
{
    [self.dataTask cancel];
}

- (void)finishLoading {
    [self.dataTask cancel];
    self.dataTask  = nil;
    
//    NSLog(@"[URL]:%@",self.request.URL.absoluteString);
//    NSLog(@"[BODY]:%@",self.request.HTTPBody);
//    NSLog(@"[HEADERS]:%@",self.request.allHTTPHeaderFields);
//    NSLog(@"[RESPONSE]:%@",self.response);
    
}

@end



@interface SSWKURLHandler : NSObject <WKURLSchemeHandler>

@property (nonatomic,strong) Class protocolClass;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) dispatch_queue_t queue;

@end


@implementation SSWKURLHandler{
    HTTPDNSCookieFilter cookieFilter;
}

static SSWKURLHandler *sharedInstance = nil;

+ (SSWKURLHandler *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
        sharedInstance->cookieFilter = ^BOOL(NSHTTPCookie *cookie, NSURL *URL) {
            if ([URL.host containsString:cookie.domain]) {
                return YES;
            }
            return NO;
        };
    });
    return sharedInstance;
}



- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}


- (dispatch_queue_t)queue
{
    if (!_queue) {
//        _queue = dispatch_queue_create("SSWKURLHandler.queue", DISPATCH_QUEUE_SERIAL);
        _queue = dispatch_get_main_queue();
    }
    return _queue;
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask
API_AVAILABLE(ios(11.0)){
    
    NSURLRequest *request = [urlSchemeTask request];
    NSMutableURLRequest *mutaRequest = [request mutableCopy];
    [mutaRequest setValue:[self getRequestCookieHeaderForURL:request.URL] forHTTPHeaderField:@"Cookie"];
    request = [mutaRequest copy];
    
    BOOL canInit = NO;
    if ([self.protocolClass respondsToSelector:@selector(canInitWithRequest:)]) {
        canInit = [self.protocolClass canInitWithRequest:urlSchemeTask.request];
    }
    if (canInit) {
        if ([self.protocolClass respondsToSelector:@selector(canonicalRequestForRequest:)]) {
            request = [self.protocolClass canonicalRequestForRequest:request];
            HLLWKURLProtocol *obj = [[self.protocolClass alloc] init];
            obj.request = request;
            [obj startLoading:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(self.queue, ^{
                    if (urlSchemeTask.request.ss_stop == NO) {
                        if (error) {
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didFailWithError:error];
                        }else{
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didReceiveData:data];
                            [urlSchemeTask didFinish];
                            if ([response respondsToSelector:@selector(allHeaderFields)]) {
                                [self handleHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:request.URL];
                            }
                        }
                    }
                });
            }];
        }
    }else{
        NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(self.queue, ^{
                if (urlSchemeTask.request.ss_stop == NO) {
                    if (error) {
                        [urlSchemeTask didReceiveResponse:response];
                        [urlSchemeTask didFailWithError:error];
                    }else{
                        [urlSchemeTask didReceiveResponse:response];
                        [urlSchemeTask didReceiveData:data];
                        [urlSchemeTask didFinish];
                        if ([response respondsToSelector:@selector(allHeaderFields)]) {
                            [self handleHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:request.URL];
                        }
                    }
                }
            });
          
        }];
        [task resume];
    }
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask
API_AVAILABLE(ios(11.0)){
    dispatch_async(self.queue, ^{
        urlSchemeTask.request.ss_stop = YES;
    });
}


- (NSArray<NSHTTPCookie *> *)handleHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL {
    NSArray *cookieArray = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:URL];
    if (cookieArray != nil) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArray) {
            if (cookieFilter(cookie, URL)) {
                [cookieStorage setCookie:cookie];
            }
        }
    }
    return cookieArray;
}

- (NSString *)getRequestCookieHeaderForURL:(NSURL *)URL {
    NSArray *cookieArray = [self searchAppropriateCookies:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"]) {
            return cookieDic[@"Cookie"];
        }
    }
    return nil;
}

- (NSArray *)searchAppropriateCookies:(NSURL *)URL {
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if (cookieFilter(cookie, URL)) {
            [cookieArray addObject:cookie];
        }
    }
    return cookieArray;
}


@end





@implementation WKWebViewConfiguration(ssRegisterURLProtocol)

- (void)ssRegisterURLProtocol:(Class)protocolClass
{
    SSWKURLHandler *handler = [SSWKURLHandler sharedInstance];
    handler.protocolClass = protocolClass;
    if (@available(iOS 11.0, *)) {
        [self setURLSchemeHandler:handler forURLScheme:@"https"];
        [self setURLSchemeHandler:handler forURLScheme:@"http"];
    } else {
        // Fallback on earlier versions
    }
}

@end
