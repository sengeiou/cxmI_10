//
//  FootballHunheView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballHunheViewDelegate {
    func didSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel, index: IndexPath) -> Void
    func didDeSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel, index: IndexPath) -> Void
}

class FootballHunheView: UIView {

    public var matchType: FootballMatchType = .胜平负
    
    public var matchInfo : FootballMatchPlay! {
        didSet{
            guard matchInfo != nil else { return }
            switch matchType {
            case .胜平负:
                guard matchInfo.isShow == true else {
                    changeButUserEnabled(enable: false)
                    
                    return }
                
                changeButUserEnabled(enable: true)
                setText(matchPlay: matchInfo)
                changeViewBorderColor(single: matchInfo.single)
                changeButState(but: homeBut, isSelected: matchInfo.homeCell.isSelected)
                changeButState(but: drawBut, isSelected: matchInfo.flatCell.isSelected)
                changeButState(but: awayBut, isSelected: matchInfo.visitingCell.isSelected)
            case .让球胜平负:
                guard matchInfo.isShow == true else {
                    changeButUserEnabled(enable: false)
                    return }
                
                changeButUserEnabled(enable: true)
                
                setText(matchPlay: matchInfo)
                changeViewBorderColor(single: matchInfo.single)
                changeButState(but: homeBut, isSelected: matchInfo.homeCell.isSelected)
                changeButState(but: drawBut, isSelected: matchInfo.flatCell.isSelected)
                changeButState(but: awayBut, isSelected: matchInfo.visitingCell.isSelected)
                
                matchInfo.homeCell.isRang = true
                matchInfo.flatCell.isRang = true
                matchInfo.visitingCell.isRang = true
            default: break
            }
        }
    }
    
    public var teamInfo: FootballPlayListModel! {
        didSet{
            
//            for match in teamInfo.matchPlays {
//                if match.playType == "2" , match.homeCell != nil {
//                    //let matchPlay = teamInfo.matchPlays[1]
//                    setText(matchPlay: match)
//                    changeViewBorderColor(single: match.single)
//                    changeButState(but: homeBut, isSelected: match.homeCell.isSelected)
//                    changeButState(but: drawBut, isSelected: match.flatCell.isSelected)
//                    changeButState(but: awayBut, isSelected: match.visitingCell.isSelected)
//                }else if match.playType == "1" , match.homeCell != nil {
//                    setText(matchPlay: match)
//                    changeViewBorderColor(single: match.single)
//                    changeButState(but: homeBut, isSelected: match.homeCell.isSelected)
//                    changeButState(but: drawBut, isSelected: match.flatCell.isSelected)
//                    changeButState(but: awayBut, isSelected: match.visitingCell.isSelected)
//
//                    match.homeCell.isRang = true
//                    match.flatCell.isRang = true
//                    match.visitingCell.isRang = true
//                }
//
//            }
//
//
//
//            switch matchType {
//            case .胜平负:
//                guard teamInfo.matchPlays[1].playType == "2" else { break }
//                guard teamInfo.matchPlays[1].homeCell != nil else { break }
//                let matchPlay = teamInfo.matchPlays[1]
//                setText(matchPlay: matchPlay)
//                changeViewBorderColor(single: matchPlay.single)
//                changeButState(but: homeBut, isSelected: matchPlay.homeCell.isSelected)
//                changeButState(but: drawBut, isSelected: matchPlay.flatCell.isSelected)
//                changeButState(but: awayBut, isSelected: matchPlay.visitingCell.isSelected)
//            case .让球胜平负:
//                guard teamInfo.matchPlays[0].playType == "1" else { break }
//                guard teamInfo.matchPlays[0].homeCell != nil else { break }
//                let matchPlay = teamInfo.matchPlays[0]
//                setText(matchPlay: matchPlay)
//                changeViewBorderColor(single: matchPlay.single)
//                changeButState(but: homeBut, isSelected: matchPlay.homeCell.isSelected)
//                changeButState(but: drawBut, isSelected: matchPlay.flatCell.isSelected)
//                changeButState(but: awayBut, isSelected: matchPlay.visitingCell.isSelected)
//
//                matchPlay.homeCell.isRang = true
//                matchPlay.flatCell.isRang = true
//                matchPlay.visitingCell.isRang = true
//            default: break
//            }
            
           
        }
    }
    
    public var index : IndexPath!
    
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
        
        
        matchInfo.homeCell.isSelected = false
        matchInfo.flatCell.isSelected = false
        matchInfo.visitingCell.isSelected = false
        
        for cell in teamInfo.selectedHunhe {
            cell.isSelected = false
        }
        
        teamInfo.selectedHunhe.removeAll()
        
//        switch matchType {
//        case .胜平负:
//            guard teamInfo.matchPlays[1].playType == "2" else { break }
//            guard teamInfo.matchPlays[1].homeCell != nil else { break }
//    
//            teamInfo.matchPlays[1].homeCell.isSelected = false
//            teamInfo.matchPlays[1].flatCell.isSelected = false
//            teamInfo.matchPlays[1].visitingCell.isSelected = false
//
//        case .让球胜平负:
//            guard teamInfo.matchPlays[0].playType == "1" else { break }
//            guard teamInfo.matchPlays[0].homeCell != nil else { break }
//
//            teamInfo.matchPlays[0].homeCell.isSelected = false
//            teamInfo.matchPlays[0].flatCell.isSelected = false
//            teamInfo.matchPlays[0].visitingCell.isSelected = false
//
//        default: break
//        }
        
    }
    private func changeButUserEnabled(enable: Bool) {
        if enable {
            homeBut.isUserInteractionEnabled = true
            drawBut.isUserInteractionEnabled = true
            awayBut.isUserInteractionEnabled = true
        }else {
            homeBut.isUserInteractionEnabled = false
            drawBut.isUserInteractionEnabled = false
            awayBut.isUserInteractionEnabled = false
            homeBut.setTitle("未开售", for: .normal)
            drawBut.setTitle("未开售", for: .normal)
            awayBut.setTitle("未开售", for: .normal)
            changeViewBorderColor(single: false)
        }
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
            addHomeCell(true)
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
            
        }else {
            addHomeCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
        }
    }
    @objc private func drawClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        if sender.isSelected {
            addFlatCell(true)
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
            
        }else {
            addFlatCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
        }
    }
    @objc private func awayClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        guard delegate != nil else { return }
        if sender.isSelected {
            addVisiCell(true)
            delegate.didSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
            
        }else {
            addVisiCell(false)
            delegate.didDeSelectedHunHeView(view: self, teamInfo: teamInfo, index: index)
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
        
        guard matchInfo.homeCell != nil else { return }
        
        if add {
            teamInfo.selectedHunhe.append(matchInfo.homeCell)
        }else {
            teamInfo.selectedHunhe.remove(matchInfo.homeCell)
        }
        matchInfo.homeCell.isSelected = add
        
        
//        guard teamInfo.matchPlays[index].homeCell != nil else { return }
//
//        if add {
//            teamInfo.selectedHunhe.append(teamInfo.matchPlays[index].homeCell)
//        }else {
//            teamInfo.selectedHunhe.remove(teamInfo.matchPlays[index].homeCell)
//        }
//        teamInfo.matchPlays[index].homeCell.isSelected = add
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
        guard matchInfo.flatCell != nil else { return }
        
        if add {
            teamInfo.selectedHunhe.append(matchInfo.flatCell)
        }else {
            teamInfo.selectedHunhe.remove(matchInfo.flatCell)
        }
        matchInfo.flatCell.isSelected = add
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
      
        guard matchInfo.visitingCell != nil else { return }
        
        if add {
            teamInfo.selectedHunhe.append(matchInfo.visitingCell)
        }else {
            teamInfo.selectedHunhe.remove(matchInfo.visitingCell)
        }
        matchInfo.visitingCell.isSelected = add
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
