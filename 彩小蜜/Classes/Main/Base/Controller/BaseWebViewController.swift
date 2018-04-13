//
//  BaseWebViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {

    public var urlStr : String!
    
    public var webView: WKWebView!
    
    private var progressView : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProgressView()
        initWebView()
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
    
    private func initWebView() {
        
        guard let url = URL(string: "https://www.baidu.com") else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        self.view.addSubview(webView)
        
    }
    
    private func initProgressView() {
        progressView = UIProgressView()
        progressView.progressTintColor = ColorEA5504
        self.view.addSubview(progressView)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        
        progressView.isHidden = webView.estimatedProgress == 1
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
