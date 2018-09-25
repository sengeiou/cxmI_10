//
//  BasketballConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol BasketballConfirmCellDelegate {
    func didTipDelete(playInfo : BBPlayModel) -> Void
}

class BasketballConfirmCell: UITableViewCell {

    public var delegate : BasketballConfirmCellDelegate!
    
    // 客队
    @IBOutlet weak var visiTeam : UILabel!
    // vs
    @IBOutlet weak var vsTeam : UILabel!
    // 主队
    @IBOutlet weak var homeTeam : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    
    @IBOutlet weak var danButton : UIButton!
    
    @IBOutlet weak var visiOdds : UIButton!
    @IBOutlet weak var homeOdds : UIButton!
    
    private var viewModel : BBPlayModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    
    private func initSubview() {
        danButton.layer.cornerRadius = 2
        danButton.layer.masksToBounds = true
        
        danButton.layer.borderWidth = 1
        danButton.layer.borderColor = ColorEDEDED.cgColor
        
        visiOdds.titleLabel?.numberOfLines = 2
        homeOdds.titleLabel?.numberOfLines = 2
        
        visiOdds.titleLabel?.textAlignment = .center
        homeOdds.titleLabel?.textAlignment = .center
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

extension BasketballConfirmCell {
    @IBAction func visiClick(_ sender : UIButton) {
        viewModel.seSFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func homeClick(_ sender : UIButton) {
        viewModel.seSFHomePlay(isSelected: sender.isSelected)
    }
    
    @IBAction func deleteClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDelete(playInfo: self.viewModel)
    }
    @IBAction func danClick(_ sender : UIButton) {
        
    }
}

extension BasketballConfirmCell {
    public func configure(with data : BBPlayModel) {
        self.viewModel = data
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
        
        var isShow : Bool
        var playInfo : BBPlayInfoModel!
        
        switch data.playType {
        case .胜负:
            isShow = data.shengfu.isShow
            playInfo = data.shengfu
        case .让分胜负:
            isShow = data.rangfen.isShow
            playInfo = data.rangfen
        case .大小分:
            isShow = data.daxiaofen.isShow
            playInfo = data.daxiaofen
        default:
            isShow = false
        }
        
        
        switch isShow {
        case false :
            
            let att = NSAttributedString(string: "未开售")
            
            visiOdds.setAttributedTitle(att, for: .normal)
            homeOdds.setAttributedTitle(att, for: .normal)
        case true :
            guard playInfo != nil else { return }
            // 客队赔率
            let visiOddAtt = getAttributedString(cellName: playInfo.visiCell.cellName,
                                                 cellOdds: playInfo.visiCell.cellOdds)
            visiOdds.setAttributedTitle(visiOddAtt, for: .normal)
            
            // 主队赔率
            let homeOddAtt = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                 cellOdds: playInfo.homeCell.cellOdds)
            homeOdds.setAttributedTitle(homeOddAtt, for: .normal)
        }
        
        
        
        _ = data.shengfu.visiCell.isSelected.asObserver()
            .subscribe({ [weak self](event) in
                guard let se = event.element else { return }
                self?.visiOdds.isSelected = se
                self?.seButton(isSelected: se, sender: (self?.visiOdds)!)
            })
        _ = data.shengfu.homeCell.isSelected.asObserver()
            .subscribe({ [weak self](event) in
                guard let se = event.element else { return }
                self?.homeOdds.isSelected = se
                self?.seButton(isSelected: se, sender: (self?.homeOdds)!)
            })
        
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
