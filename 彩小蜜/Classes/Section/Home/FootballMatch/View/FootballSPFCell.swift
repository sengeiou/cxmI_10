//
//  FootballSPFCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  胜平负

import UIKit

class FootballSPFCell: UITableViewCell {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            endTime.text = playInfoModel.matchTime
            teamView.teamInfo = playInfoModel
        }
    }
    
    private var matchTitle: UILabel!
    private var matchTime: UILabel!
    private var endTime: UILabel!
    private var detailBut: UIButton!
    private var teamView: FootballTeamView!
    
    private var typeIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        typeIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(20)
        }
        
        matchTitle.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(endTime)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.equalTo(matchTitle.snp.bottom).offset(2)
            make.left.width.height.equalTo(endTime)
        }
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(leftSpacing)
            make.top.equalTo(matchTime.snp.bottom).offset(2)
            make.bottom.equalTo(detailBut.snp.top).offset(-2)
        }
        detailBut.snp.makeConstraints { (make) in
            make.centerX.equalTo(endTime.snp.centerX)
            make.width.height.equalTo(20)
            make.bottom.equalTo(-10)
        }
        teamView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(endTime.snp.right).offset(10)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        teamView = FootballTeamView()
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(named: "Datasecurity")
        
        matchTitle = initLabel()
        
        matchTime = initLabel()
        
        endTime = initLabel()
        endTime.sizeToFit()
        
        detailBut = UIButton(type: .custom)
        detailBut.setImage(UIImage(named: "jump"), for: .normal)
        detailBut.titleLabel?.numberOfLines = 2
        
        self.contentView.addSubview(teamView)
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(matchTitle)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(endTime)
        self.contentView.addSubview(detailBut)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        lab.text = "截止23： 50"
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
