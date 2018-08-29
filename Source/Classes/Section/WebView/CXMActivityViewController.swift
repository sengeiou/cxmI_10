//
//  ActivityViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

class CXMActivityViewController: BaseWebViewController {

    public var backType : BackType! = .notRoot
    
    override func didLogin(isLogin: Bool) {
        if isLogin {
            self.webView.reload()
        }
//       else {
//            self.popViewController()
//        }
    }
    
    lazy private var shareBut: UIButton = {
        let shareBut = UIButton(type: .custom)
        shareBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        shareBut.setTitle("分享", for: .normal)
        shareBut.setTitleColor(Color9F9F9F, for: .normal)
        shareBut.addTarget(self, action: #selector(shareButClicked(_:)), for: .touchUpInside)
        return shareBut
    }()
    
    // MARK: - 懒加载
    lazy private var deleteBut : UIButton = {
        let but = UIButton(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        but.setImage(UIImage(named: "Remove"), for: .normal)
        but.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 39)
        but.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        return but
    }()
    
    private var shareContent : ShareContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dele = UIBarButtonItem(customView: deleteBut)
        self.navigationItem.leftBarButtonItems?.append(dele)
        
        deleteBut.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBut)
        
        shareBut.isHidden = true
    }
    
    // MARK: - 点击事件
    @objc private func shareButClicked(_ sender: UIButton) {
        guard self.shareContent != nil else { return }
        share(self.shareContent, from: self)
    }
    
    @objc private func deleteClicked(_ sender: UIButton) {
        //self.popToRootViewController()
        guard self.backType == .notRoot else {
            self.popToRootViewController()
            return
        }
        self.popViewController()
    }
    // MARK: - webView delegate
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else { return}
        
        let urlStr = "\(url)"

        let type = matcherHttp(urlStr: urlStr)
        
        switch type.0 {
        case .登录:
            //pushLoginVC(from: self)
            pushLoginVC(from: self, fromWeb: true)
            decisionHandler(.cancel)
            return
        case .注册:
            let register = CXMRegisterViewController()
            pushViewController(vc: register)
            decisionHandler(.cancel)
            return
        case .竞彩足球:
            break
        default: break
        }
   
        
        guard let model = parseUrl(urlStr: urlStr) else {
            decisionHandler(.allow)
            return }
        guard urlStr.contains("cxmxc=scm") else {
            decisionHandler(.allow)
            return }
        
        // 分享
        if  model.cmshare == "1" {
            shareBut.isHidden = false
        }else {
            shareBut.isHidden = true
        }
        
        // 世界杯
        if model.extparam != nil {
            webView.evaluateJavaScript("\(model.extparam!)()") { (data, error) in
                if model.type == "10" {
                    if self.getUserData() == nil {
                        //self.pushLoginVC(from: self)
                        self.pushLoginVC(from: self, fromWeb: true)
                        decisionHandler(.cancel)
                    }else {
                        if let dic = data as? [String: String] {
                            let payment = CXMPaymentViewController()
                            
                            self.pushViewController(vc: payment)
                
                            decisionHandler(.cancel)
                        }else {
                            decisionHandler(.allow)
                        }
                    }
                    
                }else if model.type == "11" {
                    if self.getUserData() == nil {
                        //self.pushLoginVC(from: self)
                        self.pushLoginVC(from: self, fromWeb: true)
                        decisionHandler(.cancel)
                    }else {
                        if let money = data as? [String: String] {
                            if money.keys.contains("price") {
                                let recharge = CXMRechargeViewController()
                                recharge.rechargeAmounts = money["price"]
                                self.pushViewController(vc: recharge)
                                decisionHandler(.cancel)
                            }else {
                                decisionHandler(.allow)
                            }
                        }else {
                            decisionHandler(.allow)
                        }
                    }
                }
            }
        }else {
            decisionHandler(.allow)
        }
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
            self.shareContent.sharePicUrl = dic["thumbUrl"]
        }
    }
    
    override func back(_ sender: UIButton) {
        
        guard self.backType == .notRoot else {
            self.popToRootViewController()
            return
        }
        
        
        if webView.canGoBack {
            webView.goBack()
        }else {
            self.popViewController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
extension CXMActivityViewController {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        super.userContentController(userContentController, didReceive: message)
        
        guard message.name == "appNative" else { return }
        
        guard let dic = message.body as? [String : String] else { return }
        
        let methodName = dic["methodName"]
        
        switch methodName {
        case "hideDelete":
            hideDeleteButton()
        case "showDelete":
            showDelete()
        default : break
        }
    }
    
    private func hideDeleteButton() {
        self.deleteBut.isHidden = true
    }
    private func showDelete() {
        self.deleteBut.isHidden = false
    }
}
