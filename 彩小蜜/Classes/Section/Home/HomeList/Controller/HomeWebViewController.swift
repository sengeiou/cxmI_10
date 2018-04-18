//
//  HomeWebViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeWebViewController: BaseWebViewController {

    public var titleStr : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr
        
    }

    override func loadWebView() {
        let jsonPath = Bundle.main.path(forResource: "rich", ofType: "txt")
        let data = NSData.init(contentsOfFile: jsonPath!)
       
        let xxx = String.init(data: data as! Data, encoding: String.Encoding.utf8)
        
       
        
        webView.loadHTMLString(xxx!, baseURL: nil)
       // webView.load(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
