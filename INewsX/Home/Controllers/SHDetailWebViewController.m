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

@interface SHDetailWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property(nonatomic, strong) JKLoadingView *loadingView;
@end


@implementation SHDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.view addSubview:self.webView];

    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHtmlData];
    }];

    self.loadingView = [[JKLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];


    [self loadHtmlData];


    UIBarButtonItem *sysBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(open4Safari)];
    sysBarItem1.tintColor = [UIColor systemBlueColor];

    self.navigationItem.rightBarButtonItem = sysBarItem1;

    return;
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
@end
