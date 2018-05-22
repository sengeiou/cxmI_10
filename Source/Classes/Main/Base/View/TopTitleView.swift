//
//  TopTitleView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TopTitleView: UIView {

    public var teamInfo: FootballPlayListModel! {
        didSet{
            guard teamInfo != nil else { return }
            homeMatch.text = teamInfo.homeTeamAbbr
            visitingMatch.text = teamInfo.visitingTeamAbbr
        }
    }
    
    private var homeMatch: UILabel!
    private var visitingMatch : UILabel!
    private var vsLb : UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        homeMatch.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(0)
        }
        vsLb.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(homeMatch.snp.right)
        }
        visitingMatch.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(vsLb.snp.right)
            make.right.equalTo(0)
        }
    }
    private func initSubview() {
        homeMatch = initLabel()
        homeMatch.textColor = Color505050
        vsLb = initLabel()
        vsLb.text = "VS"
        vsLb.textColor = Color787878
        visitingMatch = initLabel()
        visitingMatch.textColor = Color505050
        
        self.addSubview(homeMatch)
        self.addSubview(vsLb)
        self.addSubview(visitingMatch)
    }
    
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font14
        lab.textColor = Color787878
        lab.textAlignment = .center
        lab.text = "截止23： 50"
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}