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
#import "SHLoveHelper.h"

//全部分类列表
@interface AllListTableViewController ()
@property (readwrite, nonatomic, strong) NSArray *allList;

@property (nonatomic, strong) NSArray *mDengTaList;

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"all" ofType:@"txt"] ];
        
        self.allList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //[data objectFromJSONData];
        [self getDengTaData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    });
    
    
    self.isNeedImage =  ((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80, 35)];
    //[btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius= 4.0f;
    [btn setTitle:@"文字模式" forState:UIControlStateNormal ];
    [btn addTarget:self action:@selector(needImage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self changeNeedImage:btn];
    return;
}

-(void)needImage:(UIButton *)sender
{
    self.isNeedImage = !self.isNeedImage;
    ((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage = self.isNeedImage;
    
    [self changeNeedImage:sender];
}

-(void) changeNeedImage:(UIButton *)sender {
    if(!self.isNeedImage)
    {
        [sender setTitle:@"文字模式" forState:UIControlStateNormal ];
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else{
        [sender setTitle:@"图片模式" forState:UIControlStateNormal ];
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
}

-(void) getDengTaData {

    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DengTa" ofType:@"json"] ];

    self.mDengTaList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return ;
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
    else {
        NSArray *newsList = info[@"tList"];
        detailItemVC.allList   = newsList;
    }

    detailItemVC.titleName = info[@"cName"];
    detailItemVC.isNeedImage = self.isNeedImage;
    
    [self.navigationController pushViewController:detailItemVC animated:YES];
}

@end
