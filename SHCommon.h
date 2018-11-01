//
//  SHCommon.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHLoveHelper.h"
# import "AppDelegate.h"

#define COM [SHCommon sharedInstance]

NS_ASSUME_NONNULL_BEGIN



@interface SHCommon : NSObject

@property(nonatomic, strong) SHLoveHelper *mLoveHelper;
@property(nonatomic, strong) AppDelegate *appDelegate;

+ (instancetype)sharedInstance;

-(UIColor*) randColor;
-(UIColor*) randColorWithAlpha:(float)alpha;
@end

NS_ASSUME_NONNULL_END
