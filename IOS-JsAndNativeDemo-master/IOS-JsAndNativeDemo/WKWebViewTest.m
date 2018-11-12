//
//  WKWebViewTest.m
//  WKWebView
//
//  Created by zhangPeng on 16/8/26.
//  Copyright © 2016年 ZhangPeng. All rights reserved.
//

#import "WKWebViewTest.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"

@interface WKWebViewTest ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;


@end

@implementation WKWebViewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    /*! 需要先注册一下这个JS的方法名称。 否则无法响应，  同时实现WKScriptMessageHandler代理
     window.webkit.messageHandlers.OOXX.postMessage()  //对应的方法
     */
    config.userContentController = userController;
    
    config.allowsPictureInPictureMediaPlayback = YES;  //是否支持视频以画中画的格式播放
    config.allowsInlineMediaPlayback = YES;   //是否支持在线录像播放

    // 通过JS与webview内容交互
    // 注入JS对象名称Zhujiayi，当JS通过Zhujiayi来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"Zhujiayi"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    self.webView.allowsBackForwardNavigationGestures =YES;//侧滑
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
//    NSString *filePath = [NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"index3" ofType:@"html"]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
//    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:pathUrl]];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.192/index3.html"]]];
    
    // 测试加载本地html、css、js、图片
//    NSURL *baseUrl = [NSURL URLWithString:@"file:///"];
//    [self.webView loadHTMLString:[self getHtmlString] baseURL:baseUrl];
    
    
    // 我这里是将html资源文件放置在工程内一个bundle的文件夹内
//    NSString *path = [[[NSBundle mainBundle] pathForResource:@"LocalH5" ofType:@"bundle"] stringByAppendingPathComponent:@"index.html"];
//    // 拼接后的网页路径
//    NSString *url = [self componentFileUrlWithOriginFilePath:path Dictionary:@{@"key":@"value"}];
//    // 加载网页
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    // WKWebView加载沙盒内Html页面
    // 将要加载的html路径
//    NSString *urlStr1 = @"~/Cache/fund/index.html";
//    // 将要加载的html路径的上一层级路径
//    NSString *urlStr2 = @"~/Cache/fund";
//    self.url = [self componentFileUrlWithOriginFilePath:urlStr1 Dictionary:@{@"key":@"value"}];
//
//    [self.webView loadFileURL:[NSURL URLWithString:self.url] allowingReadAccessToURL:[NSURL fileURLWithPath:urlStr2]];

    
    [self.view addSubview:self.webView];
}

- (NSString *)getHtmlString {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"css"]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</body>"];
    [html appendFormat:@"<script src=\"%@\"></script>", [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"js"]];
    [html appendString:@"</html>"];
    
    return html;
}

- (NSString *)getBodyString {
    NSURL *imagePathUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"png"];
    
    return [NSString stringWithFormat:@"<div class=\"bottom_text\" id=\"bottom_text\">hello world</div><div class=\"image_content\"><img id=\"justdoit_image\" src=\"%@\" alt=\"logo image\" /></div>", imagePathUrl];
}

/**
 本地网页数据拼接
 
 @param filePath 网页路径
 @param dictionary 拼接的参数
 @return 拼接后网页路径字符串
 */
- (NSString *)componentFileUrlWithOriginFilePath:(NSString *)filePath Dictionary:(NSDictionary *)dictionary{
    NSURL *url = [NSURL fileURLWithPath:filePath isDirectory:NO];
    // NO代表此路径没有下一级，等同于[NSURL fileURLWithPath:filePath];
    // 如果设置为YES，则路径会自动添加一个“/”
    NSURLComponents *urlComponents = [[NSURLComponents alloc]initWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSString *key in dictionary.allKeys) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:dictionary[key]];
        [mutArray addObject:item];
    }
    [urlComponents setQueryItems:mutArray];
    // urlComponents.URL  返回拼接后的(NSURL *)
    // urlComponents.string 返回拼接后的(NSString *)
    return urlComponents.string;
}

#pragma mark- WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // 页面开始加载时调用
    NSLog(@"页面开始加载    %s",__func__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    // 当内容开始返回时调用
    NSLog(@"内容开始返回    %s",__func__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 页面加载完成之后调用
    NSLog(@"页面加载完成    %s",__func__);
    
    //native执行一行js代码
    [self.webView evaluateJavaScript:@"alert('调用js的弹框')" completionHandler:^(id _Nullable value, NSError* _Nullable error) {
        NSLog(@"%@", value);
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    // 页面加载失败时调用
    NSLog(@"页面加载失败    %s",__func__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // 接收到服务器跳转请求之后再执行
    NSLog(@"%s",__func__);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    // 在收到响应后，决定是否跳转
    NSLog(@"%s",__func__);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 在发送请求之前，决定是否跳转
    NSLog(@"%s",__func__);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate

//2.WebVeiw关闭（9.0中的新方法）
- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

//3.显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
        NSLog(@"输出Alert 点击");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"%@", message);
}

//4.弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    // OC 弹窗口界面创建
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"js调用OC TextField" message:@"务必谨慎" preferredStyle:UIAlertControllerStyleAlert];
    
    // add textField
    __block UITextField *_textfield = nil;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blueColor];
        textField.placeholder = @"请输入:...";
        
        _textfield = textField;
    }];
    
    
    // add confirm item
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"confirm点击后回调");
        
        completionHandler(_textfield.text);
    }];
    
    [alertVC addAction:confirm];
    
    // add cancel item
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel点击后回调");
        completionHandler(_textfield.text = @"cancel");
    }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:^{
        NSLog(@"弹窗口显示完成");
    }];
}

//5.显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    // OC 弹窗口界面创建
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"js调用OC弹窗视图" message:@"务必谨慎" preferredStyle:UIAlertControllerStyleAlert];
    
    // confirm item
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"confirm点击后回调");
        completionHandler(NO);
    }];
    
    [alertVC addAction:confirm];
    
    // cancel item
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel点击后回调");
        completionHandler(YES);
    }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:^{
        NSLog(@"弹窗口显示完成");
    }];
}

#pragma mark- WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"Zhujiayi"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
        
        NSDictionary *dataMsgDic = message.body;
        
        if ([dataMsgDic[@"hhh"] isEqualToString:@"hhhh"]) {
            NSLog(@"回调");
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                [SVProgressHUD showInfoWithStatus:@"完成加载"];
            //
            //            });
            
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            /**
             *  @"iosCallback('%@')"  这个就是js的方法
             *  evaluateJavaScript: 这个方法就是回调js的方法
             *  value  就是js是否收到我们的回调，给我们的返回值
             *  error 回调失败返回的原因
             *
             */
            NSString *script = [NSString stringWithFormat:@"iosCallback('%@')", app_Version];
            
            
            [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable value, NSError* _Nullable error) {
                NSLog(@"%@", value);
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


