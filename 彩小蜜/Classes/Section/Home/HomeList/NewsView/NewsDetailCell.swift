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

    public var detailInfo : NewsDetailModel! {
        didSet{
            guard detailInfo != nil, detailInfo.content != nil else { return }
            self.loadWebView(htmlStr: detailInfo.content!)
            self.title.text = detailInfo.title
            self.detail.text = "\(detailInfo.extendCat!)  \(detailInfo.addTime!)"
        }
    }
    
    public var urlStr : String!
    
    public var webView: WKWebView!
    
    public var delegate: NewsDetailCellDelegate!
    
    private var title : UILabel!
    private var detail : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.equalTo(24 * defaultScale)
            make.left.equalTo(18 * defaultScale)
            make.right.equalTo(-18 * defaultScale)
            //make.height.equalTo(21 * defaultScale)
            //make.bottom.equalTo(detail.snp.top)
        }
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(15 * defaultScale)
            make.left.right.equalTo(title)
            make.height.equalTo(12 * defaultScale)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(detail.snp.bottom).offset(24 * defaultScale)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    private func initSubview() {
        title = getLabel()
        title.numberOfLines = 0
        
        detail = getLabel()
        detail.font = Font12
        detail.textColor = Color9F9F9F
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        
        initWebView()
    }
    private func getLabel() -> UILabel{
        let lab = UILabel()
        lab.font = Font21
        lab.textColor = Color505050
        lab.textAlignment = .left

        return lab
    }
    private func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        //webConfiguration.mediaPlaybackRequiresUserAction = false;//把手动播放设置NO ios(8.0, 9.0)
        webConfiguration.allowsInlineMediaPlayback = true;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        webConfiguration.mediaPlaybackAllowsAirPlay = true;
        
        
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
       // webView.autoresizingMask = .flexibleHeight
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
    
        self.contentView.addSubview(webView)
        
//        webView.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(0)
//            make.bottom.equalTo(0)
//        }

    }
    
    public func loadWebView(htmlStr : String) {
//        let jsonPath = Bundle.main.path(forResource: "rich", ofType: "txt")
//        let data = NSData.init(contentsOfFile: jsonPath!)
//
//        let xxx = String.init(data: data! as Data, encoding: String.Encoding.utf8)
        
        let html = """
                <html>
                <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width,initial-scale=1, maximum-scale=1, user-scalable=no">
                <style>
                img{max-width: 100%; width:auto; height:auto;}
                </style>
                </head>
                <body>
                \(htmlStr)
                </body>
                </html>
"""
        
        webView.loadHTMLString(html, baseURL: nil)
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        /// 获取html动态高度
        webView.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
            if error == nil {
                var newFrame = webView.frame
                newFrame.size.height = result as! CGFloat
                webView.frame = newFrame
                
                self.delegate.upDateCellHeight(height: result as! CGFloat + 150 * defaultScale)

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
