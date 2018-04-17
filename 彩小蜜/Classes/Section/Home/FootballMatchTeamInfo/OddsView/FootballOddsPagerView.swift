//
//  FootballOddsPagerView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum OddsPagerStyle {
    case 欧赔
    case 亚盘
    case 大小球
}

protocol FootballOddsPagerViewDelegate {
    func didTipEuropeOdds() -> Void
    func didTipAsianOdds() -> Void
    func didTipBigAndSmallBall() -> Void
}

class FootballOddsPagerView: UIView {

    
    // MARK: - 属性 public
    public var delegate : FootballOddsPagerViewDelegate!
    // MARK: - 属性 private
    private var europeOddsBut : UIButton!
    private var asianOddsBut: UIButton!
    private var bigSmallBut: UIButton!
    
    private var vlineOne : UIView!
    private var vlineTwo : UIView!
    private var bottomLine : UIView!
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        changeButState(sender: europeOddsBut, isSelected: true)
    }
    
    // MARK: - 点击事件
    @objc private func europeOddsClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButState(sender: sender, isSelected: true)
        changeButState(sender: asianOddsBut, isSelected: false)
        changeButState(sender: bigSmallBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didTipEuropeOdds()
    }
    @objc private func asianOddsClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButState(sender: sender, isSelected: true)
        changeButState(sender: bigSmallBut, isSelected: false)
        changeButState(sender: europeOddsBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didTipAsianOdds()
    }
    @objc private func bigSmallClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        changeButState(sender: sender, isSelected: true)
        changeButState(sender: asianOddsBut, isSelected: false)
        changeButState(sender: europeOddsBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didTipBigAndSmallBall()
    }
    
    private func changeButState(sender : UIButton, isSelected : Bool) {
        if isSelected {
            sender.setTitleColor(ColorFFFFFF, for: .normal)
            sender.backgroundColor = ColorEA5504
        }else {
            sender.setTitleColor(Color505050, for: .normal)
            sender.backgroundColor = ColorFFFFFF
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        europeOddsBut.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
            make.width.equalTo(asianOddsBut)
        }
        asianOddsBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(europeOddsBut)
            make.left.equalTo(europeOddsBut.snp.right).offset(1)
            make.width.equalTo(bigSmallBut)
        }
        bigSmallBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(europeOddsBut)
            make.left.equalTo(asianOddsBut.snp.right).offset(1)
            make.right.equalTo(0)
        }
        vlineOne.snp.makeConstraints { (make) in
            make.left.equalTo(europeOddsBut.snp.right)
            make.width.equalTo(1)
            make.top.equalTo(5 * defaultScale)
            make.bottom.equalTo(-5 * defaultScale)
        }
        vlineTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(vlineOne)
            make.left.equalTo(asianOddsBut.snp.right)
        }
    }
    private func initSubview() {
        vlineOne = getLine()
        vlineTwo = getLine()
        bottomLine = getLine()
        
        europeOddsBut = getButton("欧赔")
        europeOddsBut.addTarget(self, action: #selector(europeOddsClicked(_:)), for: .touchUpInside)
        
        asianOddsBut = getButton("亚盘")
        asianOddsBut.addTarget(self, action: #selector(asianOddsClicked(_:)), for: .touchUpInside)
        
        bigSmallBut = getButton("大小球")
        bigSmallBut.addTarget(self, action: #selector(bigSmallClicked(_:)), for: .touchUpInside)
        
        self.addSubview(vlineOne)
        self.addSubview(vlineTwo)
        self.addSubview(europeOddsBut)
        self.addSubview(asianOddsBut)
        self.addSubview(bigSmallBut)
        self.addSubview(bottomLine)
    }
    private func getButton(_ title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.titleLabel?.font = Font14
        return but
    }
    private func getLine() -> UIView {
        let view = UIView()
        view.backgroundColor = ColorC8C8C8
        return view
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
