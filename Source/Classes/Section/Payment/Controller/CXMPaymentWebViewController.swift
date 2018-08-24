//
//  PaymentWebViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMPaymentWebViewController: BaseWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func loadWebView() {
        let urlStr = "weixin://wxpay/bizpayurl?pr=cMsWQDB"
        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        
        webView.load(request)
    }


}
