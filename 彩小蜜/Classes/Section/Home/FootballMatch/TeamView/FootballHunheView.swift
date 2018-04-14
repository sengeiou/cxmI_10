//
//  FootballHunheView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballHunheViewDelegate {
    func didSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel) -> Void
    func didDeSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel) -> Void
}

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
                changeViewBorderColor(single: matchPlay.single)
                changeButState(but: homeBut, isSelected: matchPlay.homeCell.isSelected)
                changeButState(but: drawBut, isSelected: matchPlay.flatCell.isSelected)
                changeButState(but: awayBut, isSelected: matchPlay.visitingCell.isSelected)
            case .让球胜平负:
                guard teamInfo.matchPlays[0].playType == "1" else { break }
                guard teamInfo.matchPlays[0].homeCell != nil else { break }
                let matchPlay = teamInfo.matchPlays[0]
                setText(matchPlay: matchPlay)
                changeViewBorderColor(single: matchPlay.single)
                changeButState(but: homeBut, isSelected: matchPlay.homeCell.isSelected)
                changeButState(but: drawBut, isSelected: matchPlay.flatCell.isSelected)
                changeButState(but: awayBut, isSelected: matchPlay.visitingCell.isSelected)
            default: break
            }
            
           
        }
    }
    
    
    public var delegate: FootballHunheViewDelegate!
    
    private var homeBut: UIButton!
    private var drawBut: UIButton!
    private var awayBut: UIButton!
    
    private var lineOne: UIView!
    private var lineTwo: UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
    }
    
    public func backSelectedState(){
        changeButState(but: homeBut, isSelected: false)
        changeButState(but: drawBut, isSelected: false)
        changeButState(but: awayBut, isSelected: false)
    }
    private func changeButState(but: UIButton, isSelected: Bool) {
        if isSelected {
            but.setTitleColor(ColorFFFFFF, for: .normal)
            but.backgroundColor = ColorEA5504
        }else {
            but.setTitleColor(Color787878, for: .normal)
            but.backgroundColor = ColorFFFFFF
        }
        but.isSelected = isSelected
    }
    private func setText(matchPlay: FootballMatchPlay) {
        homeBut.setTitle(matchPlay.homeCell.cellName + matchPlay.homeCell.cellOdds, for: .normal)
        drawBut.setTitle(matchPlay.flatCell.cellName + matchPlay.flatCell.cellOdds, for: .normal)
        awayBut.setTitle(matchPlay.visitingCell.cellName + matchPlay.visitingCell.cellOdds, for: .normal)
    }
    private func changeViewBorderColor(single : Bool) {
        if single {
            self.layer.borderColor = ColorEA5504.cgColor
        }else {
            self.layer.borderColor = ColorC8C8C8.cgColor
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
    
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        lineOne = UIView()
        lineOne.backgroundColor = ColorF4F4F4
        lineTwo = UIView()
        lineTwo.backgroundColor = ColorF4F4F4
        
        homeBut = getButton()
        homeBut.addTarget(self, action: #selector(homeClicked(_:)), for: .touchUpInside)
        
        drawBut = getButton()
        drawBut.addTarget(self, action: #selector(drawClicked(_:)), for: .touchUpInside)
        
        awayBut = getButton()
        awayBut.addTarget(self, action: #selector(awayClicked(_:)), for: .touchUpInside)
        
        self.addSubview(homeBut)
        self.addSubview(drawBut)
        self.addSubview(awayBut)
        self.addSubview(lineOne)
        self.addSubview(lineTwo)
        
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        
        return lab
    }
    
    private func getButton() -> UIButton {
        let but = UIButton(type: .custom)
        but.backgroundColor = ColorFFFFFF
        but.titleLabel?.font = Font10
        but.setTitleColor(Color787878, for: .normal)
        but.contentHorizontalAlignment = .center
        return but
    }
    
    
    
    @objc private func homeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        
        guard delegate != nil else { return }
        if sender.isSelected {
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo)
            addHomeCell(true)
        }else {
            addHomeCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo)
        }
    }
    @objc private func drawClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        if sender.isSelected {
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo)
            addFlatCell(true)
        }else {
            addFlatCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo)
        }
    }
    @objc private func awayClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        if sender.isSelected {
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo)
            addVisiCell(true)
        }else {
            addVisiCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo)
        }
    }
    
    
    private func addHomeCell(_ add : Bool) {
        var index = 0
        switch matchType {
        case .胜平负:
            index = 1
        case .让球胜平负:
            index = 0
        default: break
        }
        guard teamInfo.matchPlays[index].playType == "2" else { return }
        guard teamInfo.matchPlays[index].homeCell != nil else { return }
        let matchPlay = teamInfo.matchPlays[index]
        if add {
            teamInfo.selectedHunhe.append(matchPlay.homeCell)
        }else {
            teamInfo.selectedHunhe.remove(matchPlay.homeCell)
        }
    }
    
    private func addFlatCell(_ add : Bool) {
        var index = 0
        switch matchType {
        case .胜平负:
            index = 1
        case .让球胜平负:
            index = 0
        default: break
        }
        guard teamInfo.matchPlays[index].playType == "2" else { return }
        guard teamInfo.matchPlays[index].homeCell != nil else { return }
        let matchPlay = teamInfo.matchPlays[index]
        if add {
            teamInfo.selectedHunhe.append(matchPlay.flatCell)
        }else {
            teamInfo.selectedHunhe.remove(matchPlay.flatCell)
        }
    }
    private func addVisiCell(_ add : Bool) {
        var index = 0
        switch matchType {
        case .胜平负:
            index = 1
        case .让球胜平负:
            index = 0
        default: break
        }
        guard teamInfo.matchPlays[index].playType == "2" else { return }
        guard teamInfo.matchPlays[index].homeCell != nil else { return }
        let matchPlay = teamInfo.matchPlays[index]
        if add {
            teamInfo.selectedHunhe.append(matchPlay.visitingCell)
        }else {
            teamInfo.selectedHunhe.remove(matchPlay.visitingCell)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
