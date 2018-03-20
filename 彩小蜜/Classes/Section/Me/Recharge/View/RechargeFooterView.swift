//
//  RechargeFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol RechargeFooterViewDelegate {
    func recharge() -> Void
}

class RechargeFooterView: UIView {

    //MARK: - 点击事件
    @objc private func recharge(_ sender: UIButton) {
        guard delegate != nil else { return }
        
        delegate.recharge()
    }
    //MARK: - 属性
    public var delegate : RechargeFooterViewDelegate!
    private var rechargeBut : UIButton! // 支付按钮
    //MARK: - 初始化
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        
        initSubview()
    }
    
    private func initSubview() {
        rechargeBut = UIButton(type: .custom)
        rechargeBut.setTitle("立即支付", for: .normal)
        rechargeBut.setTitleColor(ColorFFFFFF, for: .normal)
        rechargeBut.titleLabel?.font = Font15
        rechargeBut.backgroundColor = ColorEA5504
        rechargeBut.layer.cornerRadius = 5
        rechargeBut.addTarget(self, action: #selector(recharge(_:)), for: .touchUpInside)
        
        self.addSubview(rechargeBut)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rechargeBut.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.top.equalTo(self).offset(loginButTopSpacing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
