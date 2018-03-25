//
//  OrderDetailFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderDetailFooterView: UIView {

    private var button : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func initSubview() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
