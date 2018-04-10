//
//  FootballTotalView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



class FootballTotalView: UIView {

    private var bgView: UIView!
    private var centerLine : UIView!
    
    private var button0 : UIButton!
    private var button1 : UIButton!
    private var button2 : UIButton!
    private var button3 : UIButton!
    private var button4 : UIButton!
    private var button5 : UIButton!
    private var button6 : UIButton!
    private var button7 : UIButton!
    
    private var line1 : UIView!
    private var line2 : UIView!
    private var line3 : UIView!
    private var line4 : UIView!
    private var line5 : UIView!
    private var line6 : UIView!
    
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    private func getButton() -> UIButton {
        let but = UIButton(type: .custom)
        
        return but 
    }
    
    
    // MARK: 初始化子视图
    private func initSubview() {
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
