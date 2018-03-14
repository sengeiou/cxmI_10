//
//  UIScrollView+MJRefresh.swift
//  彩小蜜
//
//  Created by HX on 2018/3/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import MJRefresh


extension UIScrollView
{
    func headerRefresh(block: @escaping () -> ()) -> (){
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            block()
        })
    }
    
    func footerRefresh(block: @escaping () -> ()) -> (){
        
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            block()
        })
    }
    
    func endrefresh(){
        self.mj_footer.endRefreshing()
        self.mj_header.endRefreshing()
    }
}
