//
//  ShareViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ShareViewController: BasePopViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.popStyle = .fromBottom
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    private func initSubview() {
        self.viewHeight = 200 * defaultScale
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
