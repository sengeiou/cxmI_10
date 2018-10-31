//
//  BasketballShengfuChaCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift
protocol BasketballShengfuChaCellDelegate {
    func didTipShengfenCha(playInfo : BasketballListModel, viewModel : BBPlayModel) -> Void
}

class BasketballShengfuChaCell: UITableViewCell, AlertPro {
    
    public var delegate : BasketballShengfuChaCellDelegate!
    
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
    
    // 停售
    @IBOutlet weak var stopSeller: UIButton!
    
    private var playInfo : BasketballListModel!
    
    private var viewModel : BBPlayModel!
    private var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    private func initSubview() {
        oddsLabel.layer.cornerRadius = 3
        oddsLabel.layer.masksToBounds = true
        oddsLabel.layer.borderWidth = 1
        oddsLabel.layer.borderColor = ColorF4F4F4.cgColor
        
        stopSeller.backgroundColor = UIColor(hexColor: "ededed", alpha: 0.9)
        stopSeller.setTitle("本场停售\n 详情>>", for: .normal)
        stopSeller.setTitleColor(Color505050, for: .normal)
        stopSeller.titleLabel?.numberOfLines = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func stopSelling(_ sender : UIButton) {
        showCXMAlert(title: "停售原因", message: "\n\(playInfo.shutDownMsg)", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    private func changeSellerState(isSeller : Bool) {
        stopSeller.isHidden = isSeller
    }

}

extension BasketballShengfuChaCell {
    @IBAction func oddsButtonClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipShengfenCha(playInfo: self.playInfo, viewModel: self.viewModel)
    }
}

extension BasketballShengfuChaCell {
    
    public func configure(with data : BBPlayModel) {
        self.viewModel = data
        
        _ = data.seSFC.asObserver()
            .subscribe({ [weak self](event) in
                guard let list = event.element else { return }
                var str = ""
                for cell in list {
                    if cell.selected {
                        
                        switch cell.playType {
                        case "31":
                            str += "客胜\(cell.cellName) "
                        case "32":
                            str += "主胜\(cell.cellName) "
                        default : break
                        }
                        
                    }
                }
                
                if str == "" {
                    self?.oddsLabel.text = "点击选择投注内容"
                    self?.oddsLabel.textColor = Color505050
                    self?.oddsLabel.backgroundColor = ColorFFFFFF
                }else{
                    self?.oddsLabel.text = str
                    self?.oddsLabel.textColor = ColorFFFFFF
                    self?.oddsLabel.backgroundColor = ColorEA5504
                }
            }).disposed(by: bag)
    }
    
    public func configure(with data : BasketballListModel) {
        self.playInfo = data
        
        guard data.isShutDown == false else {
            changeSellerState(isSeller: false)
            return }
        changeSellerState(isSeller: true)
        
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
