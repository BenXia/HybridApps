//
//  ViewController.m
//  JsNativeAndLocalHtmlDemo
//
//  Created by Ben on 18/11/1.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "ViewController.h"
#import "TestUIWebViewVC.h"
#import "TestWKWebViewVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)uiWebViewBtnClick:(UIButton *)sender {
    TestUIWebViewVC *webTest = [[TestUIWebViewVC alloc] init];
    [self.navigationController pushViewController:webTest animated:YES];
}

- (IBAction)wkWebViewBtnClick:(UIButton *)sender {
    TestWKWebViewVC *wkWebTest = [[TestWKWebViewVC alloc] init];
    [self.navigationController pushViewController:wkWebTest animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
