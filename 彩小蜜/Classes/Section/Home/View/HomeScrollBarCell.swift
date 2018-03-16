//
//  HomeScrollBarCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import FSPagerView

fileprivate let ScrollCellIdentifier = "ScrollCellIdentifier"

class HomeScrollBarCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewPager.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(80)
            make.right.equalTo(self.contentView).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    private func initSubview() {
        self.contentView.addSubview(viewPager)
    }
    
    
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: ScrollCellIdentifier)

        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 2.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 0.8
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.cubic)
        viewPager.scrollDirection = .vertical
        
        return viewPager
    }()
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 5
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ScrollCellIdentifier, at: index)
        
        
        cell.textLabel?.text = "sssssfdsfsdfsfsdfsdfsfsdfsd"
        cell.textLabel?.textColor = ColorA0A0A0
        cell.textLabel?.superview?.backgroundColor = ColorFFFFFF
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
