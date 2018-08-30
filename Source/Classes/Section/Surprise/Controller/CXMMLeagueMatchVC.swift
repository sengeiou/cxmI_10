//
//  CXMMLeagueMatchVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum LeagueMatchStyle : String {
    case 热门 = "热门"
    case 国际 = "国际"
    case 欧洲 = "欧洲"
    case 亚洲 = "亚洲"
    case 美洲 = "美洲"
    case 非洲 = "非洲"
}

class CXMMLeagueMatchVC: BaseViewController, IndicatorInfoProvider {
    
    public var style : LeagueMatchStyle = .热门

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: style.rawValue)
    }

}
