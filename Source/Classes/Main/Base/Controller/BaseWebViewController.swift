//
//  BaseWebViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    public var urlStr : String!
    
    public var webView: WKWebView!
    
    public var shouldReload = true
    //public var titleStr : String! = ""
    public var webName: String = ""
    public var showTitle : String!
    private var progressView : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProgressView()
        initWebView()
        loadWebView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLoginSuccess), name: NSNotification.Name(rawValue: LoginSuccess), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TongJi.start(webName)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        TongJi.end(webName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(2)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    @objc private func didLoginSuccess() {
        DispatchQueue.main.async {
            self.webView.reload()
        }
    }
    
    private func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webConfiguration.mediaPlaybackRequiresUserAction = false;//把手动播放设置NO ios(8.0, 9.0)
        webConfiguration.allowsInlineMediaPlayback = true;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        webConfiguration.mediaPlaybackAllowsAirPlay = true;
        
        
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        self.view.addSubview(webView)
        
    }
    
    public func loadWebView() {
        guard urlStr != "", urlStr != nil else { return }
        guard let urlStr = urlStr.removingPercentEncoding else { fatalError("-------  url 解码错误  -------") }
        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    private func initProgressView() {
        progressView = UIProgressView()
        progressView.progressTintColor = ColorEA5504
        self.view.addSubview(progressView)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        if showTitle == nil {
            webView.evaluateJavaScript("getCxmTitle()") { (data, error) in
                if let title = data as? String {
                    self.navigationItem.title = title
                }else {
                    self.navigationItem.title = webView.title
                }
            }
        }else {
            self.navigationItem.title = self.showTitle
        }
        
        let model = JSDataModel()
        let jsData = model.toJSONString()
        
        let urlStr = "\(webView.url!)"
        
        guard let urlModel = parseUrl(urlStr: urlStr) else { return }
        
        // usInfo == "1" 进入此页面发现无token时 弹出登录页
        if urlStr.contains("cxmxc=scm") && urlModel.usInfo == "1" {
            guard model.token != "" else {
                self.pushLoginVC(from: self)
                return
            }
            webView.evaluateJavaScript("actionMessage('\(jsData!)')") { (data, error) in
                
            }
            
        }
        // usInfo == "2" 进入此页面发现无token时 不弹出登录页
        else if urlStr.contains("cxmxc=scm") && urlModel.usInfo == "2" {
            guard model.token != "" else {
                
                return
            }
            webView.evaluateJavaScript("actionMessage('\(jsData!)')") { (data, error) in
                
            }
        }
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        decisionHandler(.allow)
//    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            if url?.description.lowercased().range(of: "http://") != nil || url?.description.lowercased().range(of: "https://") != nil || url?.description.lowercased().range(of: "mailto:") != nil  {
                webView.load(URLRequest(url: url!))
            }
        }
        return nil
    }
    //MARK: - 监听，加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        
        progressView.isHidden = webView.estimatedProgress == 1
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        
    }
    
    deinit {
        if self.webView != nil {
            self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
