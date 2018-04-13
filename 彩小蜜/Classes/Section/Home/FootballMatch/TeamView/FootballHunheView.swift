//
//  FootballHunheView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballHunheView: UIView {

    public var matchType: FootballMatchType = .胜平负
    
    public var teamInfo: FootballPlayListModel! {
        didSet{
            
            switch matchType {
            case .胜平负:
                guard teamInfo.matchPlays[1].playType == "2" else { break }
                guard teamInfo.matchPlays[1].homeCell != nil else { break }
                let matchPlay = teamInfo.matchPlays[1]
                setText(matchPlay: matchPlay)
            case .让球胜平负:
                guard teamInfo.matchPlays[0].playType == "1" else { break }
                guard teamInfo.matchPlays[0].homeCell != nil else { break }
                let matchPlay = teamInfo.matchPlays[0]
                setText(matchPlay: matchPlay)
            default: break
            }
            
           
        }
    }
    
    private func setText(matchPlay: FootballMatchPlay) {
        homeOdds.text = matchPlay.homeCell.cellName + matchPlay.homeCell.cellOdds
        drawOdds.text = matchPlay.flatCell.cellName + matchPlay.flatCell.cellOdds
        awayOdds.text = matchPlay.visitingCell.cellName + matchPlay.visitingCell.cellOdds
    }
    
    public var delegate: FootballTeamViewDelegate!
    
    
    private var homeOdds: UILabel!
    
    private var drawOdds: UILabel!
    
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
    
    private func changeButState(but: UIButton, isSelected: Bool) {
        if isSelected {
            but.setTitleColor(ColorFFFFFF, for: .normal)
            but.backgroundColor = ColorEA5504
        }else {
            but.setTitleColor(Color787878, for: .normal)
            but.backgroundColor = ColorFFFFFF
        }
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
            make.width.equalTo(55 * defaultScale)
        }
        awayBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeBut)
            make.left.equalTo(lineTwo.snp.right)
            make.right.equalTo(0)
        }
        
        homeOdds.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        drawOdds.snp.makeConstraints { (make) in
            make.left.equalTo(homeOdds.snp.right)
            make.top.bottom.width.equalTo(homeOdds)
        }
        
        awayOdds.snp.makeConstraints { (make) in
            make.left.equalTo(drawOdds.snp.right)
            make.top.bottom.width.equalTo(drawOdds)
            make.right.equalTo(0)
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
        
        homeOdds = initLabel()
        homeOdds.font = Font10
        homeOdds.text = "主胜1.57"
    
        drawOdds = initLabel()
        drawOdds.font = Font10
        drawOdds.text = "平3.6"
        
        awayOdds = initLabel()
        awayOdds.font = Font10
        awayOdds.text = "客胜1.88"
        
        self.addSubview(homeBut)
        self.addSubview(drawBut)
        self.addSubview(awayBut)
        self.addSubview(lineOne)
        self.addSubview(lineTwo)
        
        homeBut.addSubview(homeOdds)
        
        drawBut.addSubview(drawOdds)
        
        awayBut.addSubview(awayOdds)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        
        return lab
    }
    
    @objc private func homeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    @objc private func drawClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    @objc private func awayClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        delegate.selectedItem()
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
