//
//  ScaleView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ScaleView: UIView {
    
    public var scaleNum : CGFloat! {
        didSet{
            guard scaleNum != nil, scaleNum.isNaN == false else { return }
            layoutScale()
        }
    }
    
    public var scaleWidth: CGFloat = 306 * defaultScale
    
    public var scaleColor: UIColor! {
        didSet{
            guard scaleColor != nil else { return }
            acaleView.backgroundColor = scaleColor
        }
    }
    
    public var sequence = true {
        didSet{
            
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
        if sequence {
            acaleView.snp.makeConstraints { (make) in
                make.top.bottom.left.equalTo(0)
                make.width.equalTo((scaleWidth ) * scaleNum)
            }
        }else {
            acaleView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.right.equalTo(0)
                make.width.equalTo((scaleWidth ) * scaleNum)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
