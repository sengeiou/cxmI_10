//
//  FootballLineupCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupCell: UITableViewCell {

    static let identifier: String = "FootballLineupCell"
    
    public var homeLineup : [[FootballLineupMemberInfo]]! {
        didSet{
            hLineupView.lineupList = homeLineup
        }
    }
    public var visiLineup : [[FootballLineupMemberInfo]]! {
        didSet{
            vLineupView.lineupList = visiLineup
        }
    }
    
    public var lineupInfo : FootballLineupInfoModel! {
        didSet{
            self.refereeLabel.text = "主裁：" + lineupInfo.refereeName
            
            self.homeLabel.text = "\(lineupInfo.homeTeamAbbr)\n\(lineupInfo.formationTeamH)"
            self.visiLabel.text = "\(lineupInfo.visitingTeamAbbr)\n\(lineupInfo.formationTeamA)"
        }
    }
    
    private var backImageView : UIImageView!
    private var lineupImageView: UIImageView!
    
    private var hLineupView : FootballLineupView!
    private var vLineupView : FootballLineupView!
    
    private var refereeLabel: UILabel! //裁判
    private var fieldLabel: UILabel!   //场地
    
    private var homeLabel : UILabel!
    private var visiLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initBackView()
        initSubview()
    }
    
    private func initSubview() {
        hLineupView = FootballLineupView()
        hLineupView.lineupType = .主队
        vLineupView = FootballLineupView()
        vLineupView.lineupType = .客队
        
        lineupImageView.addSubview(hLineupView)
        lineupImageView.addSubview(vLineupView)
        
        refereeLabel = getLabel()
        refereeLabel.textAlignment = .left
        refereeLabel.text = "主裁： 洛奇"
        
        fieldLabel = getLabel()
        fieldLabel.textAlignment = .right
        //fieldLabel.text = "场地："
        
        homeLabel = getLabel()
        homeLabel.textAlignment = .left
        homeLabel.text = "巴西\n4-4-2"
        homeLabel.numberOfLines = 2
        homeLabel.sizeToFit()
        
        visiLabel = getLabel()
        visiLabel.textAlignment = .left
        visiLabel.text = "墨西哥\n4-4-2"
        visiLabel.numberOfLines = 2
        visiLabel.sizeToFit()
        
        backImageView.addSubview(refereeLabel)
        backImageView.addSubview(fieldLabel)
        lineupImageView.addSubview(homeLabel)
        lineupImageView.addSubview(visiLabel)
        
        
        refereeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(lineupImageView.snp.top)
            make.left.equalTo(lineupImageView)
            make.width.equalTo(fieldLabel)
        }
        fieldLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(refereeLabel)
            make.right.equalTo(lineupImageView)
            make.left.equalTo(refereeLabel.snp.right)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(10)
            make.height.equalTo(40)
        }
        visiLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(lineupImageView.snp.centerY).offset(19)
            make.left.height.equalTo(homeLabel)
            
            make.bottom.equalTo(-19)
        }
        
        hLineupView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(vLineupView)
        }
        vLineupView.snp.makeConstraints { (make) in
            make.top.equalTo(hLineupView.snp.bottom)
            make.bottom.left.right.equalTo(0)
        }
    }

    private func initBackView() {
        backImageView = UIImageView()
        backImageView.image = UIImage(named: "绿地")
        
        lineupImageView = UIImageView()
        lineupImageView.image = UIImage(named: "球场")
        
        self.contentView.addSubview(backImageView)
        backImageView.addSubview(lineupImageView)
        
        backImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        lineupImageView.snp.makeConstraints { (make) in
            make.top.equalTo(44 * defaultScale)
            make.bottom.equalTo(-44 * defaultScale)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = ColorFFFFFF
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
