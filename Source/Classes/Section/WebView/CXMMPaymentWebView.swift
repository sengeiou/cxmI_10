//
//  CXMMPaymentWebView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMPaymentWebView: BaseViewController {

    
    public var urlStr : String!
    
    private var webView : UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView()
        
        
        
        
        self.view.addSubview(webView)
        
        let url = URL(string: urlStr)
        
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)
        
        
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
