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
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        
        initSubview()
    }
    
    //MARK: - UI
    private func initSubview() {
        addCardBut = UIButton(type: .custom)
        addCardBut.setTitle("使用新银行卡收款", for: .normal)
        addCardBut.setTitleColor(UIColor.white, for: .normal)
        addCardBut.backgroundColor = UIColor.green
        addCardBut.layer.cornerRadius = 5
        addCardBut.addTarget(self, action: #selector(addNewCard(_:)), for: .touchUpInside)
        
        self.addSubview(addCardBut)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addCardBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(80)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
