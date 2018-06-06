//
//  FootballMatchPagerView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballMatchPagerViewDelegate {
    func didTipAnalysisButton() -> Void
    func didTipOddsButton() -> Void
}

class FootballMatchPagerView: UIView {

    // MARK: - 属性 public
    public var delegate : FootballMatchPagerViewDelegate!
    // MARK: - 属性 private
    private var analysisBut: UIButton!
    private var oddsBut: UIButton!
    private var vLine : UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        changeButtonState(sender: analysisBut, isSelected: true)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    private func initSubview() {
        vLine = UIView()
        vLine.backgroundColor = ColorEAEAEA
        
        analysisBut = getButton("分析")
        analysisBut.addTarget(self, action: #selector(analysisButClicked(_:)), for: .touchUpInside)
        
        oddsBut = getButton("赔率")
        oddsBut.addTarget(self, action: #selector(oddsButClicked(_:)), for: .touchUpInside)
        
        self.addSubview(vLine)
        self.addSubview(analysisBut)
        self.addSubview(oddsBut)
        
        
        
        
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn {
            vLine.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(1)
            }
            analysisBut.snp.makeConstraints { (make) in
                make.top.left.bottom.equalTo(0)
                make.right.equalTo(vLine.snp.left)
            }
            oddsBut.snp.makeConstraints { (make) in
                make.top.bottom.right.equalTo(0)
                make.left.equalTo(vLine.snp.right)
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
        changeButtonState(sender: oddsBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didTipAnalysisButton()
    }
    @objc private func oddsButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButtonState(sender: sender, isSelected: true)
        changeButtonState(sender: analysisBut, isSelected: false)
        guard delegate != nil else { return }
        delegate.didTipOddsButton()
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
