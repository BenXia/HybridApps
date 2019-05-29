//
//  ViewController.m
//  WKWebViewDemo1
//
//  Created by JackLee on 2018/2/27.
//  Copyright © 2018年 JackLee. All rights reserved.
//

#import "ViewController.h"
#import "WWBaseWKWebViewController.h"
#import "WWBaseWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 69, 30);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonClicked{
    WWBaseWKWebViewController *webVC = [WWBaseWKWebViewController new];
    //webVC.urlStr = @"https://www.baidu.com";
    // 注意：在safari浏览器中发现一个bug，即用户选择本地的图片文件时，如果使用了crossorigin话也会报错，解决办法是判断图片的地址是否是以http开头的
    webVC.urlStr = @"https://apph5-tst.changingedu.com/apph5/student/ta_assistant#/assistant";
    
    //webVC.urlStr = @"http:192.168.1.34/webTest/app.html";
    //WWBaseWebViewController *webVC = [WWBaseWebViewController new];
    //webVC.urlStr = @"http:192.168.10.48/webTest/app.html";
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
