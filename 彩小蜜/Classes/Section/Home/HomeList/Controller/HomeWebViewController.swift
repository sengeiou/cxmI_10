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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
