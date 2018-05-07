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

    public var winningList : [WinningMsgModel]! {
        didSet{
            guard winningList != nil else { return }
            self.viewPager.reloadData()
        }
    }
    
    private var bgView: UIView!
    private var icon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(leftSpacing)
            make.height.width.equalTo(20)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(icon.snp.right).offset(5)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        viewPager.snp.makeConstraints { (make) in
            make.top.equalTo(1)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        bgView = UIView()
        bgView.backgroundColor = ColorF4F4F4
        
        icon = UIImageView()
        icon.image = UIImage(named: "not")
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(bgView)
        bgView.addSubview(viewPager)
    }
    
    
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: ScrollCellIdentifier)

        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 2.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 10
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.coverFlow)
        viewPager.scrollDirection = .vertical
        viewPager.backgroundView?.backgroundColor = ColorFFFFFF
        
        return viewPager
    }()
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard winningList != nil , winningList.isEmpty == false else { return 0 }
        return winningList.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ScrollCellIdentifier, at: index)
        
        let winning = winningList[index]
        
        cell.textLabel?.text = winning.winningMsg
        cell.textLabel?.font = Font14
        cell.textLabel?.textColor = ColorA0A0A0
        cell.textLabel?.superview?.backgroundColor = ColorFFFFFF
        cell.contentView.backgroundColor = ColorFFFFFF
        cell.contentView.layer.shadowColor = ColorFFFFFF.cgColor
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
