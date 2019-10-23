//
//  SHHomeWebViewController.m
//  INewsX
//
//  Created by sherwin.chen on 2019/7/30.
//  Copyright © 2019 Sherwin.Chen. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "SHHomeWebViewController.h"
#import "SHDetailWebViewController.h"
#import "JKLoadingView.h"

@interface SHHomeWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) JKLoadingView *loadingView;

@end

@implementation SHHomeWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = YES;

    [self.view addSubview:self.webView];

    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHtmlData];
    }];

    self.loadingView = [[JKLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];


    [self loadHtmlData];

    return;
}

-(void) loadHtmlData {

    [self.loadingView show];

    NSURLRequest *curReq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrlStr]];
    [self.webView loadRequest:curReq];

    [self.webView.scrollView.mj_header endRefreshing];
    return;
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url          = navigationAction.request.URL;
    //NSString *scheme    = url.scheme;
    NSString *urlString = url.absoluteString;

    if([urlString isEqualToString:self.webUrlStr]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {

        SHDetailWebViewController *detailWebVC = [[SHDetailWebViewController alloc] init];
        detailWebVC.webUrlStr = urlString;
        detailWebVC.title = self.webView.title;
        [self.navigationController pushViewController:detailWebVC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }

}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.loadingView show];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

    [self.loadingView dissmiss];
    return;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

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
@end
