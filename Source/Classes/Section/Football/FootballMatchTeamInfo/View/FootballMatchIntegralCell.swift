//
//  FootballMatchIntegralCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//  积分排名 Cell

import UIKit

class FootballMatchIntegralCell: UITableViewCell {

    public var homeScoreInfo : TeamScoreInfoModel! {
        didSet{
            guard homeScoreInfo != nil else { return }
            homeIntegralView.scoreInfo = homeScoreInfo
            homeTeamName.text = homeScoreInfo.teamName
        }
    }
    public var visiScoreInfo : TeamScoreInfoModel! {
        didSet{
            guard visiScoreInfo != nil else { return }
            visiIntegralView.scoreInfo = visiScoreInfo
            visiTeamName.text = visiScoreInfo.teamName
        }
    }
    
    private var title : UILabel!
    private var homeTeamName: UILabel!
    private var visiTeamName: UILabel!
    private var homeIntegralView: FootballIntegralView!
    private var visiIntegralView: FootballIntegralView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.equalTo(16 * defaultScale)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
            make.height.equalTo(15)
        }
        homeTeamName.snp.makeConstraints { (make) in
            make.bottom.equalTo(homeIntegralView.snp.top).offset(-10 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(15)
        }
        homeIntegralView.snp.makeConstraints { (make) in
            make.top.equalTo(69 * defaultScale)
            make.height.equalTo(117 * defaultScale)
            make.left.right.equalTo(0)
        }
        visiTeamName.snp.makeConstraints { (make) in
            make.bottom.equalTo(visiIntegralView.snp.top).offset(-10 * defaultScale)
            make.left.height.right.equalTo(homeTeamName)
        }
        visiIntegralView.snp.makeConstraints { (make) in
            make.top.equalTo(homeIntegralView.snp.bottom).offset(43 * defaultScale)
            make.left.right.height.equalTo(homeIntegralView)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        title = getLabel()
        title.textColor = Color505050
        title.font = Font14
        title.textAlignment = .left
        
        homeTeamName = getLabel()
        homeTeamName.text = "阿森纳"
        
        visiTeamName = getLabel()
        visiTeamName.text = "阿森纳"
        
        homeIntegralView = FootballIntegralView()
        visiIntegralView = FootballIntegralView()
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(homeTeamName)
        self.contentView.addSubview(visiTeamName)
        self.contentView.addSubview(homeIntegralView)
        self.contentView.addSubview(visiIntegralView)
    }
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color505050
        lab.textAlignment = .center
        lab.text = "积分排名"
        return lab
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
