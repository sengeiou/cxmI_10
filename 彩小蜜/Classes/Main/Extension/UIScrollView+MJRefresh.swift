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
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header?.setTitle("下拉可以刷新", for: .refreshing)
        
        self.mj_header = header
    }
    
    func footerRefresh(block: @escaping () -> ()) -> (){
        
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            block()
        })
    }
    
    func endrefresh(){
        guard self.mj_header != nil, self.mj_footer != nil  else { return }
        
        self.mj_footer.endRefreshing()
        self.mj_header.endRefreshing()
    }
    func noMoreData() {
        self.mj_footer.endRefreshingWithNoMoreData()
    }
}


