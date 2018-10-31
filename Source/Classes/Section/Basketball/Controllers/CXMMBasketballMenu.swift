//
//  CXMMBasketballMenu.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol CXMMBasketballMenuDelegate {
    func didTipMenu(view : CXMMBasketballMenu, type : BasketballPlayType) -> Void
    func didCancel() -> Void
}

class CXMMBasketballMenu: PopMenu {
    
    public var delegate : CXMMBasketballMenuDelegate!
    
    
    private var hunheBut: UIButton!
    private var shengfuBut: UIButton!
    private var rangfenBut: UIButton!
    private var daxiaofenBut: UIButton!
    private var shengfenchaBut: UIButton!
    
    private var hunheIcon : UIImageView!
    private var shengfuIcon: UIImageView!
    private var rangfenIcon: UIImageView!
    private var daxiaofenIcon: UIImageView!
    private var shengfenchaIcon: UIImageView!
    
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
        shengfuBut = getBut("胜负")
        shengfuBut.tag = 2000
        rangfenBut = getBut("让分胜负")
        rangfenBut.tag = 3000
        daxiaofenBut = getBut("大小分")
        daxiaofenBut.tag = 4000
        shengfenchaBut = getBut("胜分差")
        shengfenchaBut.tag = 5000
        
        self.popView.addSubview(hunheBut)
        self.popView.addSubview(shengfuBut)
        self.popView.addSubview(rangfenBut)
        self.popView.addSubview(daxiaofenBut)
        self.popView.addSubview(shengfenchaBut)
        
        hunheIcon = getImageView()
        shengfuIcon = getImageView()
        rangfenIcon = getImageView()
        daxiaofenIcon = getImageView()
        shengfenchaIcon = getImageView()
        
        hunheBut.addSubview(hunheIcon)
        shengfuBut.addSubview(shengfuIcon)
        rangfenBut.addSubview(rangfenIcon)
        daxiaofenBut.addSubview(daxiaofenIcon)
        shengfenchaBut.addSubview(shengfenchaIcon)
        
        hunheBut.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight + 10)
            make.left.equalTo(20)
            make.height.equalTo(30)
        }
        shengfuBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(hunheBut)
            make.left.equalTo(hunheBut.snp.right).offset(20)
        }
        rangfenBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(hunheBut)
            make.left.equalTo(shengfuBut.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        daxiaofenBut.snp.makeConstraints { (make) in
            make.top.equalTo(hunheBut.snp.bottom).offset(10)
            make.left.height.width.equalTo(hunheBut)
            
        }
        shengfenchaBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(daxiaofenBut)
            make.left.equalTo(daxiaofenBut.snp.right).offset(20)
        }
        
        hunheIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(18)
        }
        shengfuIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        rangfenIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        daxiaofenIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(hunheIcon)
        }
        shengfenchaIcon.snp.makeConstraints { (make) in
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

extension CXMMBasketballMenu {
    @objc private func didClick(_ sender: UIButton) {
        resetState()
        
        guard delegate != nil else { fatalError("delegate 为空") }
        
        switch sender.tag {
        case 1000:
            setSelectBut(but: sender, imageView: hunheIcon)
            delegate.didTipMenu(view: self, type: .混合投注)
        case 2000:
            setSelectBut(but: sender, imageView: shengfuIcon)
            delegate.didTipMenu(view: self, type: .胜负)
        case 3000:
            setSelectBut(but: sender, imageView: rangfenIcon)
            delegate.didTipMenu(view: self, type: .让分胜负)
        case 4000:
            setSelectBut(but: sender, imageView: daxiaofenIcon)
            delegate.didTipMenu(view: self, type: .大小分)
        case 5000:
            setSelectBut(but: sender, imageView: shengfenchaIcon)
            delegate.didTipMenu(view: self, type: .胜分差)
        default: break
            
        }
        
        hide()
    }
}

extension CXMMBasketballMenu {
    public func configure(with type : BasketballPlayType) {
        resetState()
        
        switch type {
        case .混合投注:
            setSelectBut(but: hunheBut, imageView: hunheIcon)
        case .胜负:
            setSelectBut(but: shengfuBut, imageView: shengfuIcon)
        case .让分胜负:
            setSelectBut(but: rangfenBut, imageView: rangfenIcon)
        case .大小分:
            setSelectBut(but: daxiaofenBut, imageView: daxiaofenIcon)
        case .胜分差:
            setSelectBut(but: shengfenchaBut, imageView: shengfenchaIcon)
        
            
        }
    }
    private func resetState() {
        setDefault(but: hunheBut, imageView: hunheIcon)
        setDefault(but: shengfuBut, imageView: shengfuIcon)
        setDefault(but: rangfenBut, imageView: rangfenIcon)
        setDefault(but: daxiaofenBut, imageView: daxiaofenIcon)
        setDefault(but: shengfenchaBut, imageView: shengfenchaIcon)
    }
}
