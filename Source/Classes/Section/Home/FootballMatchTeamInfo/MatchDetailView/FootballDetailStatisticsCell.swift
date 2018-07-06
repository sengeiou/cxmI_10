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
    
    private var homeScaleView: ScaleView!
    private var visiScaleView: ScaleView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
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
        
        homeScaleView = ScaleView()
        homeScaleView.scaleWidth = scaleWidth
        homeScaleView.sequence = false
        homeScaleView.scaleColor = ColorE85504
        
        homeScaleView.scaleNum = 0.6
        
        visiScaleView = ScaleView()
        visiScaleView.scaleWidth = scaleWidth
        visiScaleView.scaleColor = ColorE85504
        visiScaleView.scaleNum = 0.9
        
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
