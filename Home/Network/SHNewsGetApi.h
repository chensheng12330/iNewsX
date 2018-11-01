//
//  SHNewsGetApi.h
//  QianZi
//
//  Created by sherwin.chen on 2018/10/9.
//  Copyright © 2018年 bjqr. All rights reserved.
//

#import "SHBaseRequest.h"


@interface SHNewsGetApi : SHBaseRequest

- (instancetype)initWithTid:(NSString*) tid
                  PageIndex:(NSInteger) pageIndex
                   pageSize:(NSInteger) pageSize;

@end


@interface SHNewsDetailGetApi : SHBaseRequest

- (instancetype)initWithDocid:(NSString*) docid ;

@end
