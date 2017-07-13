//
//  DetailItemTableViewController.h
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailItemTableViewController : UITableViewController
@property (assign) BOOL isNeedImage;

@property (nonatomic, strong) NSArray *allList;
@property (nonatomic, strong) NSString *titleName;
@end
