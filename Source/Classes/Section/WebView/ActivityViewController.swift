//
//  ActivityViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

class ActivityViewController: BaseWebViewController, ShareProtocol {

    lazy private var shareBut: UIButton = {
        let shareBut = UIButton(type: .custom)
        shareBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        shareBut.setTitle("分享", for: .normal)
        shareBut.setTitleColor(Color9F9F9F, for: .normal)
        shareBut.addTarget(self, action: #selector(shareButClicked(_:)), for: .touchUpInside)
        return shareBut
    }()
    
    private var shareContent : ShareContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - 点击事件
    @objc private func shareButClicked(_ sender: UIButton) {
        guard self.shareContent != nil else { return }
        share(self.shareContent, from: self)
    }
    
    // MARK: - webView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
        guard let url = webView.url else { return}
        
        let urlStr = "\(url)"

        guard let model = parseUrl(urlStr: urlStr) else { return }
        guard urlStr.contains("cxmxc=scm") && model.cmshare == "1" else {
            self.navigationItem.rightBarButtonItem = nil
            return }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBut)
        
    }

    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        
        webView.evaluateJavaScript("getCxmShare()") { (data, error) in
            guard error == nil else { return }
            guard let dic = data as? [String: String] else { return }
            
            self.shareContent = ShareContentModel()
            self.shareContent.title = dic["title"]
            self.shareContent.description = dic["description"]
            self.shareContent.urlStr = dic["url"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
