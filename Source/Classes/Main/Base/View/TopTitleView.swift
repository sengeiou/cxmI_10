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
//            homeMatch.text = teamInfo.homeTeamAbbr
//            visitingMatch.text = teamInfo.visitingTeamAbbr
            if teamInfo.homeTeamRank != nil && teamInfo.homeTeamRank != "" {
                homeMatch.text = "[\(teamInfo.homeTeamRank!)]" + teamInfo.homeTeamAbbr
            }else {
                homeMatch.text = teamInfo.homeTeamAbbr
            }
            
            if teamInfo.visitingTeamRank != nil && teamInfo.visitingTeamRank != "" {
                visitingMatch.text = "[\(teamInfo.visitingTeamRank!)]" + teamInfo.visitingTeamAbbr
            }else {
                visitingMatch.text = teamInfo.visitingTeamAbbr
            }
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
            make.right.equalTo(vsLb.snp.left)
        }
        vsLb.snp.makeConstraints { (make) in
            make.width.equalTo(25 * defaultScale)
            make.top.bottom.equalTo(homeMatch)
            make.centerX.equalTo(self.snp.centerX)
        }
        visitingMatch.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeMatch)
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
        lab.font = Font15
        lab.textColor = Color505050
        lab.textAlignment = .center
        //lab.text = "截止23： 50"
        //lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
