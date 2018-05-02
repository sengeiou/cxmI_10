//
//  HomeWebViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeWebViewController: BaseWebViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func loadWebView() {
        guard urlStr != nil else { return }
        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
