//
//  TestWKWebViewPerformanceVC.swift
//  JsNativeAndLocalHtmlDemo
//
//  Created by Ben on 2020/7/23.
//  Copyright © 2020 ZhangPeng. All rights reserved.
//

import UIKit
import WebKit

protocol MyWebViewTimingProtocal {
    func jsTiming()
}

extension WKWebView : MyWebViewTimingProtocal{
    
    /// 获取WebView的JS的性能数据
    func jsTiming() {
        let webView : WKWebView? = self
        if #available(iOS 10.0, *) {
            webView?.evaluateJavaScript("JSON.stringify(window.performance.timing.toJSON())") { (timingStr, error) in
                if error == nil && timingStr != nil {
                    JSTimingTool.parseJSTimingString(timingStr as! String)
                } else {
                    print("WKWebView Load Performance JS Faild!")
                }
            }
        } else {
            let jsFuncStr = "function flatten(obj) {"
                + "var ret = {}; "
                + "for (var i in obj) { "
                + "ret[i] = obj[i];"
                + "}"
                + "return ret;}"
            webView?.evaluateJavaScript(jsFuncStr) { (resultStr, error) in
                if error == nil && resultStr != nil {
                    webView?.evaluateJavaScript("JSON.stringify(flatten(window.performance.timing))", completionHandler: { (timingStr, error) in
                        if error == nil && timingStr != nil {
                            JSTimingTool.parseJSTimingString(timingStr as! String)
                        } else {
                            print("WKWebView Load Performance JS Faild!")
                        }
                    })
                } else {
                    print("WKWebView evaluateJavaScript Faild!")
                }
            }
        }
    }
}


/// 解析window.performance的工具类
private class JSTimingTool {
    
    
    /// 解析入口方法
    ///
    /// - Parameter timingStr:window.performance.timing字符串
    static func parseJSTimingString(_ timingStr: String) {
        if let dict = JSTimingTool.dictionaryFromString(timingStr) {
            JSTimingTool.parseJSTimingDictionary(dict)
        } else {
            print("Performance JS trans to Dictionary Faild!")
        }
    }
    
    
    /// 字符串转字典
    ///
    /// - Parameter str: 需要转换的字符串
    /// - Returns: 转换完成的字典
    static func dictionaryFromString(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    
    /// 分析性能数据字典
    ///
    /// - Parameter dict: window.performance.timing字典
    static func parseJSTimingDictionary(_ dict: Dictionary<String, Any>) {
        
        
        
        print("\(String(describing: dict))")
        
        
        let domainLookupStart = dict["domainLookupStart"] as! CLongLong
        let domainLookupEnd = dict["domainLookupEnd"] as! CLongLong
        let connectStart = dict["connectStart"] as! CLongLong
        let connectEnd = dict["connectEnd"] as! CLongLong
        let responseStart = dict["responseStart"] as! CLongLong
        let responseEnd = dict["responseEnd"] as! CLongLong
        let domInteractive = dict["domInteractive"] as! CLongLong
        let domComplete = dict["domComplete"] as! CLongLong
        let fetchStart = dict["fetchStart"] as! CLongLong
        let domLoading = dict["domLoading"] as! CLongLong
        let domContentLoadedEventEnd = dict["domContentLoadedEventEnd"] as! CLongLong
        let loadEventStart = dict["loadEventStart"] as! CLongLong
        let loadEventEnd = dict["loadEventEnd"] as! CLongLong
        
        let dnstiming = domainLookupEnd - domainLookupStart //DNS查询耗时
        let tcptiming = connectEnd - connectStart //TCP链接耗时
        let requesttiming = responseEnd - responseStart //request请求耗时
        let domtiming = domComplete - domInteractive //解析dom树耗时
        let wheetScreentiming = domLoading - fetchStart //白屏时间
        let domreadytiming = domContentLoadedEventEnd - fetchStart //dom ready时间
        let domloadtiming = loadEventEnd - loadEventStart //dom load时间
        let onloadtiming = loadEventEnd - fetchStart //onload总时间
        
        print("dnstiming:\(dnstiming)\ntcptiming:\(tcptiming)\nrequesttiming:\(requesttiming)\ndomtiming:\(domtiming)\nwheetScreentiming:\(wheetScreentiming)\ndomreadytiming:\(domreadytiming)\ndomloadtiming:\(domloadtiming)\nonloadtiming:\(onloadtiming)\n")
    }
}


@objc class TestWKWebViewPerformanceVC: UIViewController {
    
    @objc public var defaultConfigeration: WKWebViewConfiguration {
        get {
            let config = WKWebViewConfiguration.init()
            let preferences = WKPreferences.init()
            preferences.javaScriptCanOpenWindowsAutomatically = true
            config.preferences = preferences
            
            return config
        }
    }
    
    lazy var webview: WKWebView = {
        let wkwebView = WKWebView(frame: CGRect.zero, configuration: defaultConfigeration)
        wkwebView.navigationDelegate = self
//        wkwebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        return wkwebView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview.frame = view.bounds
        view.addSubview(webview)
        
        //guard let url = URL(string: "https://www.baidu.com") else { return }
//        guard let url = URL(string: "https://apph5-tst.changingedu.com/apph5/benxia.html") else { return }
        guard let url = URL(string: "https://apph5-tst.changingedu.com/liveapph5/course_report?ts=1589174951822.286133&city_id=4&actid=20170828_z1_1_cVK&chid=1001224&invitor_id=679510072&type=from_push&share_code=dqlF5kfqMW2BH54deqgB7Aidid#/23159") else { return }
        
        let request = URLRequest(url: url)
        webview.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension TestWKWebViewPerformanceVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.jsTiming()
    }
}
