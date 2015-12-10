//
//  TestViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "TestViewController.h"
#import "WebViewJavascriptBridge.h"
#import "Test2ViewController.h"
@interface TestViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *web;

@property WebViewJavascriptBridge* bridge;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://www.msshuo.cn/app_1_4/hot/raiders?tpl=raiders&crowd"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:req];
    self.web.delegate = self;
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.web handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Received message from javascript: %@", data);
        responseCallback(@"Right back atcha");
    }];
    [self.bridge registerHandler:@"openURLFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *url = data[@"url"];
        Test2ViewController *test2 = [[Test2ViewController alloc] init];
        test2.url = url;
        [self.navigationController pushViewController:test2 animated:YES];
    }];
    [self.bridge registerHandler:@"isLoginedFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"%@",data);
       // responseCallback(NULL);
        responseCallback(@"undef");
        
    }];
    [self.bridge registerHandler:@"loginFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"%@",data);
    }];
    [self.bridge registerHandler:@"Mylike_get" handler:^(id data, WVJBResponseCallback responseCallback) {
        LCPLog(@"%@",data);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *jsCode = [NSString stringWithFormat:@"alert(1);"];
//    [self.web stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
