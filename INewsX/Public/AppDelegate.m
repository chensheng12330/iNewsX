//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import "AppDelegate.h"

#import "GlobalTimelineViewController.h"
#import "AllListTableViewController.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate

- (BOOL)application:(__unused UIApplication *)application
didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
{
//    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
//    [NSURLCache setSharedURLCache:URLCache];
//    //缓存使用说明： http://www.cnblogs.com/wendingding/p/3950198.html

    [self netWorkConfiguration];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    UITableViewController *viewController = [[AllListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    COM.appDelegate = self;

    return YES;
}

-(void)netWorkConfiguration
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"https://c.m.163.com/";

    return;
}

@end
