//
//  FootballAnalysisMatchView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballAnalysisMatchView: UIView {

    
    private var matchName: UILabel!
    private var matchTime: UILabel!
    private var matchScore: UILabel!
    private var matchResult: UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        matchName.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(63 * defaultScale)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(matchName.snp.right)
            make.width.equalTo(80 * defaultScale)
        }
        
        matchResult.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-21 * defaultScale)
            make.width.equalTo(30 * defaultScale)
        }
        matchScore.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(matchTime.snp.right)
            make.right.equalTo(matchResult.snp.left)
        }
    }
    
    private func initSubview() {
        matchName = getLabel("赛事")
        matchName.sizeToFit()
        
        matchTime = getLabel("日期")
        matchTime.sizeToFit()
        
        matchScore = getLabel("比分")
        
        matchResult = getLabel("胜负")
        matchResult.sizeToFit()
        
        self.addSubview(matchName)
        self.addSubview(matchTime)
        self.addSubview(matchScore)
        self.addSubview(matchResult)
    }
    
    private func getLabel(_ title: String) -> UILabel {
        let lab = UILabel()
        lab.text = title
        lab.font = Font12
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
