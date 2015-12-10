//
//  Test2ViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "Test2ViewController.h"
#import "WebViewJavascriptBridge.h"
#import "Test3ViewController.h"
@interface Test2ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *web;

@property WebViewJavascriptBridge* bridge;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.web loadRequest:req];
    self.web.scrollView.bounces = NO;
    [self.view addSubview:_web];
    
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.web handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Right back atcha");
    }];
    [self.bridge registerHandler:@"openAppUrlFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *url = data[@"url"];
        Test3ViewController *test3 = [[Test3ViewController alloc] init];
        test3.url = url;
        [self.navigationController pushViewController:test3 animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
