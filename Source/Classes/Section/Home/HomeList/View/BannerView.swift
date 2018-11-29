//
//  HomeHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import FSPagerView

fileprivate let headerCellIdentifier = "headerCellIdentifier"

protocol HomeHeaderViewDelegate {
    func didTipBanner(banner: BannerModel) -> Void
}

class BannerView: UIView, FSPagerViewDataSource, FSPagerViewDelegate {

    public var bannerList : [BannerModel]! {
        didSet{
            guard bannerList != nil else { return }
            self.viewPager.reloadData()
            pageControl.numberOfPages = bannerList.count
        }
    }
    
    public var delegate : HomeHeaderViewDelegate!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: bannerHeight))
        print(bannerHeight)
        initSubview()
    }
    
    private func initSubview() {
        self.addSubview(viewPager)
        viewPager.addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewPager.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewPager)
            make.bottom.equalTo(viewPager).offset(-5)
            make.height.equalTo(20)
        }
    }
    
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        //viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.linear)
        
        viewPager.removesInfiniteLoopForSingleItem = true
        return viewPager
    }()
    
    lazy var pageControl:FSPageControl = {
        let pageControl = FSPageControl()
        
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard bannerList != nil else { return 0 }
        return bannerList.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, at: index)
        
        let banner = bannerList[index]
        
        if let url = URL(string: banner.bannerImage) {
            cell.imageView?.kf.setImage(with: url)
        }
        
        return cell
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard bannerList != nil else { return }
        guard delegate != nil else { return }
        
        delegate.didTipBanner(banner: bannerList[index])
    }
    
//    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        self.pageControl.currentPage = index
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
