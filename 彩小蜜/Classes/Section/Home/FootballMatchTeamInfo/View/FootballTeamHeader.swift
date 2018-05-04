//
//  FootballTeamHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//  高度140

import UIKit

enum TeamHeaderStyle  {
    case 详情
    case 默认
}

class FootballTeamHeader: UIView {

    public var matchInfo : MatchInfoModel! {
        didSet{
            guard matchInfo != nil else { return }
            titlelb.text = matchInfo.changci + " " + matchInfo.leagueAddr + " " + matchInfo.matchTime
            homeName.text = matchInfo.homeTeamAbbr
            visiName.text = matchInfo.visitingTeamAbbr
            homeOdds.text = "主胜" + matchInfo.hOdds
            flatOdds.text = "平" + matchInfo.dOdds
            visiOdds.text = "客胜" + matchInfo.aOdds
            guard let homeurl = URL(string: matchInfo.homeTeamPic) else { return }
            guard let visiUrl = URL(string: matchInfo.visitingTeamPic) else { return }
            homeTeamIcon.kf.setImage(with: homeurl)
            visiTeamIcon.kf.setImage(with: visiUrl)
        }
    }
    
    public var headerStyle : TeamHeaderStyle = .默认 {
        didSet{
            
            if headerStyle == .详情 {
                bottomLine.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.height.equalTo(0.5)
                    make.left.equalTo(self)
                    make.right.equalTo(self)
                }
            }else {
                bottomLine.snp.makeConstraints { (make) in
                    make.bottom.equalTo(0)
                    make.height.equalTo(0.5)
                    make.left.equalTo(10 * defaultScale)
                    make.right.equalTo(-10 * defaultScale)
                }
            }
        }
    }
    
    // MARK : - 属性 private
    private var titlelb : UILabel!
    private var homeTeamIcon : UIImageView!
    private var visiTeamIcon : UIImageView!
    private var homeName : UILabel!
    private var visiName : UILabel!
    private var homeOdds : UILabel!
    private var visiOdds : UILabel!
    private var flatOdds : UILabel!
    private var flatName : UILabel!
    
    public var bottomLine : UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titlelb.snp.makeConstraints { (make) in
            make.top.equalTo(14 * defaultScale)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
            make.height.equalTo(11 * defaultScale)
        }
        homeTeamIcon.snp.makeConstraints { (make) in
            make.top.equalTo(titlelb.snp.bottom).offset(14 * defaultScale)
            make.left.equalTo(71 * defaultScale)
            make.height.width.equalTo(40 * defaultScale)
        }
        visiTeamIcon.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(homeTeamIcon)
            make.right.equalTo(-71 * defaultScale)
        }
        homeName.snp.makeConstraints { (make) in
            make.top.equalTo(homeTeamIcon.snp.bottom).offset(9 * defaultScale)
            make.centerX.equalTo(homeTeamIcon.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(15 * defaultScale)
        }
        visiName.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(homeName)
            make.centerX.equalTo(visiTeamIcon.snp.centerX)
        }
        flatName.snp.makeConstraints { (make) in
            make.left.equalTo(homeName.snp.right)
            make.right.equalTo(visiName.snp.left)
            make.top.height.equalTo(homeName)
        }
        homeOdds.snp.makeConstraints { (make) in
            make.top.equalTo(homeName.snp.bottom).offset(8 * defaultScale)
            make.centerX.equalTo(homeName.snp.centerX)
            make.width.equalTo(homeName)
            make.height.equalTo(13 * defaultScale)
        }
        visiOdds.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(homeOdds)
            make.centerX.equalTo(visiName.snp.centerX)
        }
        flatOdds.snp.makeConstraints { (make) in
            make.top.equalTo(homeOdds)
            make.width.equalTo(flatName)
            make.height.equalTo(homeOdds)
            make.left.equalTo(flatName)
        }
    }

    private func initSubview() {
        titlelb = getLabel()
        titlelb.textAlignment = .left
        titlelb.font = Font11
        titlelb.text = "001 德国杯 2月7日 01： 30"
        
        homeName = getLabel()
        homeName.font = Font15
        homeName.textColor = Color505050
        
        homeOdds = getLabel()
        
        visiName = getLabel()
        visiName.font = Font15
        visiName.textColor = Color505050
        
        visiOdds = getLabel()
        
        flatName = getLabel()
        flatName.font = Font15
        flatName.text = "VS"
        
        flatOdds = getLabel()
        
        homeTeamIcon = UIImageView()
        homeTeamIcon.image = UIImage(named : "Racecolorfootball")
        
        visiTeamIcon = UIImageView()
        visiTeamIcon.image = UIImage(named : "Racecolorfootball")
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        self.addSubview(titlelb)
        self.addSubview(homeName)
        self.addSubview(homeOdds)
        self.addSubview(visiName)
        self.addSubview(visiOdds)
        self.addSubview(flatName)
        self.addSubview(flatOdds)
        self.addSubview(homeTeamIcon)
        self.addSubview(visiTeamIcon)
        self.addSubview(bottomLine)
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        //lab.text = "阿森纳"
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
