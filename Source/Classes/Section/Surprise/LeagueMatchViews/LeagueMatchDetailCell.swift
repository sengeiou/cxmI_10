//
//  LeagueMatchDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueMatchDetailCellDelete {
    func didTipShowDetailButton( isSeletced : Bool) -> Void
}

class LeagueMatchDetailCell: UITableViewCell {

    public var delegate : LeagueMatchDetailCellDelete!
    
    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var leaderTitle : UILabel!
    @IBOutlet weak var leaderName: UILabel!
    @IBOutlet weak var leaderDetail: UILabel!
    
    @IBOutlet weak var leaderSeason : UIButton!
    
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func detailButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard delegate != nil else { return }
        delegate.didTipShowDetailButton(isSeletced: sender.isSelected)
    }
    
    
}

extension LeagueMatchDetailCell {
    public func configure(with data : LeagueDetailModel, style : LeagueDetailTitleStyle) {
        if let url = URL(string: data.leaguePic) {
            icon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error, type , url) in
                
                if let ima = image {
                    let size = ima.scaleImage(image: ima, imageLength: 90)
                    self.icon.snp.remakeConstraints { (make) in
                        make.top.equalTo(16)
                        make.left.equalTo(16)
                        make.size.equalTo(size)
                    }
                }
            }
        }
        leaderTitle.text = "联赛规则"
        leaderName.text = data.leagueAddr
        leaderDetail.text = data.leagueRule + data.leagueRule
        
        let season = data.leagueSeason.leagueSeasonInfoList[0]
        
        leaderSeason.setTitle(season.matchSeason, for: .normal)
        
        switch style {
        case .show:
            self.detailButton.isSelected = true
        case .hide:
            self.detailButton.isSelected = false
        }
        
    }
}

