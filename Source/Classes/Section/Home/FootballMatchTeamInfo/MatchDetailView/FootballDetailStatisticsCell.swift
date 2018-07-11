//
//  FootballDetailStatisticsCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let scaleWidth : CGFloat = 103 * defaultScale

class FootballDetailStatisticsCell: UITableViewCell {

    static let identifier : String = "FootballDetailStatisticsCell"
    
    
    
    private var homeNumLabel: UILabel!
    private var visiNumLabel: UILabel!
    
    private var titleLabel: UILabel!
    
    private var homeScaleView: UIProgressView!
    private var visiScaleView: UIProgressView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }
    
    public func changeData(data : FootballLiveTeamData, indexPath : IndexPath) {
        self.titleLabel.text = data.dataName
        
        if data.dataType == "1" {
            homeScaleView.setProgress( 1 - (Float(data.teamHData) / 100), animated: true)
            homeNumLabel.text = "\(data.teamHData)%"
            
            visiScaleView.setProgress(Float(data.teamAData) / 100, animated: true)
            visiNumLabel.text = "\(data.teamAData)%"
        }else {

            homeScaleView.setProgress( 1 - (Float(CGFloat(data.teamHData) / CGFloat(data.teamHData + data.teamAData))), animated: true)
            homeNumLabel.text = "\(data.teamHData)"

            visiScaleView.setProgress(Float(data.teamAData) / Float(data.teamHData + data.teamAData), animated: true)
            visiNumLabel.text = "\(data.teamAData)"
        }
        
        if data.teamHData > data.teamAData {
            homeScaleView.trackTintColor = ColorE85504
            visiScaleView.progressTintColor = ColorA5A5A5
        }else {
            homeScaleView.trackTintColor = ColorA5A5A5
            visiScaleView.progressTintColor = ColorE85504
        }
    }
    
    private func initSubview() {
        homeNumLabel = getLabel()
        homeNumLabel.textAlignment = .right
        homeNumLabel.text = "25"
        
        visiNumLabel = getLabel()
        visiNumLabel.textAlignment = .left
        visiNumLabel.text = "20%"
        
        titleLabel = getLabel()
        titleLabel.text = "有威胁助攻"
        
        homeScaleView = UIProgressView()
        homeScaleView.progressTintColor = ColorF4F4F4
        homeScaleView.trackTintColor = ColorEA5504
        
        visiScaleView = UIProgressView()
        visiScaleView.progressTintColor = ColorEA5504
        visiScaleView.trackTintColor = ColorF4F4F4
        
        self.contentView.addSubview(homeNumLabel)
        self.contentView.addSubview(visiNumLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(homeScaleView)
        self.contentView.addSubview(visiScaleView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.width.equalTo(74 * defaultScale)
            make.top.bottom.equalTo(0)
        }
        homeScaleView.snp.makeConstraints { (make) in
            make.width.equalTo(scaleWidth)
            make.right.equalTo(titleLabel.snp.left).offset(-5)
            make.height.equalTo(4)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        homeNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(homeScaleView.snp.left).offset(-5)
            make.top.bottom.equalTo(0)
        }
        visiScaleView.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(homeScaleView)
            make.width.equalTo(scaleWidth)
            make.left.equalTo(titleLabel.snp.right).offset(5)
        }
        visiNumLabel.snp.makeConstraints { (make) in
            make.height.equalTo(homeNumLabel)
            make.right.equalTo(-5)
            make.left.equalTo(visiScaleView.snp.right).offset(5)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color505050
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
