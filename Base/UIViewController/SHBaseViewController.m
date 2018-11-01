//
//   SHBaseViewController.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import "SHBaseViewController.h"
#import "SHBaseNavigationController.h"

@interface SHBaseViewController ()

@end

@implementation SHBaseViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _isLoaded = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 事件处理
/**  自定义左边返回按钮的事件  */
- (void)leftBarButtonAction:(UIButton *)sender
{
    
}

#pragma mark - 便利构造器
- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init])
    {
        self.title = title;
    }
    return self;
}

+ (instancetype)controllerWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

+ (__kindof  SHBaseNavigationController *)controllerWithNavigationAndTitle:(NSString *)title
{
    return [[ SHBaseNavigationController alloc] initWithRootViewController:[self controllerWithTitle:title]];
}
/**  返回根控制器是当前控制器实例的导航控制器  */
- (__kindof  SHBaseNavigationController *)controllerWithNavigation
{
    return [[ SHBaseNavigationController alloc] initWithRootViewController:self];
}

#pragma mark - setter and getter
- (BOOL)isNavigationBarHidden
{
    return self.navigationController.navigationBar.isHidden;
}
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    self.navigationController.navigationBar.hidden = navigationBarHidden;
}

- (BOOL)isEnableInteractivePopGestureRecognizer
{
    return self.navigationController.interactivePopGestureRecognizer.isEnabled;
}
- (void)setEnableInteractivePopGestureRecognizer:(BOOL)enableInteractivePopGestureRecognizer
{
    self.navigationController.interactivePopGestureRecognizer.enabled = enableInteractivePopGestureRecognizer;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem)
    {
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(leftBarButtonAction:)];
    }
    return _leftBarButtonItem;
}

@end
