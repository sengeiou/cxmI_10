//
//  FootballOrderFooter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballOrderFooterDelegate {
    func didTipSelectedAgreement(isAgerr: Bool) -> Void
    func didTipAgreement() -> Void
}

class FootballOrderFooter: UIView {

    public var delegate: FootballOrderFooterDelegate!
    
    private var agreementBut: UIButton!
    private var agreement : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
        initSubview()
    }
    
    @objc private func agreementButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard delegate != nil else { return }
        delegate.didTipSelectedAgreement(isAgerr: !sender.isSelected)
    }
    
    @objc private func agreementClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipAgreement()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        agreementBut.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.right.equalTo(agreement.snp.left).offset(-10)
            make.height.width.equalTo(18)
        }
        agreement.snp.makeConstraints { (make) in
            make.centerY.equalTo(agreementBut)
            make.centerX.equalTo(self.snp.centerX).offset(10)
            make.height.equalTo(agreementBut)
        }
    }
    private func initSubview() {
        
        let muAtt = NSMutableAttributedString(string: "我已阅读并同意 ", attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
        let att = NSAttributedString(string: "《彩小秘投注服务协议》", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
        muAtt.append(att)
        
        agreementBut = UIButton(type: .custom)
        agreementBut.contentHorizontalAlignment = .center
        agreementBut.setBackgroundImage(UIImage(named: "tongyi"), for: .normal)
        agreementBut.setBackgroundImage(UIImage(named: "butongyi"), for: .selected)
        
        agreementBut.addTarget(self, action: #selector(agreementButClicked(_:)), for: .touchUpInside)
        
        agreement = UIButton(type: .custom)
        agreement.contentHorizontalAlignment = .left
        agreement.setAttributedTitle(muAtt, for: .normal)
        agreement.setTitleColor(Color505050, for: .normal)
        agreement.titleLabel?.font = Font13
        agreement.titleLabel?.sizeToFit()
        agreement.addTarget(self, action: #selector(agreementClicked(_:)), for: .touchUpInside)
        
        
        self.addSubview(agreementBut)
        self.addSubview(agreement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
