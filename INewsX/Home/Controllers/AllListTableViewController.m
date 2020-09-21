//
//  AllListTableViewController.m
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "AllListTableViewController.h"
#import "DetailItemTableViewController.h"
#import "SHSettingViewController.h"

#import "AppDelegate.h"
#import "SHLoveHelper.h"

#import <AFNetworking/AFURLSessionManager.h>

//全部分类列表
@interface AllListTableViewController ()
@property (readwrite, nonatomic, strong) NSArray *allList;

@property (nonatomic, strong) NSArray *mDengTaList;
@property (nonatomic, strong) NSArray *mINewsList;

@end

@implementation AllListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聚阅读";

    /*
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/read/all.html"]];
    
    self.allList = [data1 objectFromJSONData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/all.txt",docDir];

    [data1 writeToFile:path atomically:YES];
    
    NSLog(@"%@",path);
    //*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"all" ofType:@"txt"] ];
        
        self.allList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //[data objectFromJSONData];
        [self getDengTaData];
        [self getINewsData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    });
    
    

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 36, 36)];
    //[btn setBackgroundColor:[UIColor darkGrayColor]];
    //[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    btn.layer.borderColor = [UIColor systemBlueColor].CGColor;
    btn.layer.borderWidth = 0.5f;
    btn.layer.cornerRadius= 36/2.0f;
    [btn setShowsTouchWhenHighlighted:YES];
    [btn setTitle:@"⚙︎" forState:UIControlStateNormal ];
    [btn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(needImage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kNotiAddLoverInfo object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kNotiSyschronLoverInfo object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kNotiRemoveLoverInfo object:nil];
    return;
}

-(void) refreshData {
    [self.tableView reloadData];
}

-(void)needImage:(UIButton *)sender
{
    SHSettingViewController *vc =  [[SHSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

    return;
}

-(void) getDengTaData {

    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DengTa" ofType:@"json"] ];

    self.mDengTaList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return ;
}

- (void) getINewsData {
    
    //获取本地缓存
    //从本地读取数据
    NSArray *paths      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir    = [paths objectAtIndex:0];
    NSString *lovePath  = [docDir stringByAppendingPathComponent:@"iNews.dat"];
   
    NSData *locData = [NSData dataWithContentsOfFile:lovePath];
    if(locData){
        NSArray *tempLocAry = [NSJSONSerialization JSONObjectWithData:locData options:0 error:nil];
        if(tempLocAry.count>0){
            self.mINewsList = tempLocAry;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }
    
    /////////////////////
    //更新本地缓存

    // step1. 初始化AFURLSessionManager对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    AFHTTPResponseSerializer *jsonResp = [AFHTTPResponseSerializer serializer];
    jsonResp.acceptableContentTypes = [NSSet setWithObjects:@"*", @"text/json", @"application/javascript", nil];
    manager.responseSerializer = jsonResp;
    
    // step2. 获取AFURLSessionManager的task对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://sunny90.com//ios/rss/iNewsList.js"]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                                       
                                                   } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                                                       
                                                   } completionHandler:^(NSURLResponse * _Nonnull response,
                                                                         NSData*   responseObject,
                                                                         NSError * _Nullable error)
    {
        if (error==NULL && responseObject != NULL) {
            //将数据存入本地
            [responseObject writeToFile:lovePath atomically:YES];
            
            if(self.mINewsList==NULL){
                
                NSArray *tempLocAry = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:0
                                                                        error:nil];
                if(tempLocAry.count>0){
                    self.mINewsList = tempLocAry;
                    [self.tableView reloadData];
                }
            }
        }
                                                  
    }];

    // step3. 发动task
    [dataTask resume];
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView
 numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.allList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];
    
    [cell.textLabel setText:info[@"cName"]];

    NSUInteger count ;
    if([info[@"cid"] isEqualToString:SH_MyLoveCatFlag]) {
        count = COM.mLoveHelper.arLoverList.count;
    }
    else if([info[@"cid"] isEqualToString:SH_DengTaFlag]){
        count = self.mDengTaList.count;
    }
    else if([info[@"cid"] isEqualToString:SH_INewsFlag]){
        count = self.mINewsList.count;
    }
    
    else {
        count = ((NSArray*)info[@"tList"]).count;
    }
    NSString *infoStr = [NSString stringWithFormat:@"%@ - [%lu]",info[@"cid"],count];


    [cell.detailTextLabel setText:infoStr];
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    cell.backgroundColor = [COM randColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailItemTableViewController *detailItemVC  = [[DetailItemTableViewController alloc] init];
    
    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];

    if ([info[@"cid"] isEqualToString:SH_MyLoveCatFlag]) {
        detailItemVC.allList   = COM.mLoveHelper.arLoverList;
    }
    else if([info[@"cid"] isEqualToString:SH_DengTaFlag]){
        detailItemVC.allList   = self.mDengTaList;
    }
    else if([info[@"cid"] isEqualToString:SH_INewsFlag]){
        detailItemVC.allList   = self.mINewsList;
    }
    else {
        NSArray *newsList = info[@"tList"];
        detailItemVC.allList   = newsList;
    }
    

    detailItemVC.titleName = info[@"cName"];
  
    [self.navigationController pushViewController:detailItemVC animated:YES];
}

@end
