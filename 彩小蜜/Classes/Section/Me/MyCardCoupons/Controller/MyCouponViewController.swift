//
//  MyCouponViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyCouponViewController: ButtonBarPagerTabStripViewController {
   
   
    override func viewDidLoad() {
        
       
        
        
        
        
        super.viewDidLoad()
        self.title = "彩小秘 · 账户明细"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [CouponUsedVC(), CouponOverdueVC()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
