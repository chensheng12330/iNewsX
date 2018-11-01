//
//  WebViewController.m
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "WebViewController.h"
#import "SHNewsGetApi.h"
#import "JKLoadingView.h"

#import <WebKit/WKWebView.h>

@interface WebViewController ()
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *addressURL;

@property(nonatomic, strong) JKLoadingView *mLoadingView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];

    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHtmlData];
    }];

    self.mLoadingView = [[JKLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mLoadingView];


    [self loadHtmlData];

    return;
}

-(void) loadHtmlData {

    [self.mLoadingView show];

    SHNewsDetailGetApi *newsInfoApi = [[SHNewsDetailGetApi alloc] initWithDocid:self.docid];
    [newsInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {

        [self.webView.scrollView.mj_header  endRefreshing];
        [self.mLoadingView dissmiss];


        NSDictionary *infoData = request.responseJSONObject;

        NSDictionary *allVal = infoData[self.docid];

        NSString *body = allVal[@"body"];


        if (COM.appDelegate.isNeedImage) {

            NSArray *imgs = allVal[@"img"];
            for (NSDictionary *dict in imgs) {
                NSString *ref = dict[@"ref"];
                NSString *src = dict[@"src"];
                ///<style>img{width:320px !important;}
                if (ref!=NULL  && src!=NULL) {
                    src = [NSString stringWithFormat:@"<img src=\"%@\" style=\"width:320px !important;\"/>",src];

                    body = [body stringByReplacingOccurrencesOfString:ref withString:src];
                }
            }
        }
        //image replace
        ///< src="/i/eg_tulip.jpg">

        NSString *htmlCode = [NSString stringWithFormat:@"\
                              <html>\
                              <head>\
                              <meta charset=\"utf-8\"> \
                              <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\
                              </head>\
                              <style type=\"text/css\">body{background: rgba(0,255,0,0.03);} </style> \
                              <body> \
                              %@ \
                              </body> \
                              </html>",body];

        [self.webView loadHTMLString:htmlCode baseURL:[NSURL URLWithString:self.addressURL]];

        // [tip hideAnimated:YES];


    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        [self.webView.scrollView.mj_header  endRefreshing];
        [self.mLoadingView dissmiss];

        [QMUITips showError:@"网络问题，加载失败" inView:COM.appDelegate.window hideAfterDelay:2];

    }];

}

@end
