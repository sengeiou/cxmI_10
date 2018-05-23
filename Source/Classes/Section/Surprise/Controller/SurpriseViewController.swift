//
//  SurpriseViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//  v1.0.4 版本添加发现功能


import UIKit
import WebKit

class SurpriseViewController: BaseWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
        hideBackBut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
//    override func loadWebView() {
//        guard urlStr != "", urlStr != nil else { return }
//        guard let urlStr = urlStr.removingPercentEncoding else { fatalError("-------  url 解码错误  -------") }
//        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
//        let request = URLRequest(url: url)
//        
//        webView.load(request)
//    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
