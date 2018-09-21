//
//  BasketballHunheCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol BasketballHunheCellDelegate {
    func didTipMore(playInfo : BasketballListModel, viewModel : BBPlayModel) -> Void
}

class BasketballHunheCell: UITableViewCell {

    public var delegate : BasketballHunheCellDelegate!
    
    @IBOutlet weak var topLineOne : UIView!
    @IBOutlet weak var topLineTwo : UIView!
    @IBOutlet weak var topLineThree: UIView!
    @IBOutlet weak var topLineFour : UIView!
    
    @IBOutlet weak var leftLineOne : UIView!
    @IBOutlet weak var leftLineTwo : UIView!
    @IBOutlet weak var leftLineThree: UIView!
    
    @IBOutlet weak var rightLineOne: UIView!
    @IBOutlet weak var rightLineTwo: UIView!
    @IBOutlet weak var rightLineThree: UIView!
    
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
    
    // 胜负
    @IBOutlet weak var sfTitle : UILabel!
    @IBOutlet weak var sfVisiTeam : UIButton!
    @IBOutlet weak var sfHomeTeam : UIButton!
    // 让分
    @IBOutlet weak var rfTitle: UILabel!
    @IBOutlet weak var rfVisiTeam : UIButton!
    @IBOutlet weak var rfHomeTeam : UIButton!
    // 大小分
    @IBOutlet weak var dxfTitle : UILabel!
    @IBOutlet weak var dxfVisiTeam : UIButton!
    @IBOutlet weak var dxfHomeTeam : UIButton!
    
    // 更多玩法
    @IBOutlet weak var moreButton : UIButton!
    
    private var playInfo : BasketballListModel!
    
    private var viewModel : BBPlayModel!
    
    private var homeViewModel : BasketballViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        sfTitle.text = "胜\n负"
        rfTitle.text = "让\n分"
        dxfTitle.text = "大\n小\n分"
        moreButton.titleLabel?.numberOfLines = 0
        moreButton.setTitle("更多\n玩法", for: .normal)
        
        sfVisiTeam.titleLabel?.numberOfLines = 2
        sfHomeTeam.titleLabel?.numberOfLines = 2
        
        rfVisiTeam.titleLabel?.numberOfLines = 2
        rfHomeTeam.titleLabel?.numberOfLines = 2
        
        dxfVisiTeam.titleLabel?.numberOfLines = 2
        dxfHomeTeam.titleLabel?.numberOfLines = 2
        
        sfVisiTeam.titleLabel?.textAlignment = .center
        sfHomeTeam.titleLabel?.textAlignment = .center
        rfVisiTeam.titleLabel?.textAlignment = .center
        rfHomeTeam.titleLabel?.textAlignment = .center
        dxfVisiTeam.titleLabel?.textAlignment = .center
        dxfHomeTeam.titleLabel?.textAlignment = .center
    }
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipMore(playInfo: self.playInfo, viewModel : viewModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
}

// MARK: - 玩法 点击事件
extension BasketballHunheCell {
    @IBAction func sfVisiClick(_ sender : UIButton) {
        viewModel.seSFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func sfHomeClick(_ sender : UIButton) {
        viewModel.seSFHomePlay(isSelected: sender.isSelected)
    }
    @IBAction func rfVisiClick(_ sender : UIButton) {
        viewModel.seRFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func rfHomeClick(_ sender : UIButton) {
        viewModel.seRFHomePlay(isSelected: sender.isSelected)
    }
    @IBAction func dxfVisiClick(_ sender : UIButton) {
        viewModel.seDXFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func dxfHomeClick(_ sender : UIButton) {
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
extension BasketballHunheCell {
    public func configure(with data : BBPlayModel, viewModel : BasketballViewModel) {
        self.viewModel = data
        self.homeViewModel = viewModel
        _ = data.shengfu.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.sfVisiTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.sfVisiTeam)
            })
        _ = data.shengfu.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.sfHomeTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.sfHomeTeam)
            })
        // 让分
        _ = data.rangfen.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.rfVisiTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.rfVisiTeam)
            })
        
        _ = data.rangfen.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.rfHomeTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.rfHomeTeam)
            })
        // 大小分
        _ = data.daxiaofen.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.dxfVisiTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.dxfVisiTeam)
            })
        
        _ = data.daxiaofen.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.dxfHomeTeam.isSelected = se
                self.seButton(isSelected: se, sender: self.dxfHomeTeam)
            })
        // 更多
        _ = data.selectedCellNum.asObserver()
            .subscribe({ [weak self](event) in
                guard let num = event.element else { return }
                
                if num <= 0 {
                    let att = NSMutableAttributedString(string: "更多\n玩法",
                                                        attributes: [NSAttributedStringKey.foregroundColor : Color505050])
                    self?.moreButton.setAttributedTitle(att, for: .normal)
                    
                }else {
                    

                    let muatt = NSMutableAttributedString(string: "已选\n",
                                                          attributes: [NSAttributedStringKey.foregroundColor : Color505050])
                    let numAtt = NSAttributedString(string: "\(num)",
                                                    attributes: [NSAttributedStringKey.foregroundColor : ColorEA5504])
                    let att = NSAttributedString(string: "项",
                        attributes: [NSAttributedStringKey.foregroundColor : Color505050])
                    muatt.append(numAtt)
                    muatt.append(att)
                    self?.moreButton.setAttributedTitle(muatt, for: .normal)
                }
                
            })
    }
    
    public func configure(with data : BasketballListModel) {
        self.playInfo = data
        
        guard data.isShutDown == false else {
            
            return }
        
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
        
        guard data.matchPlays.isEmpty == false else { return }
        
        var single = false
        
        for playInfo in data.matchPlays {
            
            switch playInfo.playType {
            case "1": // 胜负
                switch playInfo.single {
                case true:
                    single = true
                    topLineOne.backgroundColor = ColorEA5504
                    topLineTwo.backgroundColor = ColorEA5504
                    topLineThree.backgroundColor = ColorFFFFFF
                    topLineFour.backgroundColor = ColorFFFFFF
                    
                    leftLineOne.backgroundColor = ColorEA5504
                    leftLineTwo.backgroundColor = ColorFFFFFF
                    leftLineThree.backgroundColor = ColorFFFFFF
                    
                    rightLineOne.backgroundColor = ColorEA5504
                    rightLineTwo.backgroundColor = ColorFFFFFF
                    rightLineThree.backgroundColor = ColorFFFFFF
                case false :
                    lineDefaultColor()
                }
               
                switch playInfo.isShow {
                case false :
                    
                    let att = NSAttributedString(string: "未开售")
                    
                    sfVisiTeam.setAttributedTitle(att, for: .normal)
                    sfHomeTeam.setAttributedTitle(att, for: .normal)
                    
                    sfVisiTeam.isUserInteractionEnabled = false
                    sfHomeTeam.isUserInteractionEnabled = false
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    sfVisiTeam.setAttributedTitle(visiOdds, for: .normal)

                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds)
                    sfHomeTeam.setAttributedTitle(homeOdds, for: .normal)

                    sfVisiTeam.isUserInteractionEnabled = true
                    sfHomeTeam.isUserInteractionEnabled = true
                    
                }
                
            case "2": // 让分胜负
                
                switch playInfo.single {
                case true:
                    single = true
                    topLineOne.backgroundColor = ColorFFFFFF
                    topLineTwo.backgroundColor = ColorEA5504
                    topLineThree.backgroundColor = ColorEA5504
                    topLineFour.backgroundColor = ColorFFFFFF
                    
                    leftLineOne.backgroundColor = ColorFFFFFF
                    leftLineTwo.backgroundColor = ColorEA5504
                    leftLineThree.backgroundColor = ColorFFFFFF
                    
                    rightLineOne.backgroundColor = ColorFFFFFF
                    rightLineTwo.backgroundColor = ColorEA5504
                    rightLineThree.backgroundColor = ColorFFFFFF
                case false :
                    lineDefaultColor()
                }
                
                switch playInfo.isShow {
                case false :
                    
                    let att = NSAttributedString(string: "未开售")
                    
                    rfVisiTeam.setAttributedTitle(att, for: .normal)
                    rfHomeTeam.setAttributedTitle(att, for: .normal)
                    rfVisiTeam.isUserInteractionEnabled = false
                    rfHomeTeam.isUserInteractionEnabled = false
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    rfVisiTeam.setAttributedTitle(visiOdds, for: .normal)
                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds,
                                                       fixedOdds: playInfo.fixedOdds)
                    
                    rfHomeTeam.setAttributedTitle(homeOdds, for: .normal)
                    
                    rfVisiTeam.isUserInteractionEnabled = true
                    rfHomeTeam.isUserInteractionEnabled = true
                    
                }
                
            case "4": // 大小分
                switch playInfo.single {
                case true:
                    single = true
                    topLineOne.backgroundColor = ColorFFFFFF
                    topLineTwo.backgroundColor = ColorFFFFFF
                    topLineThree.backgroundColor = ColorEA5504
                    topLineFour.backgroundColor = ColorEA5504
                    
                    leftLineOne.backgroundColor = ColorFFFFFF
                    leftLineTwo.backgroundColor = ColorFFFFFF
                    leftLineThree.backgroundColor = ColorEA5504
                    
                    rightLineOne.backgroundColor = ColorFFFFFF
                    rightLineTwo.backgroundColor = ColorFFFFFF
                    rightLineThree.backgroundColor = ColorEA5504
                case false :
                    lineDefaultColor()
                }
                switch playInfo.isShow {
                case false :
                    
                    let att = NSAttributedString(string: "未开售")
                    
                    dxfVisiTeam.setAttributedTitle(att, for: .normal)
                    dxfHomeTeam.setAttributedTitle(att, for: .normal)
                    dxfVisiTeam.isUserInteractionEnabled = false
                    dxfHomeTeam.isUserInteractionEnabled = false
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    dxfVisiTeam.setAttributedTitle(visiOdds, for: .normal)
                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds)
                    dxfHomeTeam.setAttributedTitle(homeOdds, for: .normal)
                    
                    dxfVisiTeam.isUserInteractionEnabled = true
                    dxfHomeTeam.isUserInteractionEnabled = true
                    
                }
                
                
//            case "3": // 胜分差
            default : break
            }
        }
        // 显示、隐藏单关
        singleImg.isHidden = !single
    }
    
    private func getAttributedString(cellName : String, cellOdds : String, fixedOdds : String? = nil) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                  attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                               NSAttributedStringKey.font : Font14])
        
        if let fix = fixedOdds {
            var color : UIColor
            
            if fix.contains("+"){
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
    
    private func getAttributedStringSe(cellName : String, cellOdds : String, fixedOdds : String? = nil) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF,
                                                                 NSAttributedStringKey.font : Font14])
        
        if let fix = fixedOdds {
            let fixAtt = NSAttributedString(string: "(\(fix))", attributes: [NSAttributedStringKey.foregroundColor : ColorFFFFFF])
            cellNameAtt.append(fixAtt)
        }
        
        let cellOddsAtt = NSAttributedString(string: "\n\(cellOdds)",
            attributes: [NSAttributedStringKey.foregroundColor: ColorFFFFFF,
                         NSAttributedStringKey.font: Font12])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
    
    private func lineDefaultColor() {
        topLineOne.backgroundColor = ColorFFFFFF
        topLineTwo.backgroundColor = ColorFFFFFF
        topLineThree.backgroundColor = ColorFFFFFF
        topLineFour.backgroundColor = ColorFFFFFF
        
        leftLineOne.backgroundColor = ColorFFFFFF
        leftLineTwo.backgroundColor = ColorFFFFFF
        leftLineThree.backgroundColor = ColorFFFFFF
        
        rightLineOne.backgroundColor = ColorFFFFFF
        rightLineTwo.backgroundColor = ColorFFFFFF
        rightLineThree.backgroundColor = ColorFFFFFF
    }
}
