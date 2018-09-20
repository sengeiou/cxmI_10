//
//  BasketballRangCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballRangCell: UITableViewCell {

    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
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
    
    // 客队赔率
    @IBOutlet weak var visiOdds : UIButton!
    // 主队赔率
    @IBOutlet weak var homeOdds : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        visiOdds.titleLabel?.numberOfLines = 2
        homeOdds.titleLabel?.numberOfLines = 2
        
        visiOdds.titleLabel?.textAlignment = .center
        homeOdds.titleLabel?.textAlignment = .center
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BasketballRangCell {
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
        
        // 客队赔率
        let visiOddAtt = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                             cellOdds: playInfo.visitingCell.cellOdds, fixedOdds: nil)
        visiOdds.setAttributedTitle(visiOddAtt, for: .normal)
        
        // 主队赔率
        let homeOddAtt = getAttributedString(cellName: playInfo.homeCell.cellName,
                                             cellOdds: playInfo.homeCell.cellOdds, fixedOdds: playInfo.fixedOdds)
        homeOdds.setAttributedTitle(homeOddAtt, for: .normal)
    }
    
    private func getAttributedString(cellName : String, cellOdds : String, fixedOdds : String?) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                                 NSAttributedStringKey.font : Font14])
        if let fix = fixedOdds {
            
            var color : UIColor
            
            if fix.contains("+") {
                color = ColorEA5504
            }else {
                color = Color44AE35
            }
            
            let fixAtt = NSAttributedString(string: "(\(fix))", attributes: [NSAttributedStringKey.foregroundColor : color])
            cellNameAtt.append(fixAtt)
        }
        
        let cellOddsAtt = NSAttributedString(string: "\n\(cellOdds)",
            attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                         NSAttributedStringKey.font: Font12])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
}
