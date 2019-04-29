//
//  FootballMatchInfoScaleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//  历史交锋

import UIKit

class FootballMatchInfoScaleCell: UITableViewCell {

    // MARK: - 属性 public
    public var teamInfo : MatchTeamInfoModel! {
        didSet{
            guard teamInfo != nil else { return }
            homeScale.scaleNum = CGFloat(teamInfo.win) / CGFloat(teamInfo.total)
            flatScale.scaleNum = CGFloat(teamInfo.draw) / CGFloat(teamInfo.total)
            visiScale.scaleNum = CGFloat(teamInfo.lose) / CGFloat(teamInfo.total)
        }
    }
    
    // MARK: - 属性 private
    private var homelb : UILabel!
    private var flatlb : UILabel!
    private var visilb : UILabel!
    
    private var homeScale : ScaleView!
    private var flatScale : ScaleView!
    private var visiScale : ScaleView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        homeScale.snp.makeConstraints { (make) in
            make.top.equalTo(20 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
            make.width.equalTo(306 * defaultScale)
        }
        flatScale.snp.makeConstraints { (make) in
            make.top.equalTo(homeScale.snp.bottom).offset(23 * defaultScale)
            make.left.right.equalTo(homeScale)
            make.height.equalTo(homeScale)
        }
        visiScale.snp.makeConstraints { (make) in
            make.top.equalTo(flatScale.snp.bottom).offset(23 * defaultScale)
            make.left.right.height.equalTo(homeScale)
            make.bottom.equalTo(-20 * defaultScale)
        }
        
        homelb.snp.makeConstraints { (make) in
            make.centerY.equalTo(homeScale.snp.centerY)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(homeScale.snp.left)
            make.height.equalTo(15)
        }
        flatlb.snp.makeConstraints { (make) in
            make.centerY.equalTo(flatScale.snp.centerY)
            make.left.width.height.equalTo(homelb)
        }
        visilb.snp.makeConstraints { (make) in
            make.centerY.equalTo(visiScale.snp.centerY)
            make.left.width.height.equalTo(homelb)
        }
    }

    private func initSubview() {
        self.selectionStyle = .none
        
        homelb = getLabel("主胜")
        flatlb = getLabel("平")
        visilb = getLabel("客胜")
        
        homeScale = ScaleView()
        homeScale.scaleColor = ColorEA5504
        
        flatScale = ScaleView()
        flatScale.scaleColor = Color65AADD
        
        visiScale = ScaleView()
        visiScale.scaleColor = Color44AE35
        
        
        self.contentView.addSubview(homelb)
        self.contentView.addSubview(flatlb)
        self.contentView.addSubview(visilb)
        self.contentView.addSubview(homeScale)
        self.contentView.addSubview(flatScale)
        self.contentView.addSubview(visiScale)
        
    }
    
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color9F9F9F
        lab.textAlignment = .left
        lab.text = title
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
