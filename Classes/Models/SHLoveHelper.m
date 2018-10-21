//
//  SHLoveHelper.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 Gowalla. All rights reserved.
//

#import "SHLoveHelper.h"

@interface SHLoveHelper ()
@property(nonatomic, copy) NSString *strFilePath;
@end

@implementation SHLoveHelper

- (instancetype)init
{
    self = [super init];
    if (self) {


        //从本地读取数据
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];

        NSString *lovePath = [docDir stringByAppendingPathComponent:@"myLove"];
        self.strFilePath = lovePath;

        //NSData *data = [[NSData alloc] initWithContentsOfFile:lovePath];

        self.arLoverList = [[NSMutableArray alloc] initWithContentsOfFile:lovePath];
        if(self.arLoverList==NULL) { self.arLoverList = [NSMutableArray new];}
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{


            //self.arLoverList = [data objectFromJSONData];

        });*/


        //
    }
    return self;
}

-(BOOL) addLoverInfo:(NSDictionary*) info {

    //判断是否已存在
    __block BOOL isSave=NO;
    [self.arLoverList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if([obj[@"tid"] isEqualToString:info[@"tid"]]){
            *stop = YES;
            isSave = YES;
        }

    }];

    if (isSave ==YES) {
        return NO;
    }

    //不存在？加入数组中
    //添加标识字段
    NSMutableDictionary *mcInfo = [info mutableCopy];
    mcInfo[@"cid"] = SH_MyLoveCatFlag;
    
    [self.arLoverList addObject:mcInfo];

    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addLoverInfo" object:nil];

    //存入本地数据
    [self.arLoverList writeToFile:self.strFilePath atomically:YES];

    return YES;
}

-(BOOL) removeLoverInfo:(NSDictionary*) info {

    //判断是否已存在
    __block BOOL isSave=NO;
    __block NSUInteger inRow;
    [self.arLoverList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if([obj[@"tid"] isEqualToString:info[@"tid"]]){
            *stop = YES;
            isSave = YES;
            inRow = idx;
        }

    }];

    if(isSave==NO){
        return NO;
    }

    ///
    [self.arLoverList removeObjectAtIndex:inRow];


    //存入本地数据
    [self.arLoverList writeToFile:self.strFilePath atomically:YES];

    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeLoverInfo" object:nil];

    return YES;
}


@end
