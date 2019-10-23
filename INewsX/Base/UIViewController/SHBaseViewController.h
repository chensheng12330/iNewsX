//
//  LTBaseViewController.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBaseNavigationController.h"

@protocol SHNavigationBarItemProtocol <NSObject>

@optional

/**  自定义左边barButtonItem,返回按钮的事件  */
- (void)backBarButtonItemAction;

@end

@interface SHBaseViewController : QMUICommonViewController <SHNavigationBarItemProtocol>

/** 是否已经加载过了,viewDidAppear后将设为YES */
@property (nonatomic, assign, readonly) BOOL isLoaded;
/**  是否隐藏导航栏  */
@property(nonatomic, assign, getter=isNavigationBarHidden) IBInspectable BOOL navigationBarHidden;
/**  是否允许右滑返回,默认是YES,如果隐藏了navigationbar,那么这个就不会生效  */
@property (nonatomic, assign, getter=isEnableInteractivePopGestureRecognizer) IBInspectable BOOL enableInteractivePopGestureRecognizer;

@property(nonatomic, strong) UIBarButtonItem *leftBarButtonItem;

#pragma mark - 事件处理
/**  自定义左边返回按钮的事件,默认什么都不干  */
- (void)leftBarButtonAction:(UIButton *)sender;

#pragma mark - 便利构造器
/**  返回当前控制器实例并设置title  */
- (instancetype)initWithTitle:(NSString *)title;
/**  返回当前控制器实例并设置title  */
+ (instancetype)controllerWithTitle:(NSString *)title;
/**  返回根控制器是当前控制器实例的导航控制器并设置title  */
+ (__kindof SHBaseNavigationController *)controllerWithNavigationAndTitle:(NSString *)title;
/**  返回根控制器是当前控制器实例的导航控制器  */
- (__kindof SHBaseNavigationController *)controllerWithNavigation;


@end
