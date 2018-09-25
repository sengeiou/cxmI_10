//
//  BasketballConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballConfirmSFCCell: UITableViewCell {

    public var delegate : BasketballConfirmCellDelegate!
    
    // 客队
    @IBOutlet weak var visiTeam : UILabel!
    // vs
    @IBOutlet weak var vsTeam : UILabel!
    // 主队
    @IBOutlet weak var homeTeam : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    
    @IBOutlet weak var danButton : UIButton!
    
    @IBOutlet weak var oddsLabel : UILabel!
    
    private var playInfo : BBPlayModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        danButton.layer.cornerRadius = 2
        danButton.layer.masksToBounds = true
        
        danButton.layer.borderWidth = 1
        danButton.layer.borderColor = ColorEDEDED.cgColor
    }
}
// MARK: - 点击事件
extension BasketballConfirmSFCCell {
    @IBAction func deleteClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDelete(playInfo: self.playInfo)
    }
    @IBAction func danClick(_ sender : UIButton) {
        
    }
}
// MARK: - 数据显示
extension BasketballConfirmSFCCell {
    public func configure(with data : BBPlayModel) {
        self.playInfo = data
        // 客队名
        let visiMuatt = NSMutableAttributedString(string: "[客]",
                                                  attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                                                               NSAttributedStringKey.font: Font14])
        let visiAtt = NSAttributedString(string: data.playInfo.visitingTeamAbbr,
                                         attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                      NSAttributedStringKey.font: Font14])
        visiMuatt.append(visiAtt)
        visiTeam.attributedText = visiMuatt
        // 主队名
        let homeMuatt = NSMutableAttributedString(string: "[主]",
                                                  attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                                                               NSAttributedStringKey.font: Font14])
        let homeAtt = NSAttributedString(string: data.playInfo.homeTeamAbbr,
                                         attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                      NSAttributedStringKey.font : Font14])
        homeMuatt.append(homeAtt)
        homeTeam.attributedText = homeMuatt
        
        // 赔率
        
        var odds = ""
        for cell in data.seCellList {
            switch cell.playType {
            case "1":
                odds += cell.cellName + " "
            case "2":
                odds += cell.cellName + " "
            case "31":
                odds += "客胜" + cell.cellName + " "
            case "32":
                odds += "主胜" + cell.cellName + " "
            case "4":
                odds += cell.cellName + " "
            default:
                break
            }
        }
        oddsLabel.text = odds
    }
}
