//
//  BasketballDaxiaofenCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift
class BasketballDaxiaofenCell: UITableViewCell, AlertPro {

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
        visiOdds.titleLabel?.numberOfLines = 2
        homeOdds.titleLabel?.numberOfLines = 2
        
        visiOdds.titleLabel?.textAlignment = .center
        homeOdds.titleLabel?.textAlignment = .center
        
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
// MARK: - 点击事件
extension BasketballDaxiaofenCell {
    @IBAction func visiClick(_ sender : UIButton) {
        viewModel.seDXFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func homeClick(_ sender : UIButton) {
        viewModel.seDXFHomePlay(isSelected: sender.isSelected)
    }
    private func seButton(isSelected : Bool, sender : UIButton) {
        switch isSelected {
        case true:
            sender.backgroundColor = ColorEA5504
        case false:
            sender.backgroundColor = ColorFFFFFF
        }
    }
}
// MARK: - 数据 配置
extension BasketballDaxiaofenCell {
    public func configure(with data : BBPlayModel) {
        self.viewModel = data
        _ = data.daxiaofen.visiCell.isSelected.asObserver()
            .subscribe({ [weak self](event) in
                guard let se = event.element else { return }
                self?.visiOdds.isSelected = se
                self?.seButton(isSelected: se, sender: (self?.visiOdds)!)
            }).disposed(by: bag)
        _ = data.daxiaofen.homeCell.isSelected.asObserver()
            .subscribe({ [weak self](event) in
                guard let se = event.element else { return }
                self?.homeOdds.isSelected = se
                self?.seButton(isSelected: se, sender: (self?.homeOdds)!)
            }).disposed(by: bag)
    }
    
    public func configure(with data : BasketballListModel) {
        guard data.isShutDown == false else {
            changeSellerState(isSeller: false)
            return }
        changeSellerState(isSeller: true)
        self.playInfo = data
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
        
        switch playInfo.isShow {
        case false :
            
            let att = NSAttributedString(string: "未开售")
            
            visiOdds.setAttributedTitle(att, for: .normal)
            homeOdds.setAttributedTitle(att, for: .normal)
        case true :
            // 客队赔率
            let visiOddAtt = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                 cellOdds: playInfo.visitingCell.cellOdds)
            visiOdds.setAttributedTitle(visiOddAtt, for: .normal)
            
            // 主队赔率
            let homeOddAtt = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                 cellOdds: playInfo.homeCell.cellOdds)
            homeOdds.setAttributedTitle(homeOddAtt, for: .normal)
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
