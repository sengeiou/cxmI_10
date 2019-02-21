//
//  LotteryCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let MaxTime = 150

protocol LotteryCellDelegate {
    func didTipCollection(cell : LotteryCell, model : LotteryResultModel, selected: Bool) -> Void
}

extension LotteryCell: LotteryProtocol {
    
}

class LotteryCell: UITableViewCell {

    public var resultModel : LotteryResultModel! {
        didSet{
            guard resultModel != nil else { return }
            titlelb.text = resultModel.changci + resultModel.leagueAddr + resultModel.matchTime
            homeTeamlb.text = resultModel.homeTeamAbbr
            visiTeamlb.text = resultModel.visitingTeamAbbr
            changeCollectionSelected(selected: resultModel.isCollect)

            guard resultModel.homeTeamLogo != nil, resultModel.visitingTeamLogo != nil else { return }
            if let url = URL(string: resultModel.homeTeamLogo) {
                homeTeamIcon.kf.setImage(with: url)
            }
            if let url = URL(string: resultModel.visitingTeamLogo) {
                visiTeamIcon.kf.setImage(with: url)
            }
            //self.collectionButton.isUserInteractionEnabled = true
            self.setData()
            
        }
    }
    
    private func setData() {
        statusLabel.text = ""
        guard let status = resultModel.matchFinish else { return }
        
        switch status {
        case "0": // 未开赛
            setNotStartMatch("未开赛")
        case "2":  // 取消
            setCancelMatch("取消")
        case "4":  // 推迟
            setCancelMatch("推迟")
        case "5":  // 暂停
            setCancelMatch("暂停")
        case "6":  // 进行中
            setStartMatch()
        case "1":  // 已结束
            setOverMatch()
        default:
            setOverMatch()
        }
    }
    
    private func setStartMatch() {
        
        scorelb.text = resultModel.whole
        scorelb.textColor = ColorE85504
        scorelb.font = Font16
        
        resultlb.text = "\(resultModel.minute)′"
        resultlb.textColor = ColorE85504
    }
    
    private func setNotStartMatch(_ title: String) {

        scorelb.text = "VS"
        scorelb.textColor = Color787878
        scorelb.font = Font16
        
        resultlb.text = title
        resultlb.textColor = Color787878
        
    }
    
    private func setCancelMatch (_ title: String) {
        resultlb.text = ""
        statusLabel.text = title
        resultlb.textColor = Color787878
        
        scorelb.text = "VS"
        scorelb.font = Font16
    }
    
    private func setOverMatch() {
        resultlb.text = "半场" + resultModel.firstHalf
        resultlb.textColor = ColorE85504
        
        scorelb.text = resultModel.whole
        scorelb.textColor = ColorE85504
        scorelb.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    
    public var matchType: String!
    
    public var indexPath : IndexPath!
    public var delegate : LotteryCellDelegate!
    public var collectionButton : UIButton!
    
    // MARK: - 属性 private
    
    
    private var titlelb : UILabel!
    private var homeTeamIcon : UIImageView!
    private var visiTeamIcon : UIImageView!
    private var homeTeamlb : UILabel!
    private var visiTeamlb : UILabel!
    private var scorelb : UILabel!
    private var resultlb : UILabel!
    //private var resultLeftLabel: UILabel!
    
    private var statusLabel : UILabel!
    
    private var line : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    public func changeCollectionSelected(selected : Bool) {
        if selected {
            self.collectionButton.setImage(UIImage(named: "se收藏-1"), for: .normal)
        }else {
            self.collectionButton.setImage(UIImage(named: "收藏-1"), for: .normal)
        }
        self.collectionButton.isSelected = selected
        
    }
    
    @objc private func collectionClick(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isUserInteractionEnabled = false
        //changeCollectionSelected(selected: sender.isSelected)
        guard delegate != nil else { fatalError("delegate 值为空") }
        delegate.didTipCollection(cell: self, model: resultModel, selected : sender.isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
            make.height.equalTo(0.3)
        }
        titlelb.snp.makeConstraints { (make) in
            make.top.equalTo(9 * defaultScale)
            make.height.equalTo(11 * defaultScale)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
        }
        collectionButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.height.width.equalTo(40 * defaultScale)
            make.left.equalTo(6 * defaultScale)
        }
        homeTeamIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.height.width.equalTo(40 * defaultScale)
            make.left.equalTo(collectionButton.snp.right).offset(2)
        }
        visiTeamIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(homeTeamIcon)
            make.right.equalTo(-1)
        }
        scorelb.snp.makeConstraints { (make) in
            make.width.equalTo(60 * defaultScale)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(16 * defaultScale)
            make.top.equalTo(titlelb.snp.bottom).offset(17 * defaultScale)
        }
        homeTeamlb.snp.makeConstraints { (make) in
            make.top.equalTo(titlelb.snp.bottom).offset(17 * defaultScale)
            make.left.equalTo(homeTeamIcon.snp.right)
            make.right.equalTo(scorelb.snp.left)
            make.height.equalTo(scorelb)
        }
        visiTeamlb.snp.makeConstraints { (make) in
            make.top.height.equalTo(scorelb)
            
            make.left.equalTo(scorelb.snp.right)
            make.right.equalTo(visiTeamIcon.snp.left)
        }
        
        resultlb.snp.makeConstraints { (make) in
            make.top.equalTo(homeTeamlb.snp.bottom).offset(11.5 * defaultScale)
            make.centerX.equalTo(scorelb.snp.centerX)
            make.width.equalTo(150)
            make.right.equalTo(visiTeamlb)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(scorelb.snp.centerX)
            make.top.equalTo(resultlb)
            make.width.equalTo(100)
            make.height.equalTo(resultlb)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        titlelb = getLabel()
        titlelb.text = "001 德国杯 2月7日 01： 30"
        
        homeTeamlb = getLabel()
        homeTeamlb.font = Font16
        homeTeamlb.textColor = Color505050
        homeTeamlb.textAlignment = .right
        homeTeamlb.text = "汉密尔顿"
        
        visiTeamlb = getLabel()
        visiTeamlb.font = Font16
        visiTeamlb.textColor = Color505050
        visiTeamlb.text = "凯尔特人"
        
        scorelb = getLabel()
        scorelb.font = Font16
        scorelb.textColor = Color787878
        scorelb.textAlignment = .center
        scorelb.text = "VS"
        
        resultlb = getLabel()
        resultlb.font = Font12
        resultlb.textColor = Color787878
        resultlb.textAlignment = .center
        //resultlb.text = "半场 1：0  总比分1：2"
        
//        resultLeftLabel = getLabel()
//        resultLeftLabel.font = Font12
//        resultLeftLabel.textColor = ColorEA5504
//        resultLeftLabel.textAlignment = .right
        
        statusLabel = getLabel()
        statusLabel.font = Font12
        statusLabel.textAlignment = .center
        statusLabel.textColor = Color787878
        
        homeTeamIcon = UIImageView()
        homeTeamIcon.image = UIImage(named : "Racecolorfootball")
        
        visiTeamIcon = UIImageView()
        visiTeamIcon.image = UIImage(named: "Racecolorfootball")
        
        line = UIImageView()
        line.image = UIImage(named : "line")
        
        collectionButton = UIButton(type: .custom)
        collectionButton.setImage(UIImage(named: "收藏-1"), for: .normal)
        collectionButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionButton.addTarget(self, action: #selector(collectionClick(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(titlelb)
        self.contentView.addSubview(scorelb)
        self.contentView.addSubview(resultlb)
        self.contentView.addSubview(homeTeamlb)
        self.contentView.addSubview(visiTeamlb)
        self.contentView.addSubview(homeTeamIcon)
        self.contentView.addSubview(visiTeamIcon)
        self.contentView.addSubview(collectionButton)
//        self.contentView.addSubview(resultLeftLabel)
        self.contentView.addSubview(statusLabel)
    }
    
    private func getLabel() -> UILabel {
        let lab  = UILabel()
        lab.font = Font11
        lab.textColor = Color9F9F9F
        lab.textAlignment = .left
        
        return lab
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
