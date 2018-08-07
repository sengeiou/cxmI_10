//
//  CXMMDaletouMenu.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol CXMMDaletouMenuDelegate {
    func didTipMenu(view : CXMMDaletouMenu, type : DaletouType) -> Void
    func didCancel() -> Void
}

class CXMMDaletouMenu: PopMenu {
    
    public var delegate : CXMMDaletouMenuDelegate!
    
    private var standardBut: UIButton!
    private var dantuoBut: UIButton!
    
    private var standardIcon : UIImageView!
    private var dantuoIcon: UIImageView!
   
    override init() {
        super.init()
        initSubview()
    }
    
    private func initSubview() {
        self.viewHeight = CGFloat(50 + SafeAreaTopHeight)
        
        dantuoBut = getBut("标准选号")
        dantuoBut.tag = 1000
        standardBut = getBut("胆拖选号")
        standardBut.tag = 2000
        
        self.popView.addSubview(dantuoBut)
        self.popView.addSubview(standardBut)
       
        standardIcon = getImageView()
        dantuoIcon = getImageView()
       
        
        dantuoBut.addSubview(standardIcon)
        standardBut.addSubview(dantuoIcon)
       

        dantuoBut.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight + 10)
            make.right.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(30 * defaultScale)
            make.width.equalTo(90 * defaultScale)
        }
        standardBut.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(dantuoBut)
            make.left.equalTo(self.snp.centerX).offset(15)
        }
       
        standardIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(18)
        }
        dantuoIcon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.height.width.equalTo(standardIcon)
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

extension CXMMDaletouMenu {
    @objc private func didClick(_ sender: UIButton) {
        resetState()
        
        guard delegate != nil else { fatalError("delegate 为空") }
        
        switch sender.tag {
        case 1000:
            setSelectBut(but: sender, imageView: standardIcon)
            delegate.didTipMenu(view: self, type: .标准选号 )
        case 2000:
            setSelectBut(but: sender, imageView: dantuoIcon)
            delegate.didTipMenu(view: self, type: .胆拖选号 )
        default: break
            
        }
        
        hide()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.delegate.didCancel()
    }
}

extension CXMMDaletouMenu {
    public func configure(with type : DaletouType) {
        resetState()
        
        switch type {
        case .标准选号:
            setSelectBut(but: dantuoBut, imageView: standardIcon)
        case .胆拖选号:
            setSelectBut(but: standardBut, imageView: dantuoIcon)
        
        }
    }
    private func resetState() {
        setDefault(but: dantuoBut, imageView: standardIcon)
        setDefault(but: standardBut, imageView: dantuoIcon)
    }
}
