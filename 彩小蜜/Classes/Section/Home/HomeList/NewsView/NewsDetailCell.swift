//
//  NewsDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

protocol NewsDetailCellDelegate {
    func upDateCellHeight(height: CGFloat) -> Void
}

class NewsDetailCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {

    public var urlStr : String!
    
    public var webView: WKWebView!
    
    public var delegate: NewsDetailCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        initWebView()
        
        loadWebView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func initSubview() {
        
    }
    private func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webConfiguration.mediaPlaybackRequiresUserAction = false;//把手动播放设置NO ios(8.0, 9.0)
        webConfiguration.allowsInlineMediaPlayback = true;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        webConfiguration.mediaPlaybackAllowsAirPlay = true;
        
        
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.autoresizingMask = .flexibleHeight
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
    
        self.contentView.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }

    }
    
    public func loadWebView() {
        let jsonPath = Bundle.main.path(forResource: "rich", ofType: "txt")
        let data = NSData.init(contentsOfFile: jsonPath!)
        
        let xxx = String.init(data: data! as Data, encoding: String.Encoding.utf8)
        
        
        webView.loadHTMLString(xxx!, baseURL: nil)
    }

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        /// 获取html动态高度
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if error == nil {
                var newFrame = webView.frame
                newFrame.size.height = result as! CGFloat
                webView.frame = newFrame
                
                
                self.delegate.upDateCellHeight(height: result as! CGFloat)

                webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'", completionHandler: nil)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
