//
//  BasketBallHunheView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/7/10.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

protocol BasketBallHunheViewDelegate {
    func didSelectedHunHeView(view: BasketBallHunheView, teamInfo: BasketballListModel, index: IndexPath) -> Void
    func didDeSelectedHunHeView(view: BasketBallHunheView, teamInfo: BasketballListModel, index: IndexPath) -> Void
}

class BasketBallHunheView: UIView {
    
    public var matchType: BasketballPlayType = .胜负
    
    public var matchInfo : BasketbalPlayInfo! {
        didSet{
            guard matchInfo != nil else { return }
            switch matchType {
            case . 胜负:
                guard matchInfo.isShow == true else {
                    changeButUserEnabled(enable: false)
                    return }
                
                changeButUserEnabled(enable: true)
                setText(matchPlay: matchInfo)
                changeViewBorderColor(single: matchInfo.single)
                changeButState(but: leftBut, isSelected: matchInfo.homeCell.isSelected.asObserver().hasObservers)
                changeButState(but: rightBut, isSelected: matchInfo.visitingCell.isSelected.asObserver().hasObservers)
            case .让分胜负:
                guard matchInfo.isShow == true else {
                    changeButUserEnabled(enable: false)
                    return }
                
                changeButUserEnabled(enable: true)
                
//                setText(matchPlay: matchInfo)
                leftBut.setAttributedTitle(getAttributedStringSe(cellName: matchInfo.visitingCell.cellName, cellOdds: matchInfo.visitingCell.cellOdds, fixedOdds: matchInfo.fixedOdds), for: .normal)
                rightBut.setAttributedTitle(getAttributedStringSe(cellName: matchInfo.visitingCell.cellName, cellOdds: matchInfo.visitingCell.cellOdds, fixedOdds: matchInfo.fixedOdds), for: .normal)
                changeViewBorderColor(single: matchInfo.single)
                changeButState(but: leftBut, isSelected: matchInfo.homeCell.isSelected.asObserver().hasObservers)
                changeButState(but: rightBut, isSelected: matchInfo.visitingCell.isSelected.asObserver().hasObservers)
                
                matchInfo.homeCell.isRang = true
                matchInfo.visitingCell.isRang = true
            case .大小分:
                guard matchInfo.isShow == true else {
                    changeButUserEnabled(enable: false)
                    return }
                
                changeButUserEnabled(enable: true)
                
                setText(matchPlay: matchInfo)
                changeViewBorderColor(single: matchInfo.single)
                changeButState(but: leftBut, isSelected: matchInfo.homeCell.isSelected.asObserver().hasObservers)
                changeButState(but: rightBut, isSelected: matchInfo.visitingCell.isSelected.asObserver().hasObservers)
            default: break
            }
        }
    }
    
    public var teamInfo: BasketballListModel! {
        didSet{
            
            
        }
    }
    
    
    
    public var index : IndexPath!
    
    public var delegate: BasketBallHunheViewDelegate!
    
    private var leftBut: UIButton!
    private var rightBut: UIButton!

    private var lineOne: UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
    }
    
    private func getAttributedStringSe(cellName : String, cellOdds : String, fixedOdds : String? = nil) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedString.Key.foregroundColor: Color505050,
                                                                 NSAttributedString.Key.font : Font12])
        
        if let fix = fixedOdds {
            let fixAtt = NSAttributedString(string: "(\(fix))", attributes: [NSAttributedString.Key.foregroundColor : ColorEA5504])
            cellNameAtt.append(fixAtt)
        }
        
        let cellOddsAtt = NSAttributedString(string: "\n\(cellOdds)",
            attributes: [NSAttributedString.Key.foregroundColor: Color787878,
                         NSAttributedString.Key.font: Font14])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
    
    
    public func backSelectedState(){
        changeButState(but: leftBut, isSelected: false)
        changeButState(but: rightBut, isSelected: false)
        
        
        matchInfo.homeCell.isSelected.onNext(false)
        matchInfo.visitingCell.isSelected.onNext(false)
        
        for cell in teamInfo.selectedHunhe {
            cell.isSelected.onNext(false)
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
            leftBut.isUserInteractionEnabled = true
            rightBut.isUserInteractionEnabled = true
            rightBut.isUserInteractionEnabled = true
        }else {
            
            leftBut.isUserInteractionEnabled = false
            rightBut.isUserInteractionEnabled = false
            leftBut.setTitle("未开售", for: .normal)
            rightBut.setTitle("未开售", for: .normal)

            changeViewBorderColor(single: false)
            changeButState(but: leftBut, isSelected: false)
            changeButState(but: rightBut, isSelected: false)
        }
    }
    
    private func changeButState(but: UIButton, isSelected: Bool) {
        if isSelected {
            but.setTitleColor(ColorFFFFFF, for: .normal)
            but.backgroundColor = ColorEA5504
        }else {
            but.setTitleColor(Color505050, for: .normal)
            but.backgroundColor = ColorFFFFFF
        }
        but.isSelected = isSelected
    }
    
    private func setText(matchPlay: BasketbalPlayInfo) {
        leftBut.setTitle(matchPlay.visitingCell.cellName + "\n" + matchPlay.visitingCell.cellOdds, for: .normal)
        rightBut.setTitle(matchPlay.homeCell.cellName + "\n" + matchPlay.homeCell.cellOdds, for: .normal)
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
        
        leftBut.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(self.frame.size.width * 0.5 - 0.5 * defaultScale)
        }
        
        lineOne.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(1 * defaultScale)
            make.right.equalTo(leftBut.snp.right)
        }
        
        rightBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(leftBut)
            make.left.equalTo(lineOne.snp.right)
            make.width.equalTo(self.frame.size.width * 0.5 - 0.5 * defaultScale)
        }
        
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        lineOne = UIView()
        lineOne.backgroundColor = ColorF4F4F4
        leftBut = getButton()
        leftBut.addTarget(self, action: #selector(leftClicked(_:)), for: .touchUpInside)
        leftBut.titleLabel?.numberOfLines = 0
        leftBut.titleLabel?.textAlignment = .center
        
        rightBut = getButton()
        rightBut.addTarget(self, action: #selector(rightClicked(_:)), for: .touchUpInside)
        rightBut.titleLabel?.numberOfLines = 0
        rightBut.titleLabel?.textAlignment = .center
        
        self.addSubview(leftBut)
        self.addSubview(rightBut)
        self.addSubview(lineOne)
        
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
        but.titleLabel?.font = Font12
        but.setTitleColor(Color787878, for: .normal)
        but.contentHorizontalAlignment = .center
        return but
    }
    
    
    
    @objc private func leftClicked(_ sender: UIButton) {
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
    @objc private func rightClicked(_ sender: UIButton) {
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
        case .胜负:
            index = 1
        case .让分胜负:
            index = 0
        default: break
        }
        
        guard matchInfo.homeCell != nil else { return }
        
        if add {
            teamInfo.selectedHunhe.append(matchInfo.homeCell)
        }else {
//            teamInfo.selectedHunhe.remove(matchInfo.homeCell)
        }
        matchInfo.homeCell.isSelected.onNext(add)
        
        
        //        guard teamInfo.matchPlays[index].homeCell != nil else { return }
        //
        //        if add {
        //            teamInfo.selectedHunhe.append(teamInfo.matchPlays[index].homeCell)
        //        }else {
        //            teamInfo.selectedHunhe.remove(teamInfo.matchPlays[index].homeCell)
        //        }
        //        teamInfo.matchPlays[index].homeCell.isSelected = add
    }
    
    
    private func addVisiCell(_ add : Bool) {
        var index = 0
        switch matchType {
        case .胜负:
            index = 1
        case .让分胜负:
            index = 0
        default: break
        }
        
        guard matchInfo.visitingCell != nil else { return }
        
        if add {
            teamInfo.selectedHunhe.append(matchInfo.visitingCell)
        }else {
//            teamInfo.selectedHunhe.remove(matchInfo.visitingCell)
        }
        matchInfo.visitingCell.isSelected.onNext(add)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


