//
//  SHNewsGetApi.m
//  QianZi
//
//  Created by sherwin.chen on 2018/10/9.
//  Copyright © 2018年 bjqr. All rights reserved.
//

#import "SHNewsGetApi.h"

@interface SHNewsGetApi ()

@property(nonatomic, assign) NSInteger mPageIndex;
@property(nonatomic, assign) NSInteger mPageSize;
@property(nonatomic, copy)   NSString *mTid;

@end


@implementation SHNewsGetApi

- (instancetype)initWithTid:(NSString*) tid
                  PageIndex:(NSInteger) pageIndex
                   pageSize:(NSInteger) pageSize {

    if (self = [super init])
    {

        self.mTid = tid;
        self.mPageIndex = pageIndex;
        self.mPageSize  = pageSize;

        [self setSafeArgument:[NSString stringWithFormat:@"%d",rand()]
                       forKey:@"rand"];
    }
    return self;
}

- (NSString *)requestUrl {

    NSString *url = [NSString stringWithFormat:@"%@/%@/all/%ld-%ld.html",kURLBlogNewList,self.mTid,self.mPageIndex, self.mPageSize];

    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end




@interface SHNewsDetailGetApi ()

@property(nonatomic, copy)   NSString *mDocid;

@end


@implementation SHNewsDetailGetApi

- (instancetype)initWithDocid:(NSString*) docid  {

    if (self = [super init])
    {

        self.mDocid = docid;
        [self setSafeArgument:[NSString stringWithFormat:@"%d",rand()]
                       forKey:@"rand"];
    }
    return self;
}

- (NSString *)requestUrl {

    NSString *url = [NSString stringWithFormat:@"%@/%@/full.html",kURLBlogNewDetail,self.mDocid];

    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end


@interface SHGetWebPageApi ()

@property(nonatomic, copy)   NSString *mURL;

@end

@implementation  SHGetWebPageApi

- (instancetype)initWithURL:(NSString*) strURL  {

    if (self = [super init])
    {

        self.mURL = strURL;
    }
    return self;
}

- (NSString *)requestUrl {
    return self.mURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
