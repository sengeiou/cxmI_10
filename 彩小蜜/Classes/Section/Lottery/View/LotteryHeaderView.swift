//
//  LotteryHeaderView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LotteryHeaderViewDelegate {
    func didTipDateFilter() -> Void
    func didTipMoreFilter() -> Void
    func didTipAllFilter() -> Void
}

class LotteryHeaderView: UIView {

    // MARK: - 属性 public
    public var dateModel : LotteryDateModel! {
        didSet{
            timeFilterBut.setTitle(dateModel.date, for: .normal)
        }
    }
    
    public var delegate : LotteryHeaderViewDelegate!
    // MARK: - 属性 private
    private var vLine : UIView!
    private var vLineTwo : UIView!
    private var timeFilterBut: UIButton!
    private var moreFilterBut: UIButton!
    private var finishFilterBut: UIButton!
    
    
    private var timeIcon : UIImageView!
    private var moreIcon : UIImageView!
    private var finishIcon : UIImageView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        vLine.snp.makeConstraints { (make) in
            make.left.equalTo(timeFilterBut.snp.right)
            make.top.bottom.equalTo(0)
            make.width.equalTo(0.5)
        }
        vLineTwo.snp.makeConstraints { (make) in
            make.left.equalTo(moreFilterBut.snp.right)
            make.top.bottom.equalTo(0)
            make.width.equalTo(0.5)
        }
        timeFilterBut.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
        }
        moreFilterBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(timeFilterBut.snp.right).offset(1)
            make.width.equalTo(timeFilterBut)
        }
        finishFilterBut.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(timeFilterBut)
            make.left.equalTo(moreFilterBut.snp.right).offset(1)
        }
        timeIcon.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.width.height.equalTo(10 * defaultScale)
        }
        moreIcon.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.width.height.equalTo(timeIcon)
        }
        finishIcon.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.width.height.equalTo(timeIcon)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        vLine = UIView()
        vLine.backgroundColor = ColorC8C8C8
        vLineTwo = UIView()
        vLineTwo.backgroundColor = ColorC8C8C8
        
        timeFilterBut = getButton("2018-3-25")
        timeFilterBut.addTarget(self, action: #selector(timeButClicked(_:)), for: .touchUpInside)
        
        moreFilterBut = getButton("更多条件")
        moreFilterBut.addTarget(self, action: #selector(moreButClicked(_:)), for: .touchUpInside)
        
        finishFilterBut = getButton("全部")
        finishFilterBut.addTarget(self, action: #selector(finishButClicked(_:)), for: .touchUpInside)
        
        timeIcon = UIImageView()
        timeIcon.image = UIImage(named: "Clickable")
        
        moreIcon = UIImageView()
        moreIcon.image = UIImage(named: "Clickable")
        
        finishIcon = UIImageView()
        finishIcon.image = UIImage(named: "Clickable")
        
        self.addSubview(vLine)
        self.addSubview(vLineTwo)
        self.addSubview(timeFilterBut)
        self.addSubview(moreFilterBut)
        self.addSubview(finishFilterBut)
        timeFilterBut.addSubview(timeIcon)
        moreFilterBut.addSubview(moreIcon)
        finishFilterBut.addSubview(finishIcon)
        
    }
    
    private func getButton(_ title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        but.setTitleColor(Color9F9F9F, for: .normal)
        but.titleLabel?.font = Font14
        return but
    }
    
    @objc private func timeButClicked(_ sender : UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipDateFilter()
    }
    @objc private func moreButClicked(_ sender : UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipMoreFilter()
    }
    @objc private func finishButClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipAllFilter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
