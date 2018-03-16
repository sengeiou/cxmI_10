//
//  HomeHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import FSPagerView

class HomeHeaderView: UIView {

    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        
        initSubview()
    }
    
    private func initSubview() {
        
    }
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        //viewPager.frame = frame1
        //viewPager.dataSource = self
        //viewPager.delegate = self
        //viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: cellId)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 1.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)
        
        return viewPager
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
