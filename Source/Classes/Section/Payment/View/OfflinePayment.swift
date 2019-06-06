//
//  OfflinePaymentView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/5/24.
//  Copyright © 2019 韩笑. All rights reserved.
//


import UIKit
import PKHUD


protocol OfflinePaymentDelegate {
    func didTipContact() -> Void
    func deleteHide() -> Void
}


class OfflinePayment: BasicDialog {
    
    public var delegate : OfflinePaymentDelegate!
    
    lazy public var view : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    lazy var copyBut : UIButton = {
        let but = UIButton(type: .custom)
        but.layer.cornerRadius = 6.0
        but.layer.borderColor = ColorD12120.cgColor
        but.layer.borderWidth = 0.5
        but.setTitle("复制", for: .normal)
        but.setTitleColor(.red, for: .normal)
        but.titleLabel?.font = Font14
        but.addTarget(self, action: #selector(copyWechat), for: .touchUpInside)
        return but
    }()
    
    lazy public var titlelLabel : UILabel = {
        var titlelLabel = UILabel()
        titlelLabel.font = Font18
        titlelLabel.textColor = .black
        titlelLabel.text = "线下充值"
        titlelLabel.textAlignment = .center
        return titlelLabel
    }()
    
    lazy public var lineTop : UIView = {
        let view = UIView()
        view.backgroundColor = ColorA0A0A0
        return view
    }()
    
    lazy public var lineBottom : UIView = {
        let view = UIView()
        view.backgroundColor = ColorA0A0A0
        return view
    }()
    
    lazy public var lineCenter : UIView = {
        let lineCenter = UIView()
        lineCenter.backgroundColor = ColorA0A0A0
        return lineCenter
    }()
    
    lazy public var wechatTitle : UILabel = {
        var wechatTitle = UILabel()
        wechatTitle.font = Font16
        wechatTitle.textColor = .black
        wechatTitle.text = "店主微信号: "
        return wechatTitle
    }()
    
    lazy public var wechatLabel : UILabel = {
        var wechatLabel = UILabel()
        wechatLabel.font = Font14
        wechatLabel.textColor = .black
        wechatLabel.text = ""
        return wechatLabel
    }()
    
    lazy public var step1 : UILabel = {
        var step1 = UILabel()
        step1.font = Font14
        step1.textColor = .black
        step1.text = "第一步:复制店主微信号"
        return step1
    }()
    
    lazy public var step2 : UILabel = {
        var step2 = UILabel()
        step2.font = Font14
        step2.textColor = .black
        step2.text = "第二步:点击(联系店主)打开微信"
        return step2
    }()
    
    lazy public var step3 : UILabel = {
        var step3 = UILabel()
        step3.font = Font14
        step3.textColor = .black
        step3.text = "第三步:添加店主微信,人工转账充值"
        return step3
    }()
    
    lazy public var detailLabel : UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = Font14
        detailLabel.textColor = .red
        detailLabel.text = "注：首次充值需添加店主微信号，往后充值可直接联系店主微信直接充值"
        detailLabel.textAlignment = .left
        detailLabel.numberOfLines = 0
        return detailLabel
    }()
    
    lazy var noContactBut : UIButton = {
        let noContactBut = UIButton(type: .custom)
        noContactBut.setTitle("暂不联系", for: .normal)
        noContactBut.setTitleColor(ColorA0A0A0, for: .normal)
        noContactBut.titleLabel?.font = Font16
        noContactBut.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return noContactBut
    }()
    
    lazy var contactBut : UIButton = {
        let contactBut = UIButton(type: .custom)
        contactBut.setTitle("联系店主", for: .normal)
        contactBut.setTitleColor(.red, for: .normal)
        contactBut.titleLabel?.font = Font16
        contactBut.addTarget(self, action: #selector(didTipContact), for: .touchUpInside)
        return contactBut
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override func createView() {
        addDialogToWindow()
    }
    
    
    public func configure(width : CGFloat, height : CGFloat) {
        self.addSubview(view)
        view.addSubview(copyBut)
        view.addSubview(titlelLabel)
        view.addSubview(lineTop)
        view.addSubview(lineBottom)
        view.addSubview(wechatTitle)
        view.addSubview(wechatLabel)
        view.addSubview(step1)
        view.addSubview(step2)
        view.addSubview(step3)
        view.addSubview(detailLabel)
        view.addSubview(noContactBut)
        view.addSubview(contactBut)
        view.addSubview(lineCenter)

        
        let scale = width / height
        var viewWidth : CGFloat = 0.0
        var viewHeight : CGFloat = 0.0
        
        if width < screenWidth - 40 && height < screenHeight {
            viewWidth  = width
            viewHeight = height
        }else {
            viewWidth = screenWidth - 40
            viewHeight = viewWidth / scale
        }
        view.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(viewWidth)
            make.height.equalTo(viewHeight)
        }
        
        titlelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(16 * defaultScale)
            make.centerX.equalTo(self)
        }
        
        lineTop.snp.makeConstraints { (make) in
            make.top.equalTo(titlelLabel.snp.bottom).offset(16 * defaultScale)
            make.left.right.equalTo(view)
            make.height.equalTo(0.5 * defaultScale)
        }
        
        wechatTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lineTop.snp.bottom).offset(12 * defaultScale)
            make.left.equalTo(view).offset(24 * defaultScale)
        }
        
        wechatLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(wechatTitle)
            make.left.equalTo(wechatTitle.snp_right)
        }
        
        copyBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(wechatLabel)
            make.right.equalTo(view).offset(-16 * defaultScale)
            make.height.equalTo(26 * defaultScale)
            make.width.equalTo(65 * defaultScale)
        }
        
        step1.snp.makeConstraints { (make) in
            make.top.equalTo(wechatLabel.snp.bottom).offset(14 * defaultScale)
            make.left.equalTo(wechatTitle)
            make.right.equalTo(view).offset(-16 * defaultScale)
        }
        
        step2.snp.makeConstraints { (make) in
            make.top.equalTo(step1.snp.bottom).offset(8 * defaultScale)
            make.left.equalTo(wechatTitle)
            make.right.equalTo(view).offset(-16 * defaultScale)
        }
        
        step3.snp.makeConstraints { (make) in
            make.top.equalTo(step2.snp.bottom).offset(8 * defaultScale)
            make.left.equalTo(wechatTitle)
            make.right.equalTo(view).offset(-16 * defaultScale)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(step3.snp.bottom).offset(14 * defaultScale)
            make.left.equalTo(wechatTitle)
            make.right.equalTo(view).offset(-16 * defaultScale)
        }
        
        noContactBut.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(40 * defaultScale)
             make.width.equalTo((viewWidth / 2) - 0.25 * defaultScale)
        }
        
        contactBut.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(40 * defaultScale)
//            make.width.equalTo(((viewWidth / 2) - 0.25) * defaultScale)
             make.width.equalTo((viewWidth / 2) - 0.25 * defaultScale)
        }
        
        lineBottom.snp.makeConstraints { (make) in
            make.bottom.equalTo(contactBut.snp.top).offset(1 * defaultScale)
            make.left.right.equalTo(view)
            make.height.equalTo(0.5 * defaultScale)
        }
        
        lineCenter.snp.makeConstraints { (make) in
            make.centerY.equalTo(noContactBut)
            make.left.equalTo(noContactBut.snp.right)
            make.width.equalTo(0.5 * defaultScale)
            make.height.equalTo(40 * 0.5 * defaultScale)
        }
    }
}


// MARK: - 点击事件
extension OfflinePayment {
    @objc private func didTipContact() {
        guard delegate != nil else { return }
        delegate.didTipContact()
        self.hide()
    }
    
    @objc private func deleteClicked() {
        self.hide()
        delegate.deleteHide()
    }
    
    @objc private func copyWechat() {
        UIPasteboard.general.string = wechatLabel.text
        HUD.flash(.label("复制成功"), delay: 0.25)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        self.dismiss(animated: true , completion: nil)
    }
}



// MARK: - 初始化页面
extension OfflinePayment {
    private func initSubview() {
        
    }
}