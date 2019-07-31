

#import "GlobalTimelineViewController.h"

#import "PostTableViewCell.h"

#import "UIRefreshControl+AFNetworking.h"
#import "WebViewController.h"
#import "AppDelegate.h"

#import "SHNewsGetApi.h"
#import "SHNewsInfoModel.h"

#define SH_MAX 20

@interface GlobalTimelineViewController ()
@property (readwrite, nonatomic, strong) NSArray *posts;
@property (nonatomic,retain) MJRefreshFooter *footer;

@property (nonatomic,assign) NSInteger limit;

@property(nonatomic, strong) NSMutableDictionary *mReadList;
@end

@implementation GlobalTimelineViewController


- (void)dealloc
{
    //[_footer free];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.limit = 0;

    self.mReadList = [[NSMutableDictionary alloc] init];


    self.title = self.newsItemInfo[@"tname"];

    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];


    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70.0f;

    [self addFooter];

    [self reload:nil];
    return;
}

- (void)addFooter
{
    __unsafe_unretained GlobalTimelineViewController *vc = self;

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 下拉刷新
        [vc loadMore];

    }];
    return;
}

#pragma mark - --网络

- (void)reload:(__unused id)sender {

    self.limit = 0;

    self.navigationItem.rightBarButtonItem.enabled = NO;

    QMUITips *tip = [QMUITips showLoading:@"努力加载中..." inView:self.view];

    SHNewsGetApi *newGetApi = [[SHNewsGetApi alloc] initWithTid:self.newsItemInfo[@"tid"] PageIndex:self.limit pageSize:SH_MAX];

    [newGetApi startWithCompletionBlockWithSuccess:^( YTKBaseRequest * _Nonnull request) {

        [tip hideAnimated:YES];
        [self.refreshControl endRefreshing];

        SHNewsInfoResponse *responseData = [[SHNewsInfoResponse alloc] initWithString:request.responseString error:nil];

        if(responseData.tab_list.count>0){
            self.posts = responseData.tab_list;

            [self.tableView reloadData];

            //[QMUITips showSucceed:@"加载完成" inView:COM.appDelegate.window hideAfterDelay:1];
        }
        else {
            [QMUITips showInfo:@"未获取到数据." inView:COM.appDelegate.window hideAfterDelay:1.0];
        }

    } failure:^( YTKBaseRequest * _Nonnull request) {

        [tip hideAnimated:YES];
        [self.refreshControl endRefreshing];
        //
        [QMUITips showError:@"网络问题，加载失败" inView:COM.appDelegate.window hideAfterDelay:2];
    }];

    return;
}

-(void)loadMore
{

    QMUITips *tip = [QMUITips showLoading:@"努力加载中..." inView:self.view];

    SHNewsGetApi *newGetApi = [[SHNewsGetApi alloc] initWithTid:self.newsItemInfo[@"tid"] PageIndex:(self.limit+SH_MAX) pageSize:SH_MAX];

    [newGetApi startWithCompletionBlockWithSuccess:^( YTKBaseRequest * _Nonnull request) {

        [tip hideAnimated:YES];

        SHNewsInfoResponse *responseData = [[SHNewsInfoResponse alloc] initWithString:request.responseString error:nil];

        if(responseData.tab_list.count>0){

            NSMutableArray *addM = [NSMutableArray arrayWithArray: self.posts];
            [addM addObjectsFromArray:responseData.tab_list];

            self.posts = addM;

            self.limit+= (NSInteger) responseData.tab_list.count;

            [self.tableView reloadData];

            //[QMUITips showSucceed:@"加载完成" inView:COM.appDelegate.window hideAfterDelay:1];
        }
        else {
            [QMUITips showInfo:@"未获取到数据." inView:COM.appDelegate.window hideAfterDelay:2];
        }

        [self.tableView.mj_footer endRefreshing];

    } failure:^( YTKBaseRequest * _Nonnull request) {

        [tip hideAnimated:YES];

        [self.tableView.mj_footer endRefreshing];

        //
        [QMUITips showError:@"网络问题，加载失败" inView:COM.appDelegate.window hideAfterDelay:2];
    }];

    return;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView
 numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    //
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if ( self.mReadList[row] == NULL  ) {
        cell.textLabel.textColor = UIColorWithHEX(0x5050f3);
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.textLabel.textColor = [COM randColorWithAlpha:0.35f];
        cell.detailTextLabel.textColor = [COM randColorWithAlpha:0.4f];
    }

    cell.newsModel = [self.posts objectAtIndex:(NSUInteger)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PostTableViewCell heightForCellWithPost:[self.posts objectAtIndex:(NSUInteger)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    self.mReadList[row] = @"1";

    PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.textLabel.textColor = [COM randColorWithAlpha:0.35f];
    cell.detailTextLabel.textColor = [COM randColorWithAlpha:0.4f];

    SHNewsInfoModel *post = self.posts[(NSUInteger)indexPath.row];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.docid = post.docid;
    webVC.title = post.title;
    [self.navigationController pushViewController:webVC animated:YES];
    
    return;
}

@end
