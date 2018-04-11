//
//  FootballTotalCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  总进球

import UIKit

class FootballTotalCell: UITableViewCell, DateProtocol {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            //teamView.teamInfo = playInfoModel
            endTime.text = "截止" + timeStampToHHmm(playInfoModel.betEndTime)
            if playInfoModel.matchPlays[0].single == true {
                typeIcon.isHidden = false
            }else {
                typeIcon.isHidden = true
            }
        }
    }
    
    private var matchTitle: UILabel!
    private var matchTime: UILabel!
    private var endTime: UILabel!
    private var detailBut: UIButton!
    public var totalView: FootballTotalView!
    private var homeMatch: UILabel!
    private var visitingMatch : UILabel!
    private var vsLb : UILabel!
    
    // 单关图标
    private var typeIcon : UIImageView!
    
    private var line : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(1)
        }
        
        typeIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(20)
        }
        
        matchTitle.snp.makeConstraints { (make) in
            make.top.equalTo(13.5 * defaultScale)
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
        
        homeMatch.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(totalView.snp.top)
            make.left.equalTo(totalView)
        }
        vsLb.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(homeMatch.snp.right)
        }
        visitingMatch.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(vsLb.snp.right)
            make.right.equalTo(totalView)
        }
        
        totalView.snp.makeConstraints { (make) in
            make.top.equalTo(35 * defaultScale)
            make.bottom.equalTo(-15 * defaultScale)
            make.left.equalTo(endTime.snp.right).offset(10)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        totalView = FootballTotalView()
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(named: "Singlefield")
        
        matchTitle = initLabel()
        
        matchTime = initLabel()
        
        endTime = initLabel()
        endTime.sizeToFit()
        
        detailBut = UIButton(type: .custom)
        detailBut.setImage(UIImage(named: "Collapse"), for: .normal)
        detailBut.titleLabel?.numberOfLines = 2
        
        homeMatch = initLabel()
        vsLb = initLabel()
        vsLb.text = "VS"
        visitingMatch = initLabel()
        
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(matchTitle)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(endTime)
        self.contentView.addSubview(detailBut)
        self.contentView.addSubview(totalView)
        self.contentView.addSubview(homeMatch)
        self.contentView.addSubview(vsLb)
        self.contentView.addSubview(visitingMatch)
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
