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
    
    public var titleStr : String! = ""
    
    private var progressView : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr
        initProgressView()
        initWebView()
        loadWebView()
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
        
        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        
        webView.load(request)
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
