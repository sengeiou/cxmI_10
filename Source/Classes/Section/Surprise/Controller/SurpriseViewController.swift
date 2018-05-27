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

    // MARK: - 属性 public
    public var showDelete : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
        
        hideBackBut()
        self.shouldReload = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.showDelete {
            self.isHidenBar = true
        }else {
            self.isHidenBar = false
        }
    }
    
    // MARK: - webView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let urlStr = "\(url)"
            if urlStr.contains("type=1") {
                
                let surprise = ActivityViewController()
                surprise.shouldReload = false
                surprise.urlStr = urlStr
                pushViewController(vc: surprise)
                
                decisionHandler(.cancel)
            }else {
                decisionHandler(.allow)
            }
        }
    }
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
