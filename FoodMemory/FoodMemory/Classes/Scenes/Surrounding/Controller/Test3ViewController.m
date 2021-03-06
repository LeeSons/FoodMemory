//
//  Test3ViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "Test3ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface Test3ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *web;

@property WebViewJavascriptBridge* bridge;

@end

@implementation Test3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.web loadRequest:req];
    self.web.scrollView.bounces = NO;
    [self.view addSubview:_web];
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
