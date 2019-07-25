//
//  BasketballConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

protocol BasketballConfirmCellDelegate {
    func didTipDelete(playInfo : BBPlayModel) -> Void
    func didTipDan(playInfo : BBPlayModel) -> Void
}

class BasketballConfirmCell: UITableViewCell, DateProtocol {

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
    
    @IBOutlet weak var visiOdds : UIButton!
    @IBOutlet weak var homeOdds : UIButton!
    
    private var viewModel : BBPlayModel!
    
    private var conViewModel : BBConfirmViewModel!
    
    private var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
        setData()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    private func setData() {
        
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
        switch viewModel.playType {
        case .胜负:
            conViewModel.seSFVisiPlay(play: viewModel)
        case .让分胜负:
            conViewModel.seRFVisiPlay(play: viewModel)
        case .大小分:
            conViewModel.seDXFVisiPlay(play: viewModel)
        default:
            break
        }
        
    }
    @IBAction func homeClick(_ sender : UIButton) {
        switch viewModel.playType {
        case .胜负:
            conViewModel.seSFHomePlay(play: viewModel)
        case .让分胜负:
            conViewModel.seRFHomePlay(play: viewModel)
        case .大小分:
            conViewModel.seDXFHomePlay(play: viewModel)
        default:
            break
        }
    }
    
    @IBAction func deleteClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDelete(playInfo: self.viewModel)
    }
    @IBAction func danClick(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDan(playInfo: self.viewModel)
    }
}

extension BasketballConfirmCell {
    public func configure(with data : BBPlayModel, viewMo : BBConfirmViewModel) {
        self.viewModel = data
        
//        data.confirmViewModel = viewMo
        self.conViewModel = viewMo
        // 场次信息
        self.changciLabel.text =  "\(data.playInfo.leagueAddr) \(data.playInfo.changci) \(self.timeStampToHHmm(data.playInfo.betEndTime))"
        
        
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

        // 赔率 // 单关显示
        
        var isShow : Bool
        var playInfo : BBPlayInfoModel!
        
        switch data.playType {
        case .胜负:
            isShow = data.shengfu.isShow
            playInfo = data.shengfu
            singleState(single: data.shengfu.single)
            
            _ = data.shengfu.visiCell.isSelected.asObserver()
                .subscribe({ [weak self](event) in
                    guard let se = event.element else { return }
                    self?.visiOdds.isSelected = se
                    self?.seButton(isSelected: se, sender: (self?.visiOdds)!)
                }).disposed(by: bag)
            _ = data.shengfu.homeCell.isSelected.asObserver()
                .subscribe({ [weak self](event) in
                    guard let se = event.element else { return }
                    self?.homeOdds.isSelected = se
                    self?.seButton(isSelected: se, sender: (self?.homeOdds)!)
                }).disposed(by: bag)
        case .让分胜负:
            isShow = data.rangfen.isShow
            playInfo = data.rangfen
            singleState(single: data.rangfen.single)
            
            _ = data.rangfen.visiCell.isSelected.asObserver()
                .subscribe({ [weak self](event) in
                    guard let se = event.element else { return }
                    self?.visiOdds.isSelected = se
                    self?.seButton(isSelected: se, sender: (self?.visiOdds)!)
                }).disposed(by: bag)
            _ = data.rangfen.homeCell.isSelected.asObserver()
                .subscribe({ [weak self](event) in
                    guard let se = event.element else { return }
                    self?.homeOdds.isSelected = se
                    self?.seButton(isSelected: se, sender: (self?.homeOdds)!)
                }).disposed(by: bag)
        case .大小分:
            isShow = data.daxiaofen.isShow
            playInfo = data.daxiaofen
            singleState(single: data.daxiaofen.single)
            
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
        default:
            isShow = false
            singleState(single: false)
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
        
        
        
        
        
       
        
        // 胆
        
        _ = Observable.combineLatest(data.canSetDan, data.isDan).asObservable()
            .subscribe({ [weak self](event) in
                guard let canSet = event.element?.0 else { return }
                guard let isDan = event.element?.1 else { return }
                
                switch canSet {
                case true:
                    
                    switch isDan {
                    case true :
                        self?.danButton.layer.borderColor = ColorEA5504.cgColor
                        self?.danButton.setTitleColor(ColorEA5504, for: .normal)
                    case false :
                        self?.danButton.layer.borderColor = ColorC8C8C8.cgColor
                        self?.danButton.setTitleColor(ColorC8C8C8, for: .normal)
                    }
                    
                    self?.danButton.isUserInteractionEnabled = true
                    
                case false :
                    self?.danButton.isUserInteractionEnabled = false
                    self?.danButton.layer.borderColor = ColorEDEDED.cgColor
                    self?.danButton.setTitleColor(ColorEDEDED, for: .normal)
                }
            }).disposed(by: bag)

    }
    
    private func singleState(single : Bool) {
        self.singleIcon.isHidden = !single
    }
    
    private func getAttributedString(cellName : String, cellOdds : String) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedString.Key.foregroundColor: Color505050,
                                                                 NSAttributedString.Key.font : Font14])
        let cellOddsAtt = NSAttributedString(string: "\n\(cellOdds)",
            attributes: [NSAttributedString.Key.foregroundColor: Color9F9F9F,
                         NSAttributedString.Key.font: Font12])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
}
