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
    
    // 左对齐等间距布局 (设置了最大间距)
    
}
extension CXMMBasketballHunhePlayPop {
    @IBAction func confirmClick(_ sender: UIButton) {
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
    }
}
extension CXMMBasketballHunhePlayPop {
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
                    
                    let att = NSAttributedString(string: "停售")
                    
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
                    
                    let att = NSAttributedString(string: "停售")
                    
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
                    let att = NSAttributedString(string: "停售")
                    
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
        
        for play in self.playInfo.matchPlays {
            switch play.playType {
            case "3":
                switch indexPath.section {
                case 0:
                    if let visi = play.visitingCell {
                         cell.configure(with: visi.cellSons[indexPath.row])
                    }
                case 1:
                    if let home = play.homeCell {
                        cell.configure(with: home.cellSons[indexPath.row])
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
