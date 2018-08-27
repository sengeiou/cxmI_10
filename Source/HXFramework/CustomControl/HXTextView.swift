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
            guard limitNumber != nil else { return }
            leftNum = limitNumber
        }
    }
    
    private var leftNum : Int! {
        willSet{
            numLB.text = "还可输入" + "\(newValue!)" + "字"
        }
    }
    
    public var textView: HHTextView!
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
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        self.layer.cornerRadius = 3
        self.backgroundColor = ColorFFFFFF
        
        textView = HHTextView()
        textView.delegate = self
        textView.placeholder = "投诉建议"
        textView.backgroundColor = ColorFFFFFF
        textView.placeholderColor = ColorA0A0A0
        textView.font = Font12
        
        numLB = UILabel()
        numLB.font = Font12
        numLB.textColor = ColorC8C8C8
        numLB.textAlignment = .right
        //numLB.text = "SSS"
        
        self.addSubview(textView)
        self.addSubview(numLB)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > limitNumber {
            
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            
            //获取高亮部分 － 如果有联想词则解包成功
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum : Int = (textContent?.count)!
            
            //截取200个字
            if textNum > limitNumber {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: limitNumber)
                let str = textContent?.prefix(upTo: index!)
                textView.text = str?.description
            }
        }else {
            let textContent = textView.text
            let textNum : Int = (textContent?.count)!
            self.leftNum = limitNumber - textNum
        }
        
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        let xxx = textView.text as! NSString
//        let xxxx = xxx.length
//
//        if range.location >= limitNumber || textView.text.lengthOfBytes(using: .utf8) >= limitNumber {
//
//            return false
//        }
//
//
//
//
//        if text == "" {
//            leftNum = limitNumber - (range.location + 0)
//        }else {
//            leftNum = limitNumber - (range.location + 1)
//        }
//
//        return true
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
