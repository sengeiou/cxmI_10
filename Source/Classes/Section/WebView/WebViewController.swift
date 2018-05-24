//
//  WebViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: BaseWebViewController {

    lazy private var shareBut: UIButton = {
        let share = UIButton(type: .custom)
        //share.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        return share
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
