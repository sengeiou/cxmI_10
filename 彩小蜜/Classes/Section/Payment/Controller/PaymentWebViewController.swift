//
//  PaymentWebViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PaymentWebViewController: BaseWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadWebView() {
        let urlStr = "weixin://wxpay/bizpayurl?pr=cMsWQDB"
        guard let url = URL(string: urlStr) else { fatalError("-------  url 错误  -------")}
        let request = URLRequest(url: url)
        
        webView.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
