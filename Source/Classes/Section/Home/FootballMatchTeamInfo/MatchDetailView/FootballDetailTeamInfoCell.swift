//
//  FootballDetailTeamInfoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballDetailTeamInfoCell: UITableViewCell {

    static let identifier : String = "FootballDetailTeamInfoCell"
    
    public var matchInfo : MatchInfoModel! {
        didSet{
            homeLabel.text = matchInfo.homeTeamAbbr
            visiLabel.text = matchInfo.visitingTeamAbbr
            if let url = URL(string: matchInfo.homeTeamPic) {
                homeIcon.kf.setImage(with: url)
            }
            if let url = URL(string: matchInfo.visitingTeamPic) {
                visiIcon.kf.setImage(with: url)
            }
         }
    }
    
    private var vsLabel: UILabel!
    private var homeLabel: UILabel!
    private var visiLabel: UILabel!
    private var homeIcon: UIImageView!
    private var visiIcon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }
    
    private func initSubview() {
        vsLabel = getLabel()
        vsLabel.text = "VS"
        vsLabel.textColor = Color9F9F9F
        vsLabel.textAlignment = .center
        
        homeLabel = getLabel()
        homeLabel.textAlignment = .right
        homeLabel.text = "西班牙"
        
        visiLabel = getLabel()
        visiLabel.textAlignment = .left
        visiLabel.text = "俄罗斯"
        
        homeIcon = getImageView("足球")
        visiIcon = getImageView("足球")
        
        self.contentView.addSubview(vsLabel)
        self.contentView.addSubview(homeLabel)
        self.contentView.addSubview(visiLabel)
        self.contentView.addSubview(homeIcon)
        self.contentView.addSubview(visiIcon)
        
        vsLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(70)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        homeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(vsLabel.snp.left)
            make.width.height.equalTo(40)
            make.centerY.equalTo(vsLabel.snp.centerY)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(homeIcon.snp.left).offset(-14)
            make.left.equalTo(10)
            make.top.bottom.equalTo(0)
        }
        visiIcon.snp.makeConstraints { (make) in
            make.left.equalTo(vsLabel.snp.right)
            make.width.height.centerY.equalTo(homeIcon)
        }
        visiLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visiIcon.snp.right).offset(14)
            make.right.equalTo(-10)
            make.top.bottom.equalTo(homeLabel)
        }
    }
    
    private func getLabel() -> UILabel{
        let lab = UILabel()
        lab.font = Font14
        lab.textColor = Color505050
        return lab
    }
    private func getImageView(_ image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        return imageView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
