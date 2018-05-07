//
//  FootballTeamView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

var mixNum = 15
var limitNum = 1

protocol FootballTeamViewDelegate {

    func selectedItem() -> Void
    
    func select(teamInfo: FootballPlayListModel) -> Void
    func deSelect(teamInfo: FootballPlayListModel) -> Void
}

extension FootballTeamViewDelegate {
    
    func deSelectedItem() { }
}

class FootballTeamView: UIView , AlertPro{

    public var matchType: FootballMatchType = .胜平负
    
    public var teamInfo: FootballPlayListModel! {
        didSet{
            guard teamInfo != nil else { return }
            let matchPlay = teamInfo.matchPlays[0]
            guard matchPlay.homeCell != nil else { return }
            
            homeName.text = teamInfo.homeTeamAbbr
            homeOdds.text = matchPlay.homeCell.cellName + matchPlay.homeCell.cellOdds
            
            drawOdds.text = matchPlay.flatCell.cellName + matchPlay.flatCell.cellOdds
            
            awayName.text = teamInfo.visitingTeamAbbr
            awayOdds.text = matchPlay.visitingCell.cellName + matchPlay.visitingCell.cellOdds
            
            homeIsSelected(matchPlay.homeCell.isSelected)
            drawIsSelected(matchPlay.flatCell.isSelected)
            awayIsSelected(matchPlay.visitingCell.isSelected)
            
            switch matchType {
            case .胜平负:
                VSLB.text = "VS"
            case .让球胜平负:
                
                
                let matchPlay = teamInfo.matchPlays[0]
                if matchPlay.fixedOdds < 0 {
                    
                    if matchPlay.flatCell.isSelected {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        let att = NSAttributedString(string:" " + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }else {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
                        let att = NSAttributedString(string:" " + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: Color44AE35])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }
                    
                }else if matchPlay.fixedOdds > 0 {
                    if matchPlay.flatCell.isSelected {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        let att = NSAttributedString(string:" +" + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }else {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
                        let att = NSAttributedString(string:" +" + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }
                    
                }
                
            default: break
                
            }
            
        }
    }
    
    public var delegate: FootballTeamViewDelegate!
    
    private var homeName: UILabel!
    private var homeOdds: UILabel!
    private var VSLB: UILabel!
    private var drawOdds: UILabel!
    private var awayName: UILabel!
    private var awayOdds: UILabel!
    
    private var homeBut: UIButton!
    private var drawBut: UIButton!
    private var awayBut: UIButton!
    
    private var lineOne: UIView!
    private var lineTwo: UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineOne.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(1)
            make.right.equalTo(drawBut.snp.left)
        }
        lineTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineOne)
            make.left.equalTo(drawBut.snp.right)
        }
        
        homeBut.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(lineOne.snp.left)
        }
        drawBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeBut)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(65 * defaultScale)
        }
        awayBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeBut)
            make.left.equalTo(lineTwo.snp.right)
            make.right.equalTo(0)
        }
        
        homeName.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(homeOdds)
        }
        homeOdds.snp.makeConstraints { (make) in
            make.left.right.equalTo(homeName)
            make.top.equalTo(homeName.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
        VSLB.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.height.equalTo(homeName)
        }
        drawOdds.snp.makeConstraints { (make) in
            make.left.right.equalTo(VSLB)
            make.bottom.height.equalTo(homeOdds)
        }
        
        awayName.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.height.equalTo(homeName)
        }
        awayOdds.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.height.equalTo(homeOdds)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 0.5
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        lineOne = UIView()
        lineOne.backgroundColor = ColorF4F4F4
        lineTwo = UIView()
        lineTwo.backgroundColor = ColorF4F4F4
        
        homeBut = UIButton(type: .custom)
        homeBut.backgroundColor = ColorFFFFFF
        homeBut.addTarget(self, action: #selector(homeClicked(_:)), for: .touchUpInside)
        homeBut.isSelected = false
        
        drawBut = UIButton(type: .custom)
        drawBut.backgroundColor = ColorFFFFFF
        drawBut.addTarget(self, action: #selector(drawClicked(_:)), for: .touchUpInside)
        
        awayBut = UIButton(type: .custom)
        awayBut.backgroundColor = ColorFFFFFF
        awayBut.addTarget(self, action: #selector(awayClicked(_:)), for: .touchUpInside)
        
        homeName = initLabel()
        homeName.textColor = Color505050
        homeName.text = "[5]沙尔克"
        
        homeOdds = initLabel()
        homeOdds.font = Font12
        homeOdds.text = "主胜1.57"
        
        VSLB = initLabel()
        VSLB.textColor = Color787878
        VSLB.text = "VS"
        
        drawOdds = initLabel()
        drawOdds.font = Font12
        drawOdds.text = "平3.6"
        
        awayName = initLabel()
        awayName.textColor = Color505050
        awayName.text = "[5]沙尔克"
        
        awayOdds = initLabel()
        awayOdds.font = Font12
        awayOdds.text = "客胜1.88"
        
        self.addSubview(homeBut)
        self.addSubview(drawBut)
        self.addSubview(awayBut)
        self.addSubview(lineOne)
        self.addSubview(lineTwo)
        
        homeBut.addSubview(homeName)
        homeBut.addSubview(homeOdds)
        
        drawBut.addSubview(VSLB)
        drawBut.addSubview(drawOdds)
        
        awayBut.addSubview(awayName)
        awayBut.addSubview(awayOdds)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font14
        lab.textColor = Color787878
        lab.textAlignment = .center
        
        return lab
    }
    
    @objc private func homeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectItem(sender.isSelected)
        let matchPlay = teamInfo.matchPlays[0]
        guard matchPlay.isShow == true else { return }
        matchPlay.homeCell.isSelected = sender.isSelected
        homeIsSelected(sender.isSelected)
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    @objc private func drawClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectItem(sender.isSelected)
        let matchPlay = teamInfo.matchPlays[0]
        guard matchPlay.isShow == true else { return }
        matchPlay.flatCell.isSelected = sender.isSelected
        drawIsSelected(sender.isSelected)
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    @objc private func awayClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectItem(sender.isSelected)
        let matchPlay = teamInfo.matchPlays[0]
        guard matchPlay.isShow == true else { return }
        matchPlay.visitingCell.isSelected = sender.isSelected
        awayIsSelected(sender.isSelected)
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    
    private func homeIsSelected(_ isSelected: Bool) {
        
        if isSelected {
            homeBut.backgroundColor = ColorEA5504
            homeName.textColor = ColorFFFFFF
            homeOdds.textColor = ColorFFFFFF
        }else {
            homeBut.backgroundColor = ColorFFFFFF
            homeName.textColor = Color505050
            homeOdds.textColor = Color787878
        }
        homeBut.isSelected = isSelected
    }
    private func drawIsSelected(_ isSelected: Bool) {
        if isSelected {
            drawBut.backgroundColor = ColorEA5504
            VSLB.textColor = ColorFFFFFF
            drawOdds.textColor = ColorFFFFFF
        }else {
            drawBut.backgroundColor = ColorFFFFFF
            
            drawOdds.textColor = Color787878
            switch matchType {
            case .胜平负:
                VSLB.textColor = Color787878
            case .让球胜平负:
               
                let matchPlay = teamInfo.matchPlays[0]
                
                if matchPlay.fixedOdds < 0 {
                    
                    if matchPlay.flatCell.isSelected {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        let att = NSAttributedString(string:" " + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }else {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
                        let att = NSAttributedString(string:" " + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: Color44AE35])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }
                    
                }else if matchPlay.fixedOdds > 0 {
                    if matchPlay.flatCell.isSelected {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        let att = NSAttributedString(string:" +" + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }else {
                        let vsAtt = NSMutableAttributedString(string: "VS", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
                        let att = NSAttributedString(string:" +" + String(matchPlay.fixedOdds), attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                        vsAtt.append(att)
                        VSLB.attributedText = vsAtt
                    }
                    
                }
            default: break
            }
            
        }
        drawBut.isSelected = isSelected
    }
    private func awayIsSelected(_ isSelected: Bool) {
        if isSelected {
            awayBut.backgroundColor = ColorEA5504
            awayName.textColor = ColorFFFFFF
            awayOdds.textColor = ColorFFFFFF
        }else {
            awayBut.backgroundColor = ColorFFFFFF
            awayName.textColor = Color505050
            awayOdds.textColor = Color787878
        }
        awayBut.isSelected = isSelected
    }
    
    @objc private func selectItem(_ isSelected: Bool) {
        
        if isSelected == true {
            let matchPlay = teamInfo.matchPlays[0]
            guard matchPlay.homeCell != nil else { return }
            guard matchPlay.homeCell.isSelected == false,
                matchPlay.flatCell.isSelected == false,
                matchPlay.visitingCell.isSelected == false else { return }
            
            guard limitNum <= mixNum else {
                homeIsSelected(false)
                drawIsSelected(false)
                awayIsSelected(false)
                showHUD(message: "最多选择\(mixNum)场比赛")
                return }
            limitNum += 1
            delegate.select(teamInfo: self.teamInfo)
            
        }else {
            guard homeBut.isSelected == false, drawBut.isSelected == false, awayBut.isSelected == false else { return }
            guard delegate != nil else { return }
            limitNum -= 1
            delegate.deSelect(teamInfo: self.teamInfo)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
