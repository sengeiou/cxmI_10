//
//  FootballMatchInfoFutureCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballMatchInfoFutureCell: UITableViewCell {

    static let identifier: String = "FootballMatchInfoFutureCell"
    
    public var futureInfo : MatchFutureInfo! {
        didSet{
            teamLabel.text = futureInfo.leagueAbbr
            dateLabel.text = futureInfo.matchDate
            homeLabel.text = futureInfo.homeTeamAbbr
            visiLabel.text = futureInfo.visitorTeamAbbr
        }
    }
   
    private var teamLabel: UILabel!
    private var dateLabel: UILabel!
    private var homeLabel: UILabel!
    private var visiLabel: UILabel!
    
    private var hLine : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }
    
    private func initSubview() {
        hLine = UIImageView()
        hLine.image = UIImage(named: "line")
        
        teamLabel = getLabel()
        teamLabel.text = "赛事"
        
        dateLabel = getLabel()
        dateLabel.text = "日期"
        
        homeLabel = getLabel()
        homeLabel.text = "主队"
        
        visiLabel = getLabel()
        visiLabel.text = "客队"
        
        self.contentView.addSubview(hLine)
        self.contentView.addSubview(teamLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(homeLabel)
        self.contentView.addSubview(visiLabel)
        
        hLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(1)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        teamLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(0)
            make.width.equalTo(70)
            make.left.equalTo(16 * defaultScale)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(teamLabel)
            make.left.equalTo(teamLabel.snp.right).offset(1)
            make.width.equalTo(visiLabel)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(dateLabel)
            make.left.equalTo(dateLabel.snp.right).offset(2)
        }
        visiLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(dateLabel)
            make.left.equalTo(homeLabel.snp.right).offset(2)
            make.right.equalTo(-6 * defaultScale)
        }
    }
    
    private func getLabel() -> UILabel{
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
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
