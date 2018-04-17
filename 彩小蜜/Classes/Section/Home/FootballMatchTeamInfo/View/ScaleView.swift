//
//  ScaleView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ScaleView: UIView {
    
    public var scaleNum : CGFloat = 0.0 {
        didSet{
            layoutScale()
        }
    }
    
    public var scaleColor: UIColor! {
        didSet{
            acaleView.backgroundColor = scaleColor
        }
    }
    
    private var acaleView : UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    private func initSubview() {
        self.backgroundColor = ColorF4F4F4
        
        acaleView = UIView()
        
        self.addSubview(acaleView)
    }
    
    private func layoutScale() {
        acaleView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(0)
            make.width.equalTo((306 * scaleNum) * defaultScale)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
