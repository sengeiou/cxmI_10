//
//  SurpriseViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//  v1.0.4 版本添加发现功能


import UIKit
import WebKit
import Reachability

class SurpriseViewController: BaseWebViewController {

    // MARK: - 属性 public
    public var showDelete : Bool = false
    private var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
    
        hideBackBut()
        self.shouldReload = false
        self.webView.scrollView.headerRefresh {
            self.isFirst = true 
            self.webView.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.showDelete {
            self.isHidenBar = true
        }else {
            self.isHidenBar = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("发现页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("发现页")
    }
    // MARK: - webView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return }
        
        let urlStr = "\(url)"
        
        if isFirst == false {
            pushRouterVC(urlStr: urlStr, from: self)
            decisionHandler(.cancel)
        }else {
            decisionHandler(.allow)
            self.isFirst = false
        }
    }
    
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
        self.webView.scrollView.endrefresh()
    }
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        self.webView.scrollView.endrefresh()
    }
    
    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFail: navigation, withError: error)
        self.webView.scrollView.endrefresh()
    }
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
