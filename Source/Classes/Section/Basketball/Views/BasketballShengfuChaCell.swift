//
//  BasketballShengfuChaCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballShengfuChaCell: UITableViewCell {
    
    // 单关标识
    @IBOutlet weak var singleImg : UIImageView!
    // 客队
    @IBOutlet weak var visiTeam : UILabel!
    // vs
    @IBOutlet weak var vsTeam : UILabel!
    // 主队
    @IBOutlet weak var homeTeam : UILabel!
    
    // 联赛名
    @IBOutlet weak var leagueLabel : UILabel!
    // 日期
    @IBOutlet weak var dateLabel : UILabel!
    // 截止时间
    @IBOutlet weak var timeLabel : UILabel!
    
    
    @IBOutlet weak var oddsLabel : UILabel!
    @IBOutlet weak var oddsButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        oddsLabel.layer.borderWidth = 1
        oddsLabel.layer.borderColor = ColorF4F4F4.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BasketballShengfuChaCell {
    public func configure(with data : BasketballListModel) {
        // 客队名
        let visiMuatt = NSMutableAttributedString(string: "[客]",
                                                  attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                                                               NSAttributedStringKey.font: Font14])
        let visiAtt = NSAttributedString(string: data.visitingTeamAbbr,
                                         attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                      NSAttributedStringKey.font: Font14])
        visiMuatt.append(visiAtt)
        visiTeam.attributedText = visiMuatt
        // 主队名
        let homeMuatt = NSMutableAttributedString(string: "[主]",
                                                  attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                                                               NSAttributedStringKey.font: Font14])
        let homeAtt = NSAttributedString(string: data.homeTeamAbbr,
                                         attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                      NSAttributedStringKey.font : Font14])
        homeMuatt.append(homeAtt)
        homeTeam.attributedText = homeMuatt
        
        leagueLabel.text = data.leagueAddr
        dateLabel.text = data.changci
        timeLabel.text = data.matchDay
        
        guard data.matchPlays.count == 1 else { return }
        
        let playInfo = data.matchPlays[0]
        // 单关显示
        switch playInfo.single {
        case true:
            singleImg.isHidden = false
        case false:
            singleImg.isHidden = true
        }
        
        
    }
    
    private func getAttributedString(cellName : String, cellOdds : String) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                                 NSAttributedStringKey.font : Font14])
        let cellOddsAtt = NSAttributedString(string: "\n\(cellOdds)",
            attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                         NSAttributedStringKey.font: Font12])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
}
