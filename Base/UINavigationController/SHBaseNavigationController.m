//
//   SHBaseNavigationController.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import "SHBaseNavigationController.h"
#import "SHBaseViewController.h"

@interface  SHBaseNavigationController ()

@end

@implementation  SHBaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    //设置返回按钮图片颜色
    UIImage *image = [[UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(13.f, 21.f) tintColor:kAppDefaultColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = image;
    self.navigationBar.backIndicatorTransitionMaskImage = image;
     */
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item
{
    if([self.viewControllers count] < [navigationBar.items count])
    {
        return YES;
    }
    
    BOOL shouldPop = YES;
     SHBaseViewController *vc = ( SHBaseViewController *)[self topViewController];
    if([vc respondsToSelector:@selector(backBarButtonItemAction)])
    {
        [vc backBarButtonItemAction];
        shouldPop = NO;
    }
    
    if (shouldPop)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    else
    {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments /34452906
        for(UIView *subview in [navigationBar subviews])
        {
            if(subview.alpha < 1.f)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}


@end
