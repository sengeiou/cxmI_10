//
//  LeagueDetailScorePagerHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueDetailScorePagerHeaderDelegate {
    func didSelectScorePagerItem(style : LeagueScoreStyle) -> Void
}

class LeagueDetailScorePagerHeader: UITableViewHeaderFooterView {

    static let identifier : String = "LeagueDetailScorePagerHeader"
    
    public var delegate : LeagueDetailScorePagerHeaderDelegate!
    
    private var totalScoreButton : UIButton!
    private var homeScoreButton : UIButton!
    private var visiScoreButton : UIButton!
    
    private var proline : UIView!
    
    private var bgView : UIView!
    
    private var lineOne : UIView!
    private var lineTwo : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorFFFFFF
        initSubview()
    }
    
    private func initSubview() {
        totalScoreButton = getButton(name: "总积分")
        homeScoreButton = getButton(name: "主场积分")
        visiScoreButton = getButton(name: "客场积分")
        
        totalScoreButton.tag = 100
        homeScoreButton.tag = 200
        visiScoreButton.tag = 300
        
        proline = UIView()
        proline.backgroundColor = ColorEA5504
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = ColorF4F4F4.cgColor
        
        lineOne = UIView()
        lineOne.backgroundColor = ColorF4F4F4
        lineTwo = UIView()
        lineTwo.backgroundColor = ColorF4F4F4
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(totalScoreButton)
        bgView.addSubview(homeScoreButton)
        bgView.addSubview(visiScoreButton)
        //self.contentView.addSubview(proline)
        bgView.addSubview(lineOne)
        bgView.addSubview(lineTwo)
        
        totalScoreButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(homeScoreButton)
        }
        lineOne.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(1)
            make.left.equalTo(totalScoreButton.snp.right)
        }
        homeScoreButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(totalScoreButton)
            make.height.equalTo(35)
            make.left.equalTo(totalScoreButton.snp.right).offset(1)
        }
        lineTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineOne)
            make.left.equalTo(homeScoreButton.snp.right)
        }
        visiScoreButton.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(homeScoreButton)
            make.left.equalTo(homeScoreButton.snp.right).offset(1)
            make.right.equalTo(0)
        }

//        proline.snp.makeConstraints { (make) in
//            make.bottom.equalTo(bgView.snp.top)
//            make.width.equalTo(80)
//            make.height.equalTo(1)
//            make.centerX.equalTo(totalScoreButton.snp.centerX)
//        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(30)
            make.top.equalTo(0)
        }
    }
    
    private func getButton (name : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(name, for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.setTitleColor(ColorFFFFFF, for: .selected)
        
        but.titleLabel?.font = Font12
        but.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return but
    }
    
    @objc private func buttonClick(_ sender : UIButton) {
        UIView.animate(withDuration: 0.4) {
            //self.changeProView(sender)
        }
        
        changeButtonColor(sender)
        
        guard delegate != nil else { return }
        
        switch sender.tag {
        case 100:
            delegate.didSelectScorePagerItem(style: .总积分)
        case 200:
            delegate.didSelectScorePagerItem(style: .主场积分)
        case 300:
            delegate.didSelectScorePagerItem(style: .客场积分)
        default: break
            
        }
    }
    
    private func changeProView(_ sender : UIButton) {
        self.proline.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(1)
            make.centerX.equalTo(sender.snp.centerX)
        }
        self.contentView.layoutIfNeeded()
    }
    
    private func changeButtonColor(_ sender : UIButton) {
        totalScoreButton.isSelected = false
        homeScoreButton.isSelected = false
        visiScoreButton.isSelected = false
        
        totalScoreButton.backgroundColor = ColorFFFFFF
        homeScoreButton.backgroundColor = ColorFFFFFF
        visiScoreButton.backgroundColor = ColorFFFFFF
        
        sender.isSelected = true
        sender.backgroundColor = ColorEA5504
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LeagueDetailScorePagerHeader {
    public func configure(with style : LeagueScoreStyle) {
        switch style {
        case .总积分:
            changeButtonColor(self.totalScoreButton)
            //changeProView(self.totalScoreButton)
        case .主场积分:
            changeButtonColor(self.homeScoreButton)
            //changeProView(self.homeScoreButton)
        case .客场积分:
            changeButtonColor(self.visiScoreButton)
            //changeProView(self.visiScoreButton)
        }
    }
}
