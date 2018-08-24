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
    func didCancel() -> Void
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
    
    private var hunheIcon : UIImageView!
    private var spfIcon: UIImageView!
    private var rangSpfIcon: UIImageView!
    private var totalIcon: UIImageView!
    private var banIcon: UIImageView!
    private var scoreIcon : UIImageView!
    private var twoIcon: UIImageView!
    
    override init() {
        super.init()
        initSubview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.delegate.didCancel()
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
        
        hunheIcon = getImageView()
        spfIcon = getImageView()
        rangSpfIcon = getImageView()
        totalIcon = getImageView()
        banIcon = getImageView()
        scoreIcon = getImageView()
        twoIcon = getImageView()
        
        hunheBut.addSubview(hunheIcon)
        spfBut.addSubview(spfIcon)
        rangSpfBut.addSubview(rangSpfIcon)
        tatalBut.addSubview(totalIcon)
        banBut.addSubview(banIcon)
        scoreBut.addSubview(scoreIcon)
        twoBut.addSubview(twoIcon)
        
        
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
        
        hunheIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(18)
        }
        spfIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        rangSpfIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        totalIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        banIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        scoreIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        twoIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
    }
    
    private func getBut(_ title : String) -> UIButton {
        let but = UIButton(type: .custom)
        but.setTitle(title, for: .normal)
        but.setTitleColor(Color505050, for: .normal)
        but.layer.borderColor = ColorC7C7C7.cgColor
        but.layer.cornerRadius = 1
        but.layer.borderWidth = 1
        but.titleLabel?.font = Font14
        but.addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
        return but
    }
    
    private func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Check")
        return imageView
    }
    
    private func setDefault(but: UIButton, imageView: UIImageView) {
        but.setTitleColor(Color505050, for: .normal)
        but.layer.borderColor = ColorC7C7C7.cgColor
        imageView.isHidden = true
    }
   
    private func setSelectBut(but: UIButton, imageView: UIImageView) {
        but.setTitleColor(ColorE85504, for: .normal)
        but.layer.borderColor = ColorE85504.cgColor
        imageView.isHidden = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CXMMFootballMatchMenu {
    @objc private func didClick(_ sender: UIButton) {
        resetState()
        
        guard delegate != nil else { fatalError("delegate 为空") }
        
        switch sender.tag {
        case 1000:
            setSelectBut(but: sender, imageView: hunheIcon)
            delegate.didTipMenu(view: self, type: .混合过关)
        case 2000:
            setSelectBut(but: sender, imageView: spfIcon)
            delegate.didTipMenu(view: self, type: .胜平负)
        case 3000:
            setSelectBut(but: sender, imageView: rangSpfIcon)
            delegate.didTipMenu(view: self, type: .让球胜平负)
        case 4000:
            setSelectBut(but: sender, imageView: totalIcon)
            delegate.didTipMenu(view: self, type: .总进球)
        case 5000:
            setSelectBut(but: sender, imageView: banIcon)
            delegate.didTipMenu(view: self, type: .半全场)
        case 6000:
            setSelectBut(but: sender, imageView: scoreIcon)
            delegate.didTipMenu(view: self, type: .比分)
        case 7000:
            setSelectBut(but: sender, imageView: twoIcon)
            delegate.didTipMenu(view: self, type: .二选一)
        default: break
            
        }
        
        hide()
    }
}

extension CXMMFootballMatchMenu {
    public func configure(with type : FootballMatchType) {
        resetState()
        
        switch type {
        case .混合过关:
            setSelectBut(but: hunheBut, imageView: hunheIcon)
        case .胜平负:
            setSelectBut(but: spfBut, imageView: spfIcon)
        case .让球胜平负:
            setSelectBut(but: rangSpfBut, imageView: rangSpfIcon)
        case .总进球:
            setSelectBut(but: tatalBut, imageView: totalIcon)
        case .半全场:
            setSelectBut(but: banBut, imageView: banIcon)
        case .比分:
            setSelectBut(but: scoreBut, imageView: scoreIcon)
        case .二选一:
            setSelectBut(but: twoBut, imageView: twoIcon)
       
        }
    }
    private func resetState() {
        setDefault(but: hunheBut, imageView: hunheIcon)
        setDefault(but: spfBut, imageView: spfIcon)
        setDefault(but: rangSpfBut, imageView: rangSpfIcon)
        setDefault(but: tatalBut, imageView: totalIcon)
        setDefault(but: banBut, imageView: banIcon)
        setDefault(but: scoreBut, imageView: scoreIcon)
        setDefault(but: twoBut, imageView: twoIcon)
        
    }
}

