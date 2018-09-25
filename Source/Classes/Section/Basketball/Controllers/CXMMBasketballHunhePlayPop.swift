//
//  CXMMBasketballHunhePlayPop.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMBasketballHunhePlayPop: BasePopViewController {

    @IBOutlet weak var playView : UIView!
    
    @IBOutlet weak var visiTeam : UILabel!
    @IBOutlet weak var homeTeam : UILabel!
    @IBOutlet weak var vsTeam : UILabel!
    // 胜负
    @IBOutlet weak var sfTitle : UILabel!
    @IBOutlet weak var sfVisiOdds : UIButton!
    @IBOutlet weak var sfHomeOdds : UIButton!
    
    // 让分
    @IBOutlet weak var rangFenTitle: UILabel!
    @IBOutlet weak var rfTitle : UILabel!
    @IBOutlet weak var rfVisiOdds : UIButton!
    @IBOutlet weak var rfHomeOdds : UIButton!
    // 大小分
    @IBOutlet weak var daxiaofenTitle: UILabel!
    @IBOutlet weak var dxfTitle : UILabel!
    @IBOutlet weak var dxfVisiOdds : UIButton!
    @IBOutlet weak var dxfHomeOdds : UIButton!
    // 胜分差
    @IBOutlet weak var shengfenchaTitle: UILabel!
    @IBOutlet weak var sfcVisiTitle : UILabel!
    @IBOutlet weak var sfcHomeTitle : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var confirm : UIButton!
    @IBOutlet weak var cancel  : UIButton!
    
    private var playInfo : BasketballListModel!
    
    private var viewModel : BBPlayModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
        setData()
    }

    private func setData() {
        sfTitle.text = "胜\n负"
        rfTitle.text = "让\n分"
        dxfTitle.text = "大\n小\n分"
        
        sfcVisiTitle.text = "客\n胜"
        sfcHomeTitle.text = "主\n胜"
        
        sfVisiOdds.titleLabel?.textAlignment = .center
        sfHomeOdds.titleLabel?.textAlignment = .center
        
        rfVisiOdds.titleLabel?.textAlignment = .center
        rfHomeOdds.titleLabel?.textAlignment = .center
        
        dxfVisiOdds.titleLabel?.textAlignment = .center
        dxfHomeOdds.titleLabel?.textAlignment = .center
        
        
    }
    
    private func initSubview() {
        self.viewHeight = 500
        
        playView.removeFromSuperview()
        
        self.pushBgView.addSubview(playView)
        
        playView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    @objc public override func backPopVC() {
        self.cancelClick(self.cancel)
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === self.pushBgView.superview {
            return true
        }
        if touch.view !== self.collectionView || touch.view !== self.pushBgView {
            return false
        }
        return true
    }
    
}
extension CXMMBasketballHunhePlayPop {
    @IBAction func confirmClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CXMMBasketballHunhePlayPop {
    // 胜负
    @IBAction func sfVisiClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
        viewModel.seSFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func sfHomeClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
        viewModel.seSFHomePlay(isSelected: sender.isSelected)
    }
    // 让分
    @IBAction func rfVisiClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
        viewModel.seRFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func rfHomeClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
        viewModel.seRFHomePlay(isSelected: sender.isSelected)
    }
    // 大小分
    @IBAction func dxfVisiClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
        viewModel.seDXFVisiPlay(isSelected: sender.isSelected)
    }
    @IBAction func dxfHomeClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        seButton(isSelected: sender.isSelected, sender: sender)
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

extension CXMMBasketballHunhePlayPop {
    
    public func configure(with data : BBPlayModel) {
        self.viewModel = data
        
        _ = data.shengfu.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.sfVisiOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.sfVisiOdds)
            })
        _ = data.shengfu.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.sfHomeOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.sfHomeOdds)
            })
        // 让分
        _ = data.rangfen.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.rfVisiOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.rfVisiOdds)
            })
        
        _ = data.rangfen.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.rfHomeOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.rfHomeOdds)
            })
        
        _ = data.daxiaofen.visiCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.dxfVisiOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.dxfVisiOdds)
            })
        
        _ = data.daxiaofen.homeCell.isSelected.asObserver()
            .subscribe({ (event) in
                guard let se = event.element else { return }
                self.dxfHomeOdds.isSelected = se
                self.seButton(isSelected: se, sender: self.dxfHomeOdds)
            })
    }
    
    public func configure(with data : BasketballListModel) {
        self.playInfo = data
        
        collectionView.reloadData()
        // 客队
        let visiAtt = NSMutableAttributedString(string: "[客]",
                                                    attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
        let visiTeamAtt = NSAttributedString(string: data.visitingTeamAbbr,
                                             attributes: [NSAttributedStringKey.foregroundColor: Color505050])
        visiAtt.append(visiTeamAtt)
        visiTeam.attributedText = visiAtt
        // 主队
        let homeAtt = NSMutableAttributedString(string: "[主]",
                                                attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F])
        let homeTeamAtt = NSAttributedString(string: data.homeTeamAbbr,
                                             attributes: [NSAttributedStringKey.foregroundColor: Color505050])
        homeAtt.append(homeTeamAtt)
        homeTeam.attributedText = homeAtt
        
        for playInfo in data.matchPlays {
            
            switch playInfo.playType {
            case "1": // 胜负
            
                switch playInfo.isShow {
                case false :
                    
                    let att = NSAttributedString(string: "未开售")
                    
                    sfVisiOdds.setAttributedTitle(att, for: .normal)
                    sfHomeOdds.setAttributedTitle(att, for: .normal)
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    sfVisiOdds.setAttributedTitle(visiOdds, for: .normal)
                    
                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds)
                    sfHomeOdds.setAttributedTitle(homeOdds, for: .normal)
                }
                
            case "2": // 让分胜负
                if let fix = playInfo.fixedOdds {
                    var color : UIColor
                    if fix.contains("-") {
                        color = Color44AE35
                    }else {
                        color = ColorEA5504
                    }
                    let titleAtt = NSMutableAttributedString(string: "主队让分 ")
                    let title = NSAttributedString(string: "\(fix)分", attributes: [NSAttributedStringKey.foregroundColor: color])
                    titleAtt.append(title)
                    rangFenTitle.attributedText = titleAtt
                }
                switch playInfo.isShow {
                case false :
                    
                    let att = NSAttributedString(string: "未开售")
                    
                    rfVisiOdds.setAttributedTitle(att, for: .normal)
                    rfHomeOdds.setAttributedTitle(att, for: .normal)
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    rfVisiOdds.setAttributedTitle(visiOdds, for: .normal)
                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds)
                    
                    rfHomeOdds.setAttributedTitle(homeOdds, for: .normal)
                }
                
            case "4": // 大小分
                if let fix = playInfo.fixedOdds {
            
                    let titleAtt = NSMutableAttributedString(string: "总分 ")
                    let title = NSAttributedString(string: "\(fix)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                    titleAtt.append(title)
                    daxiaofenTitle.attributedText = titleAtt
                }
                switch playInfo.isShow {
                case false :
                    let att = NSAttributedString(string: "未开售")
                    
                    dxfVisiOdds.setAttributedTitle(att, for: .normal)
                    dxfHomeOdds.setAttributedTitle(att, for: .normal)
                case true :
                    guard playInfo.homeCell != nil else { break }
                    guard playInfo.visitingCell != nil else { break }
                    
                    let visiOdds = getAttributedString(cellName: playInfo.visitingCell.cellName,
                                                       cellOdds: playInfo.visitingCell.cellOdds)
                    dxfVisiOdds.setAttributedTitle(visiOdds, for: .normal)
                    let homeOdds = getAttributedString(cellName: playInfo.homeCell.cellName,
                                                       cellOdds: playInfo.homeCell.cellOdds)
                    dxfHomeOdds.setAttributedTitle(homeOdds, for: .normal)
                }
            default : break
            }
        }

    }
    
    private func getAttributedString(cellName : String, cellOdds : String) -> NSAttributedString {
        let cellNameAtt = NSMutableAttributedString(string: cellName,
                                                    attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                                 NSAttributedStringKey.font : Font14])
        let cellOddsAtt = NSAttributedString(string: "\(cellOdds)",
            attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                         NSAttributedStringKey.font: Font12])
        
        cellNameAtt.append(cellOddsAtt)
        
        return cellNameAtt
    }
}

extension CXMMBasketballHunhePlayPop : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard viewModel.shengFenCha.isShow else { return }
            guard viewModel.shengFenCha.visiSFC.isEmpty == false else { return }
            viewModel.seSFCVisiPlay(isSelected: viewModel.shengFenCha.visiSFC[indexPath.row].selected, index: indexPath.row)
        case 1:
            guard viewModel.shengFenCha.isShow else { return }
            guard viewModel.shengFenCha.homeSFC.isEmpty == false else { return }
            viewModel.seSFCHomePlay(isSelected: viewModel.shengFenCha.homeSFC[indexPath.row].selected, index: indexPath.row)
        default : break
        }
    }
}
extension CXMMBasketballHunhePlayPop : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketballHunhePlayPopItem", for: indexPath) as! BasketballHunhePlayPopItem
        
        cell.index = indexPath.row
        for play in self.playInfo.matchPlays {
            switch play.playType {
            case "3":
                switch indexPath.section {
                case 0:
                    switch play.isShow {
                    case true :
                        if let visi = play.visitingCell {
                            cell.configure(with: visi.cellSons[indexPath.row], isShow: true)
                            cell.configureViewModel(with: viewModel.shengFenCha.visiSFC[indexPath.row], isShow: true)
                        }
                    case false:
                        cell.configure(with: nil, isShow: false)
                        cell.configureViewModel(with: nil , isShow: false)
                    }
                    
                case 1:
                    switch play.isShow {
                    case true :
                        if let home = play.homeCell {
                            cell.configure(with: home.cellSons[indexPath.row], isShow: true)
                            cell.configureViewModel(with: viewModel.shengFenCha.homeSFC[indexPath.row], isShow: true)
                        }
                    case false:
                        cell.configure(with: nil, isShow: false)
                        cell.configureViewModel(with: nil , isShow: false)
                    }
                    
                default : break
                }
                
                
            default: break
            }
        }
        
        cell.LeftLine.isHidden = true
        cell.topLine.isHidden = true
        if indexPath.section == 0{
            if indexPath.row < 3 {
                cell.topLine.isHidden = false
            }
        }
        return cell
    }
}
extension CXMMBasketballHunhePlayPop : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: BasketballHunhePlayPopItem.width, height: BasketballHunhePlayPopItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    

}
class HunheLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)
        for (index,value) in (answer?.enumerated())!
        {
            if index > 0{
                let currentLayoutAttributes :UICollectionViewLayoutAttributes = value
                let prevLayoutAttributes:UICollectionViewLayoutAttributes = answer![index - 1]
                let maximumSpacing = 0 //这里设置最大间距
                let origin = prevLayoutAttributes.frame.maxX
                if(origin + CGFloat(maximumSpacing) + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
                    var frame = currentLayoutAttributes.frame;
                    frame.origin.x = origin + CGFloat(maximumSpacing);
                    currentLayoutAttributes.frame = frame;
                }
            }
        }
        return answer
    }
}
