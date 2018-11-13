//
//  WWBaseWebViewController.m
//  WKWebViewDemo1
//
//  Created by JackLee on 2018/2/27.
//  Copyright © 2018年 JackLee. All rights reserved.
//

#import "WWBaseWebViewController.h"
#import "NSURLProtocolCustom.h"

@interface WWBaseWebViewController ()
@property (nonatomic,strong) UIWebView *myWebView;
@end

@implementation WWBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.注册自定义类
    [NSURLProtocol registerClass:[NSURLProtocolCustom class]];
    //2.添加
    [self.view addSubview:self.myWebView];
}  

- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _myWebView.backgroundColor = [UIColor redColor];
        _myWebView.scalesPageToFit = YES;
        _myWebView.delegate = self;
        NSURL *url = [[NSURL alloc] initWithString:self.urlStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_myWebView loadRequest:request];
    }
    return _myWebView;
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
