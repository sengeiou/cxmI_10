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

class FootballTeamHeader: UIView, DateProtocol {

    public var matchInfo : MatchInfoModel! {
        didSet{
            guard matchInfo != nil else { return }
            let time = timeStampToHHmm(matchInfo.matchTime)
            titlelb.text = matchInfo.changci + " " + matchInfo.leagueAddr + " " + time
            
            
            if matchInfo.homeTeamRank != nil && matchInfo.homeTeamRank != "" {
                homeName.text = "[\(matchInfo.homeTeamRank!)]" + matchInfo.homeTeamAbbr
            }else {
                homeName.text = matchInfo.homeTeamAbbr
            }
            
            if matchInfo.visitingTeamRank != nil && matchInfo.visitingTeamRank != "" {
                visiName.text = "[\(matchInfo.visitingTeamRank!)]" + matchInfo.visitingTeamAbbr
            }else {
                visiName.text = matchInfo.visitingTeamAbbr
            }
            
            //homeOdds.text = "主胜" + matchInfo.hOdds
            //flatOdds.text = "平" + matchInfo.dOdds
            //visiOdds.text = "客胜" + matchInfo.aOdds
            
            guard let homeurl = URL(string: matchInfo.homeTeamPic) else { return }
            guard let visiUrl = URL(string: matchInfo.visitingTeamPic) else { return }
            homeTeamIcon.kf.setImage(with: homeurl)
            visiTeamIcon.kf.setImage(with: visiUrl)
        }
    }
    
    public var liveInfoModel: FootballLiveInfoModel! {
        didSet{
            guard liveInfoModel != nil else { return }
            //guard let matchStatus = liveInfoModel.matchStatus else { return }
            
            switch "1" {
            case "0": // 未开赛
                flatName.text = "未开赛"
                flatName.text = timeStampToMDHHmm(liveInfoModel.matchTime)
            case "1": // 已完成
                
                let muName = NSMutableAttributedString(string: "3   ",
                                                       attributes: [NSAttributedStringKey.font : Font30,
                                                                    NSAttributedStringKey.foregroundColor: ColorE85504])
                let name = NSAttributedString(string: "\(liveInfoModel.minute!)′",
                                              attributes: [NSAttributedStringKey.font : Font15,
                                                           NSAttributedStringKey.foregroundColor: ColorE85504])
                
                let oddName = NSAttributedString(string: "   1",
                                                 attributes: [NSAttributedStringKey.font : Font30,
                                                              NSAttributedStringKey.foregroundColor: ColorE85504])
                
                muName.append(name)
                muName.append(oddName)
                flatName.attributedText = muName
            
                flatOdds.text = "半场 0:0"
            
            case "2": // 取消
                flatName.text = "取消"
            case "4": // 推迟
                flatName.text = "推迟"
                flatOdds.text = timeStampToMDHHmm(liveInfoModel.matchTime)
            case "5": // 暂停
                flatName.text = "暂停"
                
            case "6": // 进行中
                let muName = NSMutableAttributedString(string: "6   ",
                                                       attributes: [NSAttributedStringKey.font : Font30,
                                                                    NSAttributedStringKey.foregroundColor: ColorE85504])
                let name = NSAttributedString(string: "已结束",
                                              attributes: [NSAttributedStringKey.font : Font15])
                
                let oddName = NSAttributedString(string: "   1",
                                                 attributes: [NSAttributedStringKey.font : Font30,
                                                              NSAttributedStringKey.foregroundColor: ColorE85504])
                
                muName.append(name)
                muName.append(oddName)
                flatName.attributedText = muName
                
            default: break
            }
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
    private var resultLabel: UILabel!
    
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
            make.left.equalTo(40 * defaultScale)
            make.height.width.equalTo(40 * defaultScale)
        }
        visiTeamIcon.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(homeTeamIcon)
            make.right.equalTo(-40 * defaultScale)
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
            make.top.height.equalTo(homeTeamIcon)
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
            make.top.equalTo(homeName)
            make.height.equalTo(homeOdds)
            make.left.equalTo(homeName.snp.right)
            make.right.equalTo(visiName.snp.left)
        }
//        resultLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(flatOdds.snp.bottom).offset(8 * defaultScale)
//            make.width.equalTo(flatName)
//            make.height.equalTo(homeOdds)
//            make.left.equalTo(flatName)
//        }
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
        
        resultLabel = getLabel()
        //resultLabel.textColor = ColorE85504
        
        homeTeamIcon = UIImageView()
        homeTeamIcon.image = UIImage(named : "Racecolorfootball")
        
        visiTeamIcon = UIImageView()
        visiTeamIcon.image = UIImage(named : "Racecolorfootball")
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorEAEAEA
        
        self.addSubview(titlelb)
        self.addSubview(homeName)
        self.addSubview(homeOdds)
        self.addSubview(visiName)
        self.addSubview(visiOdds)
        self.addSubview(flatName)
        self.addSubview(flatOdds)
        self.addSubview(resultLabel)
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
