//
//  FootballTwoOneView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol FootballTwoOneViewDelegate {
    func didSelectedTwoOneView(view:FootballTwoOneView, teamInfo: FootballPlayListModel ) -> Void
    func didDeSelectedTwoOneView(view:FootballTwoOneView, teamInfo: FootballPlayListModel ) -> Void
}

class FootballTwoOneView: UIView {

    public var teamInfo : FootballPlayListModel! {
        didSet{
            let matchPlay = teamInfo.matchPlays[0]
            guard let homeCell = matchPlay.homeCell else { return }
            guard let visiCell = matchPlay.visitingCell else { return }
            
            
            homeBut.setTitle(homeCell.cellOdds, for: .normal)
            visitingBut.setTitle(visiCell.cellOdds, for: .normal)
            
            changeButState(but: homeBut, isSelected: homeCell.isSelected)
            changeButState(but: visitingBut, isSelected: visiCell.isSelected)
        }
    }
    
    public var delegate : FootballTwoOneViewDelegate!
    
    private var homeBut : UIButton!
    private var visitingBut: UIButton!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    private func changeButState(but: UIButton, isSelected : Bool) {
        if isSelected == true {
            but.setTitleColor(ColorFFFFFF, for: .normal)
            but.backgroundColor = ColorEA5504
        }else {
            but.setTitleColor(Color787878, for: .normal)
            but.backgroundColor = ColorFFFFFF
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        homeBut.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(visitingBut)
        }
        visitingBut.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.left.equalTo(homeBut.snp.right).offset(30 * defaultScale)
        }
    }
    
    private func initSubview() {
        homeBut = UIButton(type: .custom)
        homeBut.setTitleColor(Color787878, for: .normal)
        homeBut.titleLabel?.font = Font13
        homeBut.layer.borderWidth = 0.3
        homeBut.layer.borderColor = Color787878.cgColor
        homeBut.addTarget(self, action: #selector(homeClicked(_:)), for: .touchUpInside)
        
        visitingBut = UIButton(type: .custom)
        visitingBut.setTitleColor(Color787878, for: .normal)
        visitingBut.titleLabel?.font = Font13
        visitingBut.layer.borderWidth = 0.3
        visitingBut.layer.borderColor = Color787878.cgColor
        visitingBut.addTarget(self, action: #selector(visitingClicked(_:)), for: .touchUpInside)
        
        self.addSubview(homeBut)
        self.addSubview(visitingBut)
    }
    
    @objc private func homeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        changeButState(but: sender, isSelected: sender.isSelected)
        
        guard delegate != nil else { return }
        if sender.isSelected {
            delegate.didSelectedTwoOneView(view: self, teamInfo: teamInfo)
        }else {
            delegate.didDeSelectedTwoOneView(view: self, teamInfo: teamInfo)
        }
    }
    @objc private func visitingClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeButState(but: sender, isSelected: sender.isSelected)
        
        guard delegate != nil else { return }
        if sender.isSelected {
            delegate.didSelectedTwoOneView(view: self, teamInfo: teamInfo)
        }else {
            delegate.didDeSelectedTwoOneView(view: self, teamInfo: teamInfo)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
