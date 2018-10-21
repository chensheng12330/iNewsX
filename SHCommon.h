//
//  SHCommon.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 Gowalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHLoveHelper.h"

#define COM [SHCommon sharedInstance]

NS_ASSUME_NONNULL_BEGIN



@interface SHCommon : NSObject

@property(nonatomic, strong) SHLoveHelper *mLoveHelper;


+ (instancetype)sharedInstance;

-(UIColor*) randColor;

@end

NS_ASSUME_NONNULL_END
