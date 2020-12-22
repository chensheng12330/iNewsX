//
//  SHDetailWebViewController.m
//  INewsX
//
//  Created by sherwin.chen on 2019/7/30.
//  Copyright © 2019 Sherwin.Chen. All rights reserved.
//

#import "SHDetailWebViewController.h"

#import "JKLoadingView.h"

#import <WebKit/WebKit.h>
#import <WebKit/WKWebViewConfiguration.h>
#import "HLLWKURLProtocol.h"

@interface SHDetailWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property(nonatomic, strong) JKLoadingView *loadingView;
@end


@implementation SHDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback=true;
    [configuration ssRegisterURLProtocol:[HLLWKURLProtocol class]];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];

    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHtmlData];
    }];

    self.loadingView = [[JKLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];


    [self loadHtmlData];


    //分享
    UIBarButtonItem *sysBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(open4Safari)];
    sysBarItem1.tintColor = [UIColor systemBlueColor];
    self.navigationItem.rightBarButtonItem = sysBarItem1;
    
    //返回- 判断当前页面是否为H5内部多级跳转
    /**
     屏右滑直接返回上级
     按返回按钮，先H5内部返回，再VC页面返回.
     
     */
    [self setLeftBarButtonItem];
    return;
}

-(void)setLeftBarButtonItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *arrowImage = [UIImage imageNamed:@"icon_arrow_black_nor"];
    //backButton.frame = CGRectMakeWithSize(arrowImage.size);
    //backButton.frame = CGRectMake(0, 0, 44, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton setImage:arrowImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}


-(void) loadHtmlData {

    [self.loadingView show];

    NSURLRequest *curReq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrlStr]];
    [self.webView loadRequest:curReq];

    [self.webView.scrollView.mj_header endRefreshing];
    return;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.loadingView show];

}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

    //[self change2WhiteBackGround];
    // NSLog(@"----> didCommitNavigation %@ ",navigation);
    [self.loadingView dissmiss];
    return;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [self change2WhiteBackGround];
    // NSLog(@"----> didFinishNavigation %@ ",navigation);
    [self.loadingView dissmiss];

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    [self.loadingView dissmiss];

    if (error.code == NSURLErrorCancelled) {
        return;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingView dissmiss];
}

/// 处理页面白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self loadHtmlData];
}

-(void) change2WhiteBackGround {
    [self.webView evaluateJavaScript:@"document.body.style.backgroundColor='#ffffff';" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%@",error);

    }];
}

- (void) open4Safari {

    //获取当前Url
    //用safari打开.

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webUrlStr]];
}

- (void) backButtonAction:(UIButton*) sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}
@end
