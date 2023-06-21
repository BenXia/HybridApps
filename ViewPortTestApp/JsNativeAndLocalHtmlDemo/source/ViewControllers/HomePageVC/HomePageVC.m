//
//  HomePageVC.m
//  JsNativeAndLocalHtmlDemo
//
//  Created by Ben on 18/11/1.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "HomePageVC.h"
#import "TestUIWebViewVC.h"
#import "TestWKWebViewVC.h"
#import "JsNativeAndLocalHtmlDemo-Swift.h"

@interface HomePageVC ()

@end

@implementation HomePageVC

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

- (IBAction)wkWebViewPerformanceBtnClick:(id)sender {
    TestWKWebViewPerformanceVC *performanceTestVC = [[TestWKWebViewPerformanceVC alloc] init];
    [self.navigationController pushViewController:performanceTestVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


