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
#import "JSONHTTPClient.h"

#import <WebKit/WKWebView.h>

@interface WebViewController ()
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *addressURL;

@property(nonatomic, strong) JKLoadingView *mLoadingView;

//@property(nonatomic, copy) NSString *webTitle;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.webView];

    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHtmlData];
    }];

    self.mLoadingView = [[JKLoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mLoadingView];


    [self loadHtmlData];

    UIBarButtonItem *sysBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(open4Safari)];
    sysBarItem1.tintColor = [UIColor systemBlueColor];

    self.navigationItem.rightBarButtonItem = sysBarItem1;
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


        if ([COM getNeedImage]) {

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
                              <style type=\"text/css\">body{background: #%@;font-size: %@px;} </style> \
                              <body> \
                              %@ \
                              </body> \
                              </html>",[COM getBgColor],[COM getFontSize], body];

        [self.webView loadHTMLString:htmlCode baseURL:[NSURL URLWithString:self.addressURL]];

        // [tip hideAnimated:YES];
        if(body.length<1) {

            [QMUITips showInfo:@"未获取到数据." inView:COM.appDelegate.window hideAfterDelay:1];
            
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        [self.webView.scrollView.mj_header  endRefreshing];
        [self.mLoadingView dissmiss];

        [QMUITips showError:@"网络问题，加载失败" inView:COM.appDelegate.window hideAfterDelay:2];

    }];

}
//http://sunny90.com/ios/rss/full.php?docid=EU1L0GB705118O8G&title=长城欧拉电池技术解读

- (void) open4Safari {

    //获取当前Url
    //用safari打开.

    NSString *rssAdd = @"http://sunny90.com/ios/rss/full.php";
    NSString *url = [NSString stringWithFormat:@"%@?docid=%@&title=%@",rssAdd,self.docid,self.title];

    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
