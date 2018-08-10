//
//  CXMMDLTBlueTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMDLTBlueTrendVC: BaseViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer = false
       
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "篮球走势"
    }

}
