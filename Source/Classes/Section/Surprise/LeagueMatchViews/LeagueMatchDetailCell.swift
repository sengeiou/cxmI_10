//
//  LeagueMatchDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueMatchDetailCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var leaderTitle : UILabel!
    @IBOutlet weak var leaderName: UILabel!
    @IBOutlet weak var leaderDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension LeagueMatchDetailCell {
    public func configure(with data : LeagueDetailModel) {
        if let url = URL(string: data.leaguePic) {
            icon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error, type , url) in
                
                if let ima = image {
                    let scor = ima.size.height / ima.size.width
                    self.icon.snp.remakeConstraints { (make) in
                        make.top.equalTo(16)
                        make.left.equalTo(16)
                        make.width.equalTo(90)
                        make.height.equalTo(90 * scor)
                    }
                }
            }
        }
        leaderTitle.text = "联赛规则"
        leaderName.text = data.leagueAddr
        leaderDetail.text = data.leagueRule
    }
}

