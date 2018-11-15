//
//  WebViewTest.m
//  IOS-JsAndNativeDemo
//
//  Created by zhangPeng on 16/8/26.
//  Copyright © 2016年 ZhangPeng. All rights reserved.
//

#import "WebViewTest.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TestActionProxy.h"

@interface WebViewTest ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _webView.delegate = self;
    
    // 1. 加载本地 html
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index3" ofType:@"html"];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    // 2. 加载本地 html
//    NSString *filePath = [NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"index3" ofType:@"html"]];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    // 3. 加载本地 html
//    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
//    [_webView loadRequest:[NSURLRequest requestWithURL:pathUrl]];
    
    // 4. 加载远程 html
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.192/index3.html"]]];
    
    // 5. 测试加载本地html、css、js、图片
//    NSURL *baseUrl = [NSURL URLWithString:@"file:///"];
//    [_webView loadHTMLString:[self getHtmlString] baseURL:baseUrl];
    
    // 6. 我这里是将html资源文件放置在工程内一个bundle的文件夹内
//    NSString *path = [[[NSBundle mainBundle] pathForResource:@"LocalH5" ofType:@"bundle"] stringByAppendingPathComponent:@"index.html"];
//    // 拼接后的网页路径
//    NSString *urlString = [self componentFileUrlWithOriginFilePath:path Dictionary:@{@"key":@"value"}];
//    // 加载网页
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    // 7. UIWebView加载沙盒内Html页面
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//
//    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath
//                                                     encoding:NSUTF8StringEncoding
//                                                        error:nil];
//    [_webView loadHTMLString:htmlString baseURL:bundleUrl];
    
    // 8. UIWebView加载沙盒内Html页面
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSData *htmlData = [[NSData alloc] initWithContentsOfFile:htmlPath];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [_webView loadData:htmlData
              MIMEType:@"text/html"
      textEncodingName:@"UTF-8"
               baseURL:bundleUrl];
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
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
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

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    
    
    //    原理：
    //    通过JavaScriptCore解决JS和iOS之间的交互
    
    /**
     *说明：
     JavaScriptCore是封装了JavaScript和Objective-C桥接的Objective-C API，只需要较少的的代码，就可以实现JavaScript与Objective-C的相互调用。
     iOS7之后苹果推出了JavaScriptCore这个框架，从而让web页面和本地原生应用交互起来非常方便，而且使用此框架可以做到Android那边和iOS相对统一，web前端写一套代码就可以适配客户端的两个平台，从而减少了web前端的工作量。
     iOS和Android协商好定义方法名称，然后把这个名称告知h5即可，在这里其实也可以有h5定义好，告知我们，这样减少我们的协商。
     
     JavaScriptCore中类及协议：
     JSContext：给JavaScript提供运行的上下文环境，JSContext是代表JS的执行环境，通过-evaluateScript:方法就可以执行一JS代码
     JSValue：JSValue封装了JS与ObjC中的对应的类型，以及调用JS的API等，可以理解为JavaScript和Objective-C数据和方法的桥梁
     JSManagedValue：管理数据和方法的类
     JSVirtualMachine：处理线程相关，使用较少
     JSExport：JSExport是一个协议，遵守此协议，就可以定义我们自己的协议，在协议中声明的API都会在JS中暴露出来，才能调用
     
     */
    
    
    //native 调用  js
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext)
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    // oc调用js 第一种
    //    [webView stringByEvaluatingJavaScriptFromString:@"alert('这是个弹框')"];
    
    // oc调用js 第二种
    //        NSString *alertJS=@"alert('这是个弹框')"; //准备执行的js代码
    //        [context evaluateScript:alertJS];//通过oc方法调用js的alert
    
    
    /**
     *  js调用iOS
     *  js里面通过对象调用方法
     */
    
    
    //js是通过对象调用的，我们js里面有一个对象 Zhujiayi 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    
    TestActionProxy * actionProxy = [[TestActionProxy alloc]init];
    context[@"Zhujiayi"] = actionProxy;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


