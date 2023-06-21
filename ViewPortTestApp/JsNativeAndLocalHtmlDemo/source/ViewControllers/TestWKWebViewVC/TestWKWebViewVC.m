//
//  TestWKWebViewVC.m
//  WKWebView
//
//  Created by Ben on 18/11/1.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "TestWKWebViewVC.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"
#import "NSString+URL.h"

@interface TestWKWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TestWKWebViewVC

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
        window.webkit.messageHandlers.<name>.postMessage(<messageBody>)  //对应的JS中调用方式
     */
    config.userContentController = userController;
    
    config.allowsPictureInPictureMediaPlayback = YES;  //是否支持视频以画中画的格式播放
    config.allowsInlineMediaPlayback = YES;   //是否支持在线录像播放

    // 通过JS与webview内容交互
    // 注入JS对象名称BenJSExternal，当JS通过BenJSExternal来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"BenJSExternal"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    self.webView.allowsBackForwardNavigationGestures =YES;//侧滑
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    // 1. 加载本地 html（这种方法 UIWebView 可以但是 WKWebView 不行）
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"html"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    // 2. 加载本地 html
//    NSString *filePath = [NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"local" ofType:@"html"]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    // 3. 加载本地 html
//    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:pathUrl]];
    
    // 4. 加载远程 html
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.192/local.html"]]];
    
    // 5. 测试加载本地html、css、js、图片
//    NSURL *baseUrl = [NSURL URLWithString:@"file:///"];
//    [self.webView loadHTMLString:[self getHtmlString] baseURL:baseUrl];

    // 6. 我这里是将html资源文件放置在工程内一个bundle的文件夹内
//    NSString *path = [[[NSBundle mainBundle] pathForResource:@"LocalH5" ofType:@"bundle"] stringByAppendingPathComponent:@"index.html"];
//    // 拼接后的网页路径
//    NSString *urlString = [self componentFileUrlWithOriginFilePath:path dictionary:@{@"arg1Name":@"arg1Value"}];
//    // 加载网页
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    // 7. WKWebView加载 main bundle 中 html、css、js、图片
    // 将要加载的html路径
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    // 将要加载的html路径的上一层级路径
//    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//
//    NSString *urlString = [self componentFileUrlWithOriginFilePath:htmlPath dictionary:@{@"arg1Name":@"arg1Value"}];
//    [self.webView loadFileURL:[NSURL URLWithString:urlString] allowingReadAccessToURL:bundleUrl];
    
    // 8. 添加参数方式的研究
    // 将要加载的html路径
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    // 将要加载的html路径的上一层级路径
//    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    // 下面的两种都不能用
//    NSString *testPath = [htmlPath stringByAppendingPathComponent:[NSString stringWithFormat:@"?sId=417492&apiUrl=%@", [@"http://192.168.100.1:8888?abc=def" URLEncodedString]]];
//    NSLog (@"NSURL URLWithString:\n %@", [NSURL URLWithString:testPath]);
//    // /Users/xiaxuqiang/Library/Developer/CoreSimulator/Devices/17CD3688-56DF-4E82-B8D5-FAABB0AA646E/data/Containers/Bundle/Ap ... bc%3Ddef
//    NSLog (@"NSURL fileURLWithPath:\n %@", [NSURL fileURLWithPath:testPath]);
//    // file:///Users/xiaxuqiang/Library/Developer/CoreSimulator/Devices/17CD3688-56DF-4E82-B8D5-FAABB0AA646E/data/Containers/Bundle/Application/16D93DA8-E8D5-48B2-839D-094C007F68FE/JsNativeAndLocalHtmlDemo.app/index.html/%3FsId=417492&apiUrl=http%253A%252F%252F192.168.100.1%253A8888%253Fabc%253Ddef
////    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:testPath]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:testPath]]];
    
    // 不能用
//    NSString *testPath2 = [htmlPath stringByAppendingString:[NSString stringWithFormat:@"?sId=417492&apiUrl=%@", [@"http://192.168.100.1:8888?abc=def" URLEncodedString]]];
//    NSLog (@"NSURL fileURLWithPath:\n %@", [NSURL fileURLWithPath:testPath2]);
//    // file:///Users/xiaxuqiang/Library/Developer/CoreSimulator/Devices/17CD3688-56DF-4E82-B8D5-FAABB0AA646E/data/Containers/Bundle/Application/E9B169DF-0FCF-4DFE-AB8B-721734E64C9E/JsNativeAndLocalHtmlDemo.app/index.html%3FsId=417492&apiUrl=http%253A%252F%252F192.168.100.1%253A8888%253Fabc%253Ddef
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:testPath2]]];
    
    // 能用
//    NSString *filePath = [htmlPath stringByAppendingString:[NSString stringWithFormat:@"?sId=417492&apiUrl=%@", [@"http://192.168.100.1:8888?abc=def" URLEncodedString]]];
//    NSLog (@"NSURL URLWithString:\n %@", [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filePath]]);
//    // file:///Users/xiaxuqiang/Library/Developer/CoreSimulator/Devices/17CD3688-56DF-4E82-B8D5-FAABB0AA646E/data/Containers/Bundle/Application/FE0390B8-8C0B-49D2-817E-3B407B0EBC5E/JsNativeAndLocalHtmlDemo.app/index.html?sId=417492&apiUrl=http%3A%2F%2F192.168.100.1%3A8888%3Fabc%3Ddef
//    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filePath]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
    
    // 能用
//    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?sId=417492&apiUrl=%@", [@"http://192.168.100.1:8888?abc=def" URLEncodedString]]
//                            relativeToURL:[NSURL fileURLWithPath:htmlPath]];   // 注意该处换成 [NSURL URLWithString: htmlPath] 就不能正常使用了
//    [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
    
    // 能用
//    NSString *urlString = [self componentFileUrlWithOriginFilePath:htmlPath dictionary:@{@"sId":@"417492", @"apiUrl":[@"http://192.168.100.1:8888?abc=def" URLEncodedString]}];
//    [self.webView loadFileURL:[NSURL URLWithString:urlString] allowingReadAccessToURL:bundleUrl];
    
//    NSURL *url = [NSURL URLWithString:[testPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//    NSURL *fileUrl = [NSURL fileURLWithPath:[testPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:testPath]]];
    
    // 9. URL 编码 API 的研究
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    // (1). API : stringByAddingPercentEncodingWithAllowedCharacters
//    NSString *urlArgPath = [@"http:#<>[|+ //192.168.100.1:8888?abc=def" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//    // URLUserAllowedCharacterSet      除掉 "#%/:<>?@[\]^`
//    // URLPasswordAllowedCharacterSet  除掉 "#%/:<>?@[\]^`{|}
//    // URLHostAllowedCharacterSet      除掉 "#%/<>?@\^`{|}
//    // URLPathAllowedCharacterSet      除掉 "#%;<>?[\]^`{|}
//    // URLQueryAllowedCharacterSet     除掉 "#%<>[\]^`{|}
//    // URLFragmentAllowedCharacterSet  除掉 "#%<>[\]^`{|}
//    NSString *testPath = [htmlPath stringByAppendingFormat:@"?sId=417492&apiUrl=%@", urlArgPath];
//    NSString *testPathBefore = [testPath stringByRemovingPercentEncoding];
//    NSLog (@"testPath:\n%@", testPath);
//    NSLog (@"testPathBefore:\n%@", testPathBefore);
//    // (2). API : CFURLCreateStringByAddingPercentEscapes
//    NSString *testPath2 = [htmlPath stringByAppendingPathComponent:[NSString stringWithFormat:@"?sId=417492&apiUrl=%@", [@"http:#<>\|+ //192.168.100.1:8888?abc=def" URLEncodedString]]];
//    // 如下字符会被转义  "!*'();:@&=+$,/?%#[]"   (RFC3986 中指定了以下字符为保留字符：　"! * ' ( ) ; : @ & =+ $ , / ? # [ ]"，另外 % 是转义字符，所以一共 19 个字符）
//    NSLog (@"testPath2:\n%@", testPath2);
//    // (3). 了解一下 JS 中的 escape             会对 "!'();:&=$,?%#[]" 字符进行转义（不包括 "*@+/")，unescape 也只对这个字符集做解码
//    //      了解一下 JS 中的 encodeURI          会对 "%[]" 字符进行转义，decodeURI 也只对这个字符集做解码
//    //      了解一下 JS 中的 encodeURIComponent 会对 ";:@&=+$,/?%#[]" 字符进行转义（不包括 "!*'()")，decodeURIComponent 也只对这个字符集做解码
//    //
//    //      escape （安全字符 69 个， ECMAScript v3 反对使用该方法，应用使用 decodeURI() 和 decodeURIComponent() 替代它） */@+-._0-9a-zA-Z
//    //      encodeURI （安全字符 82 个，被用作对一个完整的 URI 进行编码） !#$&'()*+,/:;=?@-._~0-9a-zA-Z
//    //      encodeURIComponent （安全字符 71 个，被用作对 URI 的一个组件进行编码） !'()*-._~0-9a-zA-Z   ( 注意+ 号未在其安全字符里)
    
    // 10. WKWebView加载沙盒内 html、css、js、图片（支持传参数）
    [self bundleToDocuments:@"index.html" existsCover:YES];
    [self bundleToDocuments:@"test.css" existsCover:YES];
    [self bundleToDocuments:@"test.js" existsCover:YES];
    [self bundleToDocuments:@"test.png" existsCover:YES];
    [self bundleToDocuments:@"test.jpg" existsCover:YES];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //找到 Documents 目录
    NSString *htmlPath = [documentsDirectory stringByAppendingPathComponent:@"index.html"];
    NSURL *baseUrl = [NSURL fileURLWithPath:documentsDirectory];
    NSString *urlString = [self componentFileUrlWithOriginFilePath:htmlPath dictionary:@{@"sId":@"417492", @"apiUrl":[@"http://192.168.100.1:8888?abc=def" URLEncodedString]}];
    [self.webView loadFileURL:[NSURL URLWithString:urlString] allowingReadAccessToURL:baseUrl];
    
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
- (NSString *)componentFileUrlWithOriginFilePath:(NSString *)filePath dictionary:(NSDictionary *)dictionary{
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

// 把 mainBundle 中的文件拷贝到 Documents 目录下，并指定是否覆盖，YES 则覆盖
- (void)bundleToDocuments:(NSString *)fileName existsCover:(BOOL)cover {
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //找到 Documents 目录
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (!cover) {
        success = [fileManager fileExistsAtPath:targetPath];
        if (success) return;
    } else {
        [fileManager removeItemAtPath:targetPath error:&error];
    }
    //把 mainBundle 中的文件拷贝到 targetPath
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    //如果文件存在了则不能覆盖，所以前面才要先把它删除掉
    success = [fileManager copyItemAtPath:bundlePath toPath:targetPath error:&error];
    if (!success) {
        NSLog(@"'%@' 文件从 app 包里拷贝到 Documents 目录，失败:%@", fileName, error);
    } else {
        NSLog(@"'%@' 文件从 app 包里已经成功拷贝到了 Documents 目录。", fileName);
    }
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
    
//    //native执行一行js代码
//    [self.webView evaluateJavaScript:@"alert('调用js的弹框')" completionHandler:^(id _Nullable value, NSError* _Nullable error) {
//        NSLog(@"%@", value);
//    }];
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
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    if ([message.name isEqualToString:@"BenJSExternal"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        NSDictionary *dataMsgDic = message.body;
        
        NSString *funcName = dataMsgDic[@"func"];
        
        if ([funcName isEqualToString:@"getVersion"]) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *script = [NSString stringWithFormat:@"callbackInWKWebView('%@', '%@')", funcName, app_Version];

            [self.webView evaluateJavaScript:script completionHandler:^(id value, NSError* _Nullable error) {
                NSLog(@"%@", value);
            }];
        } else if ([funcName isEqualToString:@"getSum"]) {
            NSArray <NSNumber *> *valuesArray = dataMsgDic[@"args"];
            CGFloat sum = 0;
            for (int i = 0; i < valuesArray.count; i++) {
                NSNumber *value = valuesArray[i];
                sum += [value floatValue];
            }
            
            NSString *script = [NSString stringWithFormat:@"callbackInWKWebView('%@', '%f')", funcName, sum];
            
            [self.webView evaluateJavaScript:script completionHandler:^(id value, NSError* _Nullable error) {
                NSLog(@"%@", value);
            }];
        } else if ([funcName isEqualToString:@"showNotice"]) {
            NSString *message = dataMsgDic[@"message"];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSString *script = [NSString stringWithFormat:@"callbackInWKWebView('%@', 'success')", funcName];
                
                [self.webView evaluateJavaScript:script completionHandler:^(id value, NSError* _Nullable error) {
                    NSLog(@"%@", value);
                }];
            }];
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


