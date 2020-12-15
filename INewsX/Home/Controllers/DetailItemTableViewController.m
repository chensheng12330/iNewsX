//
//  DetailItemTableViewController.m
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "DetailItemTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GlobalTimelineViewController.h"
#import "SHHomeWebViewController.h"
#import "SHNewsGetApi.h"

@interface DetailItemTableViewController ()
@property (nonatomic,strong) UIButton *btnSel;
@property (nonatomic,strong) NSMutableArray *addArray;

@property (nonatomic,assign) NSInteger limit;
@property(nonatomic, strong) NSString *mCid;
@end

@implementation DetailItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleName;
    
    ///处理异常
    if ([self.allList isKindOfClass:NSString.class]) {
        
        self.mCid = (NSString*)self.allList;
        
        self.allList = @[];
        self.limit = 0;
        //添加加载的UI.
        [self addFooter];
        
        [self loadMore];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.addArray = [NSMutableArray new];
    
    return;
}


- (void)addFooter
{
    __unsafe_unretained  DetailItemTableViewController *vc = self;

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 下拉刷新
        [vc loadMore];

    }];
    return;
}

-(void)loadMore
{

    QMUITips *tip = [QMUITips showLoading:@"努力加载中..." inView:self.view];

    SHGetNewsMediaListApi *newGetApi = [[SHGetNewsMediaListApi alloc] initWithCid:self.mCid
                                                                        pageIndex:self.limit
                                                                         pageSize:20];

    [newGetApi startWithCompletionBlockWithSuccess:^( YTKBaseRequest * _Nonnull request) {

        [tip hideAnimated:YES];

        NSArray* list = request.responseJSONObject[@"tList"];

        if(list.count > 0){

            NSMutableArray *addM = [NSMutableArray arrayWithArray: self.allList ];
            [addM addObjectsFromArray:list];

            self.allList = addM;

            self.limit += 20;

            [self.tableView reloadData];

            //[QMUITips showSucceed:@"加载完成" inView:COM.appDelegate.window hideAfterDelay:1];
        }
        else {
            [QMUITips showInfo:@"未获取到数据." inView:COM.appDelegate.window hideAfterDelay:2];
        }

        [self.tableView.mj_footer endRefreshing];

    } failure:^( YTKBaseRequest * request) {

        [tip hideAnimated:YES];

        [self.tableView.mj_footer endRefreshing];

        [QMUITips showError:@"网络问题，加载失败" inView:COM.appDelegate.window hideAfterDelay:2];
    }];

    return;
}

#pragma mark - SH 其它

-(void) addNewsItemForButton:(UIButton*) sender
{
    //[self.addArray addObject:];
    //NSLog(@"add %d",sender);
    NSDictionary *info = self.allList[sender.tag];
    if([info[@"cid"] isEqualToString:SH_MyLoveCatFlag]){

        if([COM.mLoveHelper removeLoverInfo:info])
        {
            [QMUITips showWithText:@"删除成功" inView:self.view hideAfterDelay:0.5];
        }
        else {
            [QMUITips showError:@"删除失败"];
        }

        [self.tableView reloadData];
    }
    else {

        if([COM.mLoveHelper addLoverInfo:info])
        {
            [QMUITips showWithText:@"添加成功" inView:self.view hideAfterDelay:0.5];
        }
        else {
            [QMUITips showError:@"添加失败"];
        }
    }
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
    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];

    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        QMUIGhostButton *btn = nil;//(UIButton*)[cell viewWithTag:1024];
        if (btn==NULL) {

            btn = [[QMUIGhostButton alloc] initWithGhostColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:.2]];
            [btn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40-5, 5, 40, 40)];
            //[btn setBackgroundColor:[UIColor blueColor]];

            [btn addTarget:self action:@selector(addNewsItemForButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:btn];

            if([info[@"cid"]isEqualToString:SH_MyLoveCatFlag]) {
                [btn setTitle:@" - " forState:UIControlStateNormal ];
                btn.ghostColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.2];
            }
            else {
                [btn setTitle:@" + " forState:UIControlStateNormal ];
            }
        }
        
        btn.tag = indexPath.row;
    }

    [cell.textLabel setText:info[@"tname"]];
    [cell.detailTextLabel setText:info[@"alias"]];

    NSString *h5URL = info[@"weburl"];

    if(h5URL.length>0)
    {
        NSString *imgUrl = info[@"img"];
        if (imgUrl.length>0) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        }
        
    }
    else {

        //NSString *imageURL = [NSString stringWithFormat:@"http://timge7.126.net/image?w=68&h=68&quality=75&url=http%%3A%%2F%%2Fimg2.cache.netease.com%%2Fm%%2Fnewsapp%%2Ftopic_icons%%2F%@.png",info[@"img"]];
        
        NSString *imageURL = info[@"topic_icons"];

        NSLog(@"%@",imageURL);

        if ([COM getNeedImage]) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        }
    }

    //cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    cell.backgroundColor = [COM randColor];

    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];
    NSString *h5URL = info[@"weburl"];

    if(h5URL.length>0){
        SHHomeWebViewController *homeWebVC = [[SHHomeWebViewController alloc] init];
        homeWebVC.webUrlStr = h5URL;
        homeWebVC.title = info[@"tname"];
        [self.navigationController pushViewController:homeWebVC animated:YES];
    }
    else {

        GlobalTimelineViewController *gtVC = [[GlobalTimelineViewController alloc] init];
        gtVC.newsItemInfo = info;
        [self.navigationController pushViewController:gtVC animated:YES];
    }
    return;
}

- (CGFloat)tableView:(__unused UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

@end
