//
//  SHLoveHelper.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 Gowalla. All rights reserved.
//

#import "SHLoveHelper.h"
#import "iCloudHandle.h"
#import "ZZRDocument.h"

#define kCloudFileName (@"RssList")

typedef NS_ENUM(NSInteger, Document_type)
{
    Document_type_addNew = 0,
    Document_type_edit,
};

@interface SHLoveHelper ()
@property(nonatomic, copy) NSString *strFilePath;

@property(nonatomic, strong) NSData *mCloudData; //远程数据
@property(nonatomic, strong) NSData *mLocalData;//本地数据
@property(nonatomic, copy) void (^completionHandler)(NSInteger code);
@end

@implementation SHLoveHelper

- (instancetype)init
{
    self = [super init];
    if (self) {


        //从本地读取数据
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];

        NSString *lovePath = [docDir stringByAppendingPathComponent:@"myLove.dat"];
        self.strFilePath = lovePath;

        NSData *locData = [NSData dataWithContentsOfFile:lovePath];
        if(locData){
            NSArray *tempLocAry = [NSJSONSerialization JSONObjectWithData:locData options:0 error:nil];
            if(tempLocAry.count>0){
                self.arLoverList = [[NSMutableArray alloc] initWithArray:tempLocAry];
            }
        }

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
        //[QMUITips showError:@"已存在"];
        return NO;
    }

    //不存在？加入数组中
    //添加标识字段
    NSMutableDictionary *mcInfo = [info mutableCopy];
    mcInfo[@"cid"] = SH_MyLoveCatFlag;
    
    [self.arLoverList addObject:mcInfo];
    NSData *saveData = [NSJSONSerialization dataWithJSONObject:self.arLoverList options:0 error:nil];

    //存入本地数据
    if(saveData){
        [saveData writeToFile:self.strFilePath atomically:YES];
    }

    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiAddLoverInfo object:nil];

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

    NSData *saveData = [NSJSONSerialization dataWithJSONObject:self.arLoverList options:0 error:nil];

    //存入本地数据
    if(saveData){
        [saveData writeToFile:self.strFilePath atomically:YES];
    }

    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiRemoveLoverInfo object:nil];

    return YES;
}

////////////////////////////////////////////////////

//下载iCloud数据
-(void) synchronousWithCompletionHandler:(void (^ __nullable)(NSInteger code))completionHandler
{
    self.completionHandler = completionHandler;

    NSURL *cloundDocUrl = [iCloudHandle getUbiquityContauneURLWithFileName:kCloudFileName];

    if(cloundDocUrl)
    {
        ZZRDocument *doc = [[ZZRDocument alloc] initWithFileURL:cloundDocUrl];
        [doc openWithCompletionHandler:^(BOOL success) {

            if(success)
            {
                NSLog(@"读取数据成功。");

                //NSString *docConten = [[NSString alloc] initWithData:doc.myData encoding:NSUTF8StringEncoding];
                //NSLog(@"%@",docConten);

                //同步本地址数据.
                self.mCloudData = doc.myData;
            }
            else {
                self.mCloudData = nil;
            }

            //合并数据.
            [self mergeData];
        }];
    }
    else { //远程不存在此文件，创建新的。
        self.mCloudData = nil;
        [self mergeData];
    }
    return;
}

//获取本地数据
-(NSData*) getlocData {

    BOOL isExiFile = [[NSFileManager defaultManager] fileExistsAtPath:self.strFilePath];

    if(isExiFile==NO){ return nil;}

    NSData *locData = [NSData dataWithContentsOfFile:self.strFilePath];

    return locData;
}

//合并两者数据
-(void) mergeData {

    self.mLocalData = [self getlocData];

    if(self.mLocalData==NULL && self.mCloudData==NULL){

        self.completionHandler(2);
        return;
    }

    //本地为空,将远程数据存入本地
    if(self.mLocalData==NULL){

        //存入本地数据
        [self.mCloudData writeToFile:self.strFilePath atomically:YES];

        self.arLoverList = [NSJSONSerialization JSONObjectWithData:self.mCloudData options:0 error:nil];
        self.completionHandler(0);
        return;
    }

    //远程为空
    if(self.mCloudData == NULL){

        //数据存入远程
        [self upload2Cloud:Document_type_addNew];

        return;
    }

    //都不为空，合并数据
    //本地为主，远程为辅
    NSMutableArray *mergeAry = [[NSMutableArray alloc] init];
    //BOOL isNeedMerge=NO;

    NSArray *localAry = [NSJSONSerialization JSONObjectWithData:self.mLocalData options:0 error:nil];
    NSArray *remoteAry= [NSJSONSerialization JSONObjectWithData:self.mCloudData options:0 error:nil];

    if(localAry.count == remoteAry.count){
        //isNeedMerge = YES;
        self.completionHandler(0);
        return;
    }

    [mergeAry addObjectsFromArray:localAry];

    //删除列表
    [remoteAry enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSString *tid = obj[@"tid"];
        __block BOOL bCanAdd = YES;

        [localAry enumerateObjectsUsingBlock:^(NSDictionary  *fObj, NSUInteger fidx, BOOL * _Nonnull fstop) {
            if([fObj[@"tid"] isEqualToString:tid]){
                bCanAdd = NO;
                *fstop = YES;
            }
        }];

        if(bCanAdd){
            [mergeAry addObject:obj];
        }

    }];

    //
    self.arLoverList = mergeAry;
    self.mLocalData = [NSJSONSerialization dataWithJSONObject:mergeAry options:0 error:nil];

    //存入本地
    [self.mLocalData writeToFile:self.strFilePath atomically:YES];
    [self upload2Cloud:Document_type_edit];

    return;
}

//上传到iCloud
-(void) upload2Cloud:(Document_type) type {

    //NSString *content;
    if(type == Document_type_addNew)
    {

        [iCloudHandle createDocumentWithFileName:kCloudFileName content:self.mLocalData completionHandler:^(BOOL success) {
            if (success) {
                //上传成功.
            }
            self.completionHandler(success==YES?0:3);
        }];
    }
    else if(type == Document_type_edit)
    {
        [iCloudHandle overwriteDocumentWithFileName:kCloudFileName content:self.mLocalData completionHandler:^(BOOL success) {
            if (success) {
                //上传成功.
            }
            self.completionHandler(success==YES?0:3);
        }];

    }

    return;
}

@end

