//
//  FootballMatchInfoHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballMatchInfoHeader: UIView {

    public var matchInfo : MatchInfoModel! {
        didSet{
            header.matchInfo = matchInfo
        }
    }
    
    public var pagerView: FootballMatchPagerView!
    private var header : FootballTeamHeader!
    private var bottonLine: UIView!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 189 * defaultScale))
        initSubview()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(140 * defaultScale)
        }
        pagerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(header.snp.bottom)
            make.bottom.equalTo(bottonLine.snp.top)
        }
        bottonLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(5)
            make.left.right.equalTo(0)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        bottonLine = UIView()
        bottonLine.backgroundColor = ColorF4F4F4
        
        header = FootballTeamHeader()
        header.headerStyle = .详情
        
        pagerView = FootballMatchPagerView()
        
        self.addSubview(header)
        self.addSubview(pagerView)
        self.addSubview(bottonLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

   

}
