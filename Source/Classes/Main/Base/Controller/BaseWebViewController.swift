//
//  BaseWebViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, ShareProtocol {

    public var urlStr : String!
    
    public var webView: WKWebView!
    
    public var shouldReload = true
    //public var titleStr : String! = ""
    public var webName: String = ""
    public var showTitle : String!
    private var progressView : UIProgressView!
    private var reloadData = false
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
        
        switch reloadData {
        case true:
            webView.reload()
        default:
            break
        }
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
        
        let userContent = WKUserContentController()
        
        userContent.add(self, name: "appNative")
        
        
        
        webConfiguration.userContentController = userContent
        
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let resu = result as? String {
                if #available(iOS 9.0, *) {
                    self.webView.customUserAgent = "app/ios&" + resu
                } else {
                }
            }
        }
        
        self.view.addSubview(webView)
        
    }
    
    public func loadWebView() {
        guard urlStr != "", urlStr != nil else { return }
        guard let urlStr = urlStr.removingPercentEncoding else { fatalError("-------  url 解码错误  -------") }
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
//        if showTitle == nil {
//            webView.evaluateJavaScript("getCxmTitle()") { (data, error) in
//                if let title = data as? String {
//                    self.navigationItem.title = title
//                }else {
//                    self.navigationItem.title = webView.title
//                }
//            }
//        }else {
//            self.navigationItem.title = self.showTitle
//        }
        
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
            guard model.token != "" else { return }
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
            self.webView.configuration.userContentController.removeAllUserScripts()
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseWebViewController {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "appNative" else { return }
       
        guard let dic = message.body as? [String : String] else { return }
        
        let methodName = dic["methodName"]
        
        switch methodName {
        case "getToken":         // 获取用户Token
            evaluateToken()
        case "pushPayment":      // 结算
            pushPaymentVC(dic: dic)
        case "pushRechange":     //充值
            pushRechange(dic: dic)
        case "showTitle":        // 显示标题
            showJSTitle(dic: dic)
        case "goShare":          // 分享
            share(dic: dic)
        case "pushUrl":          // 跳转路由
            pushRouter(dic: dic)
        case "closeWeb":         // 关闭H5 -返回上一页
            goBack()
        case "login":            // 登录
            //pushLoginVC(from: self)////
            pushLoginVC(from: self, fromWeb: true)
        case "register":         // 注册
            pushRegister()
        case "channel":          // 渠道号
            getChannel()
        case "hideTitle":        // 隐藏导航栏
            hideNavigationTitle()
        case "reloadData":       // 刷新页面
            shouldReloadData()
        case "backReloadData":   // 返回刷新
            backReloadData(dic: dic)
        default:
            break
        }
    }
    
    private func evaluateToken() {
        guard webView != nil else { return }
        let model = JSDataModel()
        let jsData = model.toJSONString()
        webView.evaluateJavaScript("actionMessage('\(jsData!)')") { (data, error) in
            
        }
    }
    private func pushPaymentVC(dic : [String: String]) {
        guard let payToken = dic["payToken"] else { return }
        let vc = CXMPaymentViewController()
        vc.lottoToken = payToken
        
        if let url = dic["pushUrl"] {
            vc.pushWebUrl = url
        }
        
        pushViewController(vc: vc)
    }
    private func pushRechange(dic : [String: String]) {
        let vc = CXMRechargeViewController()
        
        if let price = dic["price"] {
            vc.rechargeAmounts = price
        }
        
        if let disStr = dic["isDisabled"] {
            
            vc.disableInput = disStr
          
        }
        
        pushViewController(vc: vc)
    }
    private func showJSTitle(dic : [String: String]) {
        showNavigationBar()
        self.webView.snp.remakeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.bottom.equalTo(0)
        }
        guard let title = dic["title"] else { return }
        self.navigationItem.title = title
    }
    private func share(dic : [String: String]) {
        guard let urlStr = dic["url"] else { return }
        
        var shareContent = ShareContentModel()
        shareContent.title = dic["title"]
        shareContent.description = dic["description"]
        shareContent.urlStr = urlStr
        shareContent.sharePicUrl = dic["thumbUrl"]
        
        share(shareContent, from: self)
        
    }
    private func pushRouter(dic : [String: String]) {
        guard let urlStr = dic["url"] else { return }
        pushRouterVC(urlStr: urlStr, from: self)
    }
    
    private func pushRegister() {
        let register = CXMRegisterViewController()
        pushViewController(vc: register)
    }
    
    private func goBack() {
        self.popViewController()
    }
    private func getChannel() {
        webView.evaluateJavaScript("getChannel('\(Channel)')") { (data, error) in
            
        }
    }
    private func hideNavigationTitle() {
        hideNavigationBar()
        self.webView.snp.remakeConstraints { (make) in
            make.top.equalTo(SafeTopHeight)
            make.left.right.bottom.equalTo(0)
        }
    }
    private func shouldReloadData() {
        guard webView != nil else { return }
        webView.reload()
    }
    
    private func backReloadData(dic : [String: String]) {
        guard let back = dic["backReload"] else { return }
        
        switch back {
        case "0":
            self.reloadData = false
        case "1":
            self.reloadData = true
        default:
            break
        }
    }
}
