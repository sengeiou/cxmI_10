//
//  HXTextView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HXTextView: UIView, UITextViewDelegate {

    public var limitNumber: Int! {
        didSet{
            leftNum = limitNumber
        }
    }
    
    private var leftNum : Int! {
        willSet{
            numLB.text = "还可输入" + "\(newValue!)" + "字"
        }
    }
    
    private var textView: HHTextView!
    private var numLB: UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(numLB.snp.top)
        }
        numLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(-5)
            make.left.equalTo(1)
            make.right.equalTo(-10)
            make.height.equalTo(12)
        }
    }
    
    private func initSubview() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorC8C8C8.cgColor
        self.layer.cornerRadius = 5
        self.backgroundColor = ColorFFFFFF
        
        textView = HHTextView()
        textView.delegate = self
        textView.placeholder = "投诉建议"
        textView.backgroundColor = ColorFFFFFF
        
        numLB = UILabel()
        numLB.font = Font10
        numLB.textColor = ColorA0A0A0
        numLB.textAlignment = .right
        numLB.text = "SSS"
        
        self.addSubview(textView)
        self.addSubview(numLB)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if range.location >= limitNumber {
            return false
        }
        if text == "" {
            leftNum = limitNumber - (range.location + 0)
        }else {
            leftNum = limitNumber - (range.location + 1)
        }
        
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
