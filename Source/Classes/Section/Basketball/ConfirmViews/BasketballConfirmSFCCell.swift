//
//  BasketballConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class BasketballConfirmSFCCell: UITableViewCell,DateProtocol {

    public var delegate : BasketballConfirmCellDelegate!
    
    // 单关标识
    @IBOutlet weak var singleIcon : UIImageView!
    // 场次信息
    @IBOutlet weak var changciLabel : UILabel!
    // 客队
    @IBOutlet weak var visiTeam : UILabel!
    // vs
    @IBOutlet weak var vsTeam : UILabel!
    // 主队
    @IBOutlet weak var homeTeam : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    
    @IBOutlet weak var danButton : UIButton!
    
    @IBOutlet weak var oddsLabel : UILabel!
    
    @IBOutlet weak var oddsTop : UIView!
    @IBOutlet weak var oddsBot : UIView!
    
    private var playInfo : BBPlayModel!
    public var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    private func initSubview() {
        
        singleIcon.isHidden = true
        
        danButton.layer.cornerRadius = 2
        danButton.layer.masksToBounds = true
        
        danButton.layer.borderWidth = 1
        danButton.layer.borderColor = ColorEDEDED.cgColor
        danButton.isHidden = true
        oddsLabel.backgroundColor = ColorEA5504
        oddsTop.backgroundColor = ColorEA5504
        oddsBot.backgroundColor = ColorEA5504
    }
}
// MARK: - 点击事件
extension BasketballConfirmSFCCell {
    @IBAction func deleteClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDelete(playInfo: self.playInfo)
    }
    @IBAction func danClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDan(playInfo: self.playInfo)
    }
}
// MARK: - 数据显示
extension BasketballConfirmSFCCell {
    public func configure(with data : BBPlayModel) {
        self.playInfo = data
        
        // 场次信息
        self.changciLabel.text =  "\(data.playInfo.leagueAddr) \(data.playInfo.changci)  截止:\(timeStampToHHmm(data.playInfo.betEndTime))"

        // 客队名
        let visiMuatt = NSMutableAttributedString(string: "[客]",
                                                  attributes: [NSAttributedString.Key.foregroundColor: Color9F9F9F,
                                                               NSAttributedString.Key.font: Font14])
        let visiAtt = NSAttributedString(string: data.playInfo.visitingTeamName,
                                         attributes: [NSAttributedString.Key.foregroundColor: Color505050,
                                                      NSAttributedString.Key.font: Font14])
        visiMuatt.append(visiAtt)
        visiTeam.attributedText = visiMuatt
        // 主队名
        let homeMuatt = NSMutableAttributedString(string: "[主]",
                                                  attributes: [NSAttributedString.Key.foregroundColor: Color9F9F9F,
                                                               NSAttributedString.Key.font: Font14])
        let homeAtt = NSAttributedString(string: data.playInfo.homeTeamName,
                                         attributes: [NSAttributedString.Key.foregroundColor: Color505050,
                                                      NSAttributedString.Key.font : Font14])
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
            case "3":
                guard cell.cellCode != "" else { return }
                if  Int(cell.cellCode)! > 6{
                    odds += "客胜" + cell.cellName + " "
                }else{
                    odds += "主胜" + cell.cellName + " "
                }
            case "4":
                if cell.cellName.contains("大") {
                   odds += "大分 "
                }
                if cell.cellName.contains("小"){
                   odds += "小分 "
                }
            default:
                break
            }
        }
        oddsLabel.text = odds
    }
    
}
