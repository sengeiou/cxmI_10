//
//  MeFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol MeFooterViewDelegate {
    func signOutClicked() ->Void
}

class MeFooterView: UIView {

    // MARK: - 点击事件
    @objc private func signOutClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.signOutClicked()
    }
    
    // MARK: - 属性
    public var delegate : MeFooterViewDelegate!
    private var signOutBut : UIButton! // 退出按钮
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        initSubview()
    }
    
    private func initSubview() {
        signOutBut = UIButton(type: .custom)
        self.addSubview(signOutBut)
        
        signOutBut.titleLabel?.font = Font14
        signOutBut.setTitle("退出登录", for: .normal)
        signOutBut.setTitleColor(ColorFFFFFF, for: .normal)
        signOutBut.backgroundColor = ColorEA5504
        signOutBut.layer.cornerRadius = 5
        signOutBut.addTarget(self, action: #selector(signOutClicked(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        signOutBut.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.top.equalTo(self).offset(21)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
