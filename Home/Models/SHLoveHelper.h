//
//  SHLoveHelper.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 Gowalla. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
{"template":"normal1","topicid":"05218GKG","hasCover":false,
 "alias":"灼见，热点背后的名家观点。","subnum":"6万","recommendOrder":0,
 "isNew":0,"img":"T1446025828804","isHot":0,"hasIcon":true,"cid":"C1378977951794","recommend":"0",
 "headLine":false,"color":"","bannerOrder":0,
 "tname":"网易灼见","ename":"T1446025828804",
 "showType":"comment","tid":"T1446025828804"}
 */

#define SH_MyLoveCatFlag @"520"
#define SH_DengTaFlag @"521"

@interface SHLoveHelper : NSObject

@property(nonatomic, strong) NSMutableArray *arLoverList;

// 管理喜好列表
-(BOOL) addLoverInfo:(NSDictionary*) info;
-(BOOL) removeLoverInfo:(NSDictionary*) info;
@end

NS_ASSUME_NONNULL_END
