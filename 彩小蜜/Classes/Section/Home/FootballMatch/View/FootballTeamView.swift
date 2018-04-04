//
//  FootballTeamView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

var mixNum = 3
var limitNum = 1

protocol FootballTeamViewDelegate {
    func select(teamInfo: FootballPlayListModel) -> Void
    func deSelect(teamInfo: FootballPlayListModel) -> Void
}


class FootballTeamView: UIView , AlertPro{

    public var teamInfo: FootballPlayListModel! {
        didSet{
            homeName.text = teamInfo.homeTeamAbbr
            homeOdds.text = teamInfo.homeCell.cellName + teamInfo.homeCell.cellOdds
            
            drawOdds.text = teamInfo.flatCell.cellName + teamInfo.flatCell.cellOdds
            
            awayName.text = teamInfo.visitingTeamAbbr
            awayOdds.text = teamInfo.visitingCell.cellName + teamInfo.visitingCell.cellOdds
            
            homeIsSelected(teamInfo.homeCell.isSelected)
            drawIsSelected(teamInfo.flatCell.isSelected)
            awayIsSelected(teamInfo.visitingCell.isSelected)
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
            make.width.equalTo(60)
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
        homeOdds.text = "主胜1.57"
        
        VSLB = initLabel()
        VSLB.textColor = Color505050
        VSLB.text = "VS"
        
        drawOdds = initLabel()
        drawOdds.text = "平3.6"
        
        awayName = initLabel()
        awayName.textColor = Color505050
        awayName.text = "[5]沙尔克"
        
        awayOdds = initLabel()
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
        teamInfo.homeCell.isSelected = sender.isSelected
        homeIsSelected(sender.isSelected)
    }
    @objc private func drawClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectItem(sender.isSelected)
        teamInfo.flatCell.isSelected = sender.isSelected
        drawIsSelected(sender.isSelected)
    }
    @objc private func awayClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectItem(sender.isSelected)
        teamInfo.visitingCell.isSelected = sender.isSelected
        awayIsSelected(sender.isSelected)
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
            VSLB.textColor = Color505050
            drawOdds.textColor = Color787878
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
    
    private func selectItem(_ isSelected: Bool) {
        
        if isSelected == true {
            guard teamInfo.homeCell.isSelected == false,
                teamInfo.flatCell.isSelected == false,
                teamInfo.visitingCell.isSelected == false else { return }
            
            guard delegate != nil else { return }
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
