//
//  SHBaseRequest.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#if __has_include(<YTKNetwork/YTKBaseRequest.h>)
#import <YTKNetwork/YTKBaseRequest.h>
#else
#import "YTKBaseRequest.h"

#endif

#import "SHBaseResponse.h"

@interface SHBaseRequest : YTKBaseRequest

//请求头字段
@property (nonatomic, strong) NSMutableDictionary *mArguments;

/*
 安全的设置mArguments 字典内容.
 @param      value   字段数据 (NSString/NSNumber)
 @param      key     字段名称 (NSString)
 */
- (void)setSafeArgument:(id)value forKey:(NSString*)key;


@end
