//
//  SHCommon.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 Gowalla. All rights reserved.
//

#import "SHCommon.h"

@implementation SHCommon

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SHCommon *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[SHCommon alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mLoveHelper = [[SHLoveHelper alloc] init];
    }
    return self;
}

-(UIColor*) randColor {
    return [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:0.15];

}

-(UIColor*) randColorWithAlpha:(float)alpha {
    return [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:alpha];

}

@end
