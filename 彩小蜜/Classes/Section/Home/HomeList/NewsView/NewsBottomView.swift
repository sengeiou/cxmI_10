//
//  NewsBottomView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NewsBottomView: UIView {

    // MARK: - 属性 public
    public var newsInfo : NewsInfoModel! {
        didSet{
            guard newsInfo != nil else { return }
            titleLb.text = newsInfo.author
            timeLb.text = newsInfo.addTime
            if newsInfo.clickNumber != nil {
                readNumLb.text = "阅读\(newsInfo.clickNumber!)"
            }
            
        }
    }
    
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var timeLb : UILabel!
    private var readNumLb: UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            //make.width.equalTo(80 * defaultScale)
        }
        timeLb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLb)
            make.left.equalTo(titleLb.snp.right).offset(16 * defaultScale)
        }
        readNumLb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLb)
            make.left.equalTo(timeLb.snp.right).offset(16 * defaultScale)
            make.right.equalTo(0)
        }
    }
    
    private func initSubview() {
        titleLb = getLabel("彩小秘精选")
        titleLb.sizeToFit()
        timeLb = getLabel("")
        timeLb.sizeToFit()
        readNumLb = getLabel("")
        
        self.addSubview(titleLb)
        self.addSubview(timeLb)
        self.addSubview(readNumLb)
    }
    
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        //lab.text = title
        lab.textColor = Color9F9F9F
        lab.textAlignment = .left
        
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
