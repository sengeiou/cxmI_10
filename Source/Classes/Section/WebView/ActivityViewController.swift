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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - 点击事件
    @objc private func shareButClicked(_ sender: UIButton) {
        //        guard self.detailModel != nil else { return }
        var content = ShareContentModel()
        content.title = "cece"
        content.description = "self.detailModel.summary"
    
        content.urlStr = "xxxxx"
        content.sharePic = UIImage(named:"fenxiangtubiao")
        
        share(content, from: self)
        
    }
    
    // MARK: - webView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let url = webView.url else { return}
        let urlStr = "\(url)" + "cxmxc=scmcmshare=1"
        guard urlStr.contains("cxmxc=scm") else { return }
        guard urlStr.contains("cmshare=1") else { return }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBut)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
