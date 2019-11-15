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

    //设置返回主页按钮
    //UINavigationItem

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 35, 35)];
    //[btn setBackgroundColor:[UIColor darkGrayColor]];
    /*
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius= 4.0f;
     */

    //🔙🔜←→⇤⇥⇠⇢  👈⎈⌘⚙︎
    [btn setTitle:@"🔙" forState:UIControlStateNormal ];
    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];

    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(0, 0, 35, 35)];
    /*
    //[btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    btn2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    btn2.layer.borderWidth = 1.0f;
    btn2.layer.cornerRadius= 4.0f; 👉
     */
    [btn2 setTitle:@"🔜" forState:UIControlStateNormal ];
    [btn2 setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    //[btn2 setTintColor:[UIColor systemBlueColor]];
    [btn2 addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn];

     UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];


/*
    UIBarButtonItem *sysBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack:)];
    sysBarItem1.tintColor = [UIColor systemBlueColor];

    UIBarButtonItem *sysBarItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward:)];
    sysBarItem2.tintColor = [UIColor systemBlueColor];

    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBarItem.width = -40;
*/
    self.navigationItem.rightBarButtonItems =@[barButtonItem2,barButtonItem1];

    return;
}

-(void) loadHtmlData {

    [self.loadingView show];

    NSURLRequest *curReq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrlStr]];
    [self.webView loadRequest:curReq];

    [self.webView.scrollView.mj_header endRefreshing];
    return;
}

-(void)goBack:(UIButton*) sender {
    [self.webView goBack];
}

-(void)goForward:(UIButton*) sender {
    [self.webView goForward];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url          = navigationAction.request.URL;
    //NSString *scheme    = url.scheme;
    NSString *urlString = url.absoluteString;

    if([urlString isEqualToString:self.webUrlStr] ||
       [urlString containsString:@"/page/"]){
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

    //[self change2WhiteBackGround];
    [self.loadingView dissmiss];
    return;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [self change2WhiteBackGround];
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
@end
