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

@interface DetailItemTableViewController ()
@property (nonatomic,strong) UIButton *btnSel;
@property (nonatomic,strong) NSMutableArray *addArray;

@end

@implementation DetailItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleName;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /*
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSel = btn;
    
    [btn setFrame:CGRectMake(0, 0, 80, 40)];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setTitle:@"选择(0)" forState:UIControlStateNormal ];
    [btn addTarget:self action:@selector(OutJosn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    */

    
    self.addArray = [NSMutableArray new];
    
    return;
}


-(void) OutJosn:(UIButton*) sender
{
}

-(void) addNewsItemForButton:(UIButton*) sender
{
    //[self.addArray addObject:];
    //NSLog(@"add %d",sender);
    NSDictionary *info = self.allList[sender.tag];
    if([info[@"cid"] isEqualToString:SH_MyLoveCatFlag]){
        [COM.mLoveHelper removeLoverInfo:info];

        [QMUITips showWithText:@"删除成功" inView:self.view hideAfterDelay:1.5];

        [self.tableView reloadData];
    }
    else {

        [COM.mLoveHelper addLoverInfo:info];
        [QMUITips showWithText:@"添加成功" inView:self.view hideAfterDelay:1.5];
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
            
            [cell addSubview:btn];

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
    
    NSString *imageURL = [NSString stringWithFormat:@"http://timge7.126.net/image?w=68&h=68&quality=75&url=http%%3A%%2F%%2Fimg2.cache.netease.com%%2Fm%%2Fnewsapp%%2Ftopic_icons%%2F%@.png",info[@"img"]];
    
    NSLog(@"%@",imageURL);
    // isNeed:self.isNeedImage

    if (COM.appDelegate.isNeedImage) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    }
    else {
        [cell.imageView setImage:[UIImage imageNamed:@"profile-image-placeholder"]];
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
    
    GlobalTimelineViewController *gtVC = [[GlobalTimelineViewController alloc] init];
    
    NSDictionary *info = self.allList[(NSUInteger)indexPath.row];
    
    gtVC.newsItemInfo = info;
    
    [self.navigationController pushViewController:gtVC animated:YES];
    
    return;
}

- (CGFloat)tableView:(__unused UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

@end
