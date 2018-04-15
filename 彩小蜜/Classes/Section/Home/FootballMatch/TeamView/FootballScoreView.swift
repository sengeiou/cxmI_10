//
//  FootballScoreView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//  比分，半全场，

import UIKit

protocol FootballScoreViewDelegate {
    /// 点击总比分
    func didTipScoreView(scoreView: FootballScoreView, teamInfo : FootballPlayListModel) -> Void
}

class FootballScoreView: UIView {

    
    public var teamInfo : FootballPlayListModel! {
        didSet{
            switch matchType {
            case .比分:
                if teamInfo.selectedScore != nil, teamInfo.selectedScore.isEmpty == false {
                    changeViewState(isSelected: true )
                }else {
                    changeViewState(isSelected: false)
                }
            case .半全场:
                if teamInfo.selectedBan != nil, teamInfo.selectedBan.isEmpty == false {
                    changeViewState(isSelected: true )
                }else {
                    changeViewState(isSelected: false)
                }
            case .混合过关:
                if teamInfo.selectedHunhe.isEmpty == false {
                    changeViewState(isSelected: true )
                }else {
                    changeViewState(isSelected: false)
                }
            default: break
                
            }
        }
    }
    // 比分
    public var selectedCells : [FootballPlayCellModel]! {
        didSet{
            if selectedCells.isEmpty == false {
                changeViewState(isSelected: true )
            }else {
                changeViewState(isSelected: false)
            }
        }
    }
    
    // 半全场
    public var selectedCellList: [FootballPlayCellModel]! {
        didSet{
            if selectedCellList.isEmpty == false {
                changeViewState(isSelected: true )
            }else {
                changeViewState(isSelected: false)
            }
        }
    }
    
    public var canAdd : Bool = true 
    
    public var matchType : FootballMatchType! {
        didSet{
            switch matchType {
            case .比分:
                titlelb.text = "点击进行比分投注"
            case .半全场:
                titlelb.text = "点击进行半全场投注"
            case .混合过关:
                titlelb.text = "点击进行混合过关投注"
            default: break
                
            }
        }
    }
    
    public var delegate : FootballScoreViewDelegate!
    
    private var titlelb: UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        selectedCells = [FootballPlayCellModel]()
        selectedCellList = [FootballPlayCellModel]()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titlelb.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    private func initSubview() {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = Color9F9F9F.cgColor
        
        titlelb = UILabel()
        titlelb.font = Font12
        titlelb.textColor = Color9F9F9F
        titlelb.textAlignment = .center
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(selfClicked))
        
        self.addGestureRecognizer(tap)
        self.addSubview(titlelb)
  
    }
    
    private func changeViewState(isSelected: Bool) {
        if isSelected == true {
            self.backgroundColor = ColorEA5504
            self.titlelb.textColor = ColorFFFFFF
            switch matchType {
            case .比分:
                changeScoreView(list: self.teamInfo.selectedScore)
            case .半全场:
                changeBanView(list: self.teamInfo.selectedBan)
            case .混合过关:
                changeHunheView(list: self.teamInfo.selectedHunhe)
            default: break
                
            }
        }else {
            self.backgroundColor = ColorFFFFFF
            self.titlelb.textColor = Color9F9F9F
            switch matchType {
            case .比分:
                titlelb.text = "点击进行比分投注"
            case .半全场:
                titlelb.text = "点击进行半全场投注"
            case .混合过关:
                titlelb.text = "点击进行混合过关投注"
            default: break
            }
        }
    }
    
    private func changeBanView(list : [FootballPlayCellModel]) {
        var title = ""
        for cell in list {
            title += cell.cellName + " "
        }
        
        titlelb.text = title
    }
    private func changeScoreView(list : [FootballPlayCellModel]) {
        var title = ""
        for cell in list {
            title += cell.cellOdds + " "
        }
        
        titlelb.text = title
    }
    private func changeHunheView(list : [FootballPlayCellModel]) {
        var title = ""
        for cell in list {
            title += cell.cellOdds + " "
        }
        titlelb.text = title
    }
    
    
    public func backSelectedState() {
       
        changeViewState(isSelected: false)
        for cell in selectedCells {
            cell.isSelected = false
        }
    }
    
    @objc private func selfClicked() {
        guard delegate != nil else { return }
        delegate.didTipScoreView(scoreView: self, teamInfo: self.teamInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
