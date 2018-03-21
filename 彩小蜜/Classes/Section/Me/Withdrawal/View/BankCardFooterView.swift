//
//  BankCardFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol BankCardFooterViewDelegate {
    func addNewBankCard() -> Void
}

class BankCardFooterView: UIView {

    //MARK: - 点击事件
    @objc private func addNewCard(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.addNewBankCard()
    }
    //MARK: - 属性
    public var delegate : BankCardFooterViewDelegate!
    private var addCardBut: UIButton! // 添加新银行卡
    private var detailIcon : UIImageView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        
        initSubview()
    }
    
    //MARK: - UI
    private func initSubview() {
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        addCardBut = UIButton(type: .custom)
        addCardBut.titleLabel?.font = Font13
        addCardBut.setTitle(" 添加银行卡", for: .normal)
        addCardBut.setTitleColor(ColorA0A0A0, for: .normal)
        addCardBut.setImage(UIImage(named: "jump"), for: .normal)
        addCardBut.backgroundColor = ColorFFFFFF
        addCardBut.contentHorizontalAlignment = .left
        addCardBut.imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(leftSpacing), bottom: 0, right: 10)
        addCardBut.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(leftSpacing), bottom: 0, right: 0)
        addCardBut.addTarget(self, action: #selector(addNewCard(_:)), for: .touchUpInside)
        
        self.addSubview(addCardBut)
        addCardBut.addSubview(detailIcon)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(addCardBut.snp.centerY)
            make.height.width.equalTo(14)
            make.right.equalTo(addCardBut).offset(-rightSpacing)
        }
        
        addCardBut.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(sectionHeaderHeight)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
