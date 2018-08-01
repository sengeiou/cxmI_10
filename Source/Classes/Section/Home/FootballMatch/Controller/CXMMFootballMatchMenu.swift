//
//  CXMMFootballMatchMenu.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol CXMMFootballMatchMenuDelegate {
    func didTipMenu(view : CXMMFootballMatchMenu, type : FootballMatchType) -> Void
}

class CXMMFootballMatchMenu: PopMenu {

    public var delegate : CXMMFootballMatchMenuDelegate!
    
    private var spfBut: UIButton!
    private var hunheBut: UIButton!
    private var rangSpfBut: UIButton!
    private var tatalBut: UIButton!
    private var banBut: UIButton!
    private var scoreBut: UIButton!
    private var twoBut: UIButton!
    
    
    override init() {
        super.init()
        initSubview()
    }
    
    private func initSubview() {
        self.viewHeight = CGFloat(130 + SafeAreaTopHeight)
        
        hunheBut = getBut("混合投注")
        hunheBut.tag = 1000
        spfBut = getBut("胜平负")
        spfBut.tag = 2000
        rangSpfBut = getBut("让球胜平负")
        rangSpfBut.tag = 3000
        tatalBut = getBut("总进球")
        tatalBut.tag = 4000
        banBut = getBut("半全场")
        banBut.tag = 5000
        scoreBut = getBut("比分")
        scoreBut.tag = 6000
        twoBut = getBut("2选1")
        twoBut.tag = 7000
        
        self.popView.addSubview(hunheBut)
        self.popView.addSubview(spfBut)
        self.popView.addSubview(rangSpfBut)
        self.popView.addSubview(tatalBut)
        self.popView.addSubview(banBut)
        self.popView.addSubview(scoreBut)
        self.popView.addSubview(twoBut)
        
        hunheBut.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight + 10)
            make.left.equalTo(20)
            make.height.equalTo(30)
        }
        spfBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(hunheBut)
            make.left.equalTo(hunheBut.snp.right).offset(20)
        }
        rangSpfBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(hunheBut)
            make.left.equalTo(spfBut.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        tatalBut.snp.makeConstraints { (make) in
            make.top.equalTo(hunheBut.snp.bottom).offset(10)
            make.left.height.width.equalTo(hunheBut)
            
        }
        banBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(tatalBut)
            make.left.equalTo(tatalBut.snp.right).offset(20)
        }
        scoreBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(tatalBut)
            make.left.equalTo(banBut.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        twoBut.snp.makeConstraints { (make) in
            make.top.equalTo(tatalBut.snp.bottom).offset(10)
            make.left.width.height.equalTo(hunheBut)
        }
        
    }
    
    private func getBut(_ title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        setBut(but: but)
        but.layer.cornerRadius = 1
        but.layer.borderWidth = 1
        but.addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
        return but
    }
    
    private func setBut(but: UIButton) {
        but.setTitleColor(Color505050, for: .normal)
        but.layer.borderColor = ColorC7C7C7.cgColor
    }
    private func setSelectBut(but: UIButton) {
        but.setTitleColor(ColorE85504, for: .normal)
        but.layer.borderColor = ColorE85504.cgColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CXMMFootballMatchMenu {
    @objc private func didClick(_ sender: UIButton) {
        resetState()
        setSelectBut(but: sender)
        
        hide()
        guard delegate != nil else { fatalError("delegate 为空") }
        
        switch sender.tag {
        case 1000:
            delegate.didTipMenu(view: self, type: .混合过关)
        case 2000:
            delegate.didTipMenu(view: self, type: .胜平负)
        case 3000:
            delegate.didTipMenu(view: self, type: .让球胜平负)
        case 4000:
            delegate.didTipMenu(view: self, type: .总进球)
        case 5000:
            delegate.didTipMenu(view: self, type: .半全场)
        case 6000:
            delegate.didTipMenu(view: self, type: .比分)
        case 7000:
            delegate.didTipMenu(view: self, type: .二选一)
        default: break
            
        }
        
    }
}

extension CXMMFootballMatchMenu {
    public func configure(with type : FootballMatchType) {
        resetState()
        
        switch type {
        case .混合过关:
            setSelectBut(but: hunheBut)
        case .胜平负:
            setSelectBut(but: spfBut)
        case .让球胜平负:
            setSelectBut(but: rangSpfBut)
        case .总进球:
            setSelectBut(but: tatalBut)
        case .半全场:
            setSelectBut(but: banBut)
        case .比分:
            setSelectBut(but: scoreBut)
        case .二选一:
            setSelectBut(but: twoBut)
       
        }
    }
    private func resetState() {
        setBut(but: hunheBut)
        setBut(but: spfBut)
        setBut(but: rangSpfBut)
        setBut(but: tatalBut)
        setBut(but: banBut)
        setBut(but: scoreBut)
        setBut(but: twoBut)
    }
}

