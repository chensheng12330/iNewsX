//
//  WebViewController.m
//  AFNetworking iOS Example
//
//  Created by sherwin.chen on 15-6-17.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *addressURL;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.webView];
    
    
    //
    
    self.addressURL = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.url];
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]] ];
    
    
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:self.addressURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    //异步链接(形式1,较少用)
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (connectionError==NULL) {
         
            NSDictionary *infoData = [data objectFromJSONData];
            
            NSDictionary *allVal = infoData[self.url];
            
            NSString *body = allVal[@"body"];
            
            if (((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage) {
                
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
            
            [self.webView loadHTMLString:body baseURL:[NSURL URLWithString:self.addressURL]];
        }
       
    }];
    
}

@end
