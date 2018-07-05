//
//  FootballMatchPagerView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballMatchPagerViewDelegate {
    func didSelected(_ teamInfoStyle : TeamInfoStyle) -> Void
}

class FootballMatchPagerView: UIView {

    // MARK: - 属性 public
    public var delegate : FootballMatchPagerViewDelegate!
    // MARK: - 属性 private
    private var analysisBut: UIButton!
    private var oddsBut: UIButton!
    
    private var vLine : UIView!
    private var vlineTwo: UIView!
    private var vlineThree: UIView!
    
    private var matchDetailBut: UIButton!
    private var lineupBut: UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        changeButtonState(sender: matchDetailBut, isSelected: true)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    private func initSubview() {
        vLine = UIView()
        vLine.backgroundColor = ColorEAEAEA
        
        vlineTwo = UIView()
        vlineTwo.backgroundColor = ColorEAEAEA
        
        vlineThree = UIView()
        vlineThree.backgroundColor = ColorEAEAEA
        
        analysisBut = getButton("分析")
        analysisBut.addTarget(self, action: #selector(analysisButClicked(_:)), for: .touchUpInside)
        
        oddsBut = getButton("赔率")
        oddsBut.addTarget(self, action: #selector(oddsButClicked(_:)), for: .touchUpInside)
        
        matchDetailBut = getButton("赛况")
        matchDetailBut.addTarget(self, action: #selector(matchDetailClick(_:)), for: .touchUpInside)
        
        lineupBut = getButton("阵容")
        lineupBut.addTarget(self, action: #selector(lineupClick(_:)), for: .touchUpInside)
        
        self.addSubview(vLine)
        self.addSubview(vlineTwo)
        self.addSubview(vlineThree)
        self.addSubview(analysisBut)
        self.addSubview(oddsBut)
        self.addSubview(matchDetailBut)
        self.addSubview(lineupBut)
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn {
            vLine.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(1)
            }
            vlineTwo.snp.makeConstraints { (make) in
                make.top.bottom.width.equalTo(vLine)
                make.left.equalTo(matchDetailBut.snp.right)
            }
            vlineThree.snp.makeConstraints { (make) in
                make.top.bottom.width.equalTo(vLine)
                make.left.equalTo(oddsBut.snp.right)
            }
            analysisBut.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(matchDetailBut.snp.right).offset(1)
                make.right.equalTo(vLine.snp.left)
                make.width.equalTo(matchDetailBut)
            }
            oddsBut.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(vLine.snp.right)
                make.right.equalTo(lineupBut.snp.left).offset(-1)
                make.width.equalTo(matchDetailBut)
            }
            matchDetailBut.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(analysisBut)
                make.left.equalTo(0)
            }
            lineupBut.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(analysisBut)
                make.right.equalTo(0)
                make.width.equalTo(matchDetailBut)
            }
        }else {
            analysisBut.snp.makeConstraints { (make) in
                make.top.left.bottom.equalTo(0)
                make.right.equalTo(0)
            }
        }
    }
    
    private func getButton(_ title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        //but.setTitleColor(ColorEA5504, for: .selected)
        
        but.titleLabel?.font = Font16
        return but
    }
    
    @objc private func analysisButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButtonState(sender: sender, isSelected: true)
        changeButtonState(sender: matchDetailBut, isSelected: false)
        changeButtonState(sender: oddsBut, isSelected: false)
        changeButtonState(sender: lineupBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didSelected(.analysis)
    }
    @objc private func oddsButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButtonState(sender: sender, isSelected: true)
        changeButtonState(sender: analysisBut, isSelected: false)
        changeButtonState(sender: matchDetailBut, isSelected: false)
        changeButtonState(sender: lineupBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didSelected(.odds)
    }
    @objc private func matchDetailClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButtonState(sender: sender, isSelected: true)
        changeButtonState(sender: analysisBut, isSelected: false)
        changeButtonState(sender: oddsBut, isSelected: false)
        changeButtonState(sender: lineupBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didSelected(.matchDetail)
    }
    @objc private func lineupClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButtonState(sender: sender, isSelected: true)
        changeButtonState(sender: analysisBut, isSelected: false)
        changeButtonState(sender: oddsBut, isSelected: false)
        changeButtonState(sender: lineupBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didSelected(.lineup)
    }
    
    
    private func changeButtonState(sender: UIButton, isSelected: Bool) {
        if isSelected {
            sender.setTitleColor(ColorEA5504, for: .normal)
        }else {
            sender.setTitleColor(Color505050, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
