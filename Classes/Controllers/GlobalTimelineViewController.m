// GlobalTimelineViewController.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GlobalTimelineViewController.h"

#import "Post.h"

#import "PostTableViewCell.h"

#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import "AppDelegate.h"

#define SH_MAX 20

@interface GlobalTimelineViewController ()
@property (readwrite, nonatomic, strong) NSArray *posts;
@property (nonatomic,retain) MJRefreshFooterView *footer;

@property (nonatomic,assign) NSInteger limit;

@property(nonatomic, strong) NSMutableDictionary *mReadList;
@end

@implementation GlobalTimelineViewController


- (void)dealloc
{
    [_footer free];
}

- (void)reload:(__unused id)sender {
    
    self.limit = 0;
    
    NSString *url = [NSString stringWithFormat:@"nc/article/list/%@/%d-%d.html",self.newsItemInfo[@"tid"],(int)(self.limit), (int)(self.limit+SH_MAX)];
    self.limit += SH_MAX;
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

    //QMUITips *tip = [QMUITips showLoading:@"努力加载中..." inView:self.view];

    NSURLSessionTask *task = [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error)   {

        //[tip hideAnimated:YES];
        
        if (!error) {
            self.posts = posts;
            [self.tableView reloadData];

            [QMUITips showSucceed:@"加载完成" inView:COM.appDelegate.window hideAfterDelay:2];
        }
        else{
            [QMUITips showError:@"加载失败" inView:COM.appDelegate.window hideAfterDelay:2];
        }
    } part:url];

    //[UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];

}

-(void)loadMore:(MJRefreshBaseView *)refreshView
{
    NSString *url = [NSString stringWithFormat:@"nc/article/list/%@/%d-%d.html",self.newsItemInfo[@"tid"],(int)(self.limit), SH_MAX];
    
    self.limit += SH_MAX;
    
    NSURLSessionTask *task = [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error)   {
        if (!error) {
            
            
            if (posts.count>0) {
                NSMutableArray *addM = [NSMutableArray arrayWithArray:self.posts];
                [addM addObjectsFromArray:posts];
                self.posts = addM;
                
                [self.tableView reloadData];
            }
        }
        
        [refreshView endRefreshing];
    } part:url];
    
     [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    return;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mReadList = [[NSMutableDictionary alloc] init];
    //self.title = NSLocalizedString(@"AFNetworking", nil);
    
    self.title = self.newsItemInfo[@"tname"];

    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];

    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
    
    [self addFooter];
}

- (void)addFooter
{
    __unsafe_unretained GlobalTimelineViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc loadMore:refreshView];
    };
    _footer = footer;
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
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.textLabel.textColor = [COM randColorWithAlpha:0.35f];
        cell.detailTextLabel.textColor = [COM randColorWithAlpha:0.4f];
    }

    cell.post = [self.posts objectAtIndex:(NSUInteger)indexPath.row];
    
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

    //NSDictionary *info = self.posts[(NSUInteger)indexPath.row];
    Post *post = self.posts[(NSUInteger)indexPath.row];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = post.docid;//[NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",];  //post.url_3w
    
    webVC.title = post.title;
    [self.navigationController pushViewController:webVC animated:YES];
    
    return;
}

@end
