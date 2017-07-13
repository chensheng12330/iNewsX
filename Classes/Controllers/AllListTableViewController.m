//
//  AllListTableViewController.m
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "AllListTableViewController.h"
#import "DetailItemTableViewController.h"
#import "AppDelegate.h"
@interface AllListTableViewController ()
@property (readwrite, nonatomic, strong) NSArray *allList;

@property (assign) BOOL isNeedImage;
@end

@implementation AllListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分类";
    
    /*
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/read/all.html"]];
    
    self.allList = [data1 objectFromJSONData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/all.txt",docDir];

    [data1 writeToFile:path atomically:YES];
    
    NSLog(@"%@",path);
    //*/
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"all" ofType:@"txt"] ];
    
    self.allList = [data objectFromJSONData];
    
    
    self.isNeedImage = NO;
   ((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage = self.isNeedImage;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80, 40)];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setTitle:@"文字模式" forState:UIControlStateNormal ];
    [btn addTarget:self action:@selector(needImage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    return;
}

-(void)needImage:(UIButton *)sender
{
    self.isNeedImage = !self.isNeedImage;
    ((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage = self.isNeedImage;
    
    if(!self.isNeedImage)
    {
        [sender setTitle:@"文字模式" forState:UIControlStateNormal ];
    }
    else{
        [sender setTitle:@"图片模式" forState:UIControlStateNormal ];
    }
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
    
    NSString *infoStr = [NSString stringWithFormat:@"%@ - [%lu]",info[@"cid"],(unsigned long)((NSArray*)info[@"tList"]).count];
    [cell.detailTextLabel setText:infoStr];
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailItemTableViewController *detailItemVC  = [[DetailItemTableViewController alloc] init];
    
    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];
    
    NSArray *newsList = info[@"tList"];
    
    detailItemVC.allList   = newsList;
    detailItemVC.titleName = info[@"cName"];
    detailItemVC.isNeedImage = self.isNeedImage;
    
    [self.navigationController pushViewController:detailItemVC animated:YES];
}
@end
