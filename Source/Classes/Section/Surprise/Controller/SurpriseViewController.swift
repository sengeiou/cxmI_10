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
    
    // MARK: - 懒加载
    lazy private var deleteBut : UIButton = {
        let but = UIButton(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        but.setImage(UIImage(named: "Remove"), for: .normal)
        but.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        but.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        return but
    }()
    
    lazy private var backBut: UIButton = {
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        return leftBut
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
        
        
        if self.showDelete {
            let back = UIBarButtonItem(customView: backBut)
            let delete = UIBarButtonItem(customView: deleteBut)
            self.navigationItem.leftBarButtonItems = [back, delete]
        }else {
            hideBackBut()
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
    
    // MARK: - 点击事件
    
    @objc private func deleteClicked(_ sender: UIButton) {
        self.popToRootViewController()
    }
    
    // MARK: - webView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard self.showDelete else {
            decisionHandler(.allow)
            return}
        
        if let url = webView.url {
            let urlStr = "\(url)"
            if urlStr.contains("type=1") {
                let surprise = SurpriseViewController()
                surprise.showDelete = true
                surprise.urlStr = urlStr
                pushViewController(vc: surprise)
                
                decisionHandler(.cancel)
            }else {
                decisionHandler(.allow)
            }
        }
        
        //decisionHandler(.allow)
    }
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
