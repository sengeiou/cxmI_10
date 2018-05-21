//
//  OrderDetailFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol OrderDetailFooterViewDelegate {
    func goBuy() -> Void
}

class OrderDetailFooterView: UIView {

    @objc private func orderClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.goBuy()
    }
    
    public var delegate: OrderDetailFooterViewDelegate!
    private var button : UIButton!
    
    init() {
        //super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: OrderHeaderViewHeight))
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(1)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(-0)
            make.bottom.equalTo(0)
            //make.height.equalTo(loginButHeight)
        }
    }
    
    private func initSubview() {
        button = UIButton(type: .custom)
        button.setTitle("继续预约", for: .normal)
        button.setTitleColor(ColorFFFFFF, for: .normal)
        button.backgroundColor = ColorEA5504
        button.addTarget(self, action: #selector(orderClicked(_:)), for: .touchUpInside)
        
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
