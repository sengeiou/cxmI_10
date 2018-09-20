//
//  CXMMBasketballSFCPlayPop.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMBasketballSFCPlayPop: BasePopViewController {

    @IBOutlet weak var shenfenchaView : UIView!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var visiTeam : UILabel!
    @IBOutlet weak var vsTeam : UILabel!
    @IBOutlet weak var homeTeam : UILabel!
    
    @IBOutlet weak var visiTitle : UILabel!
    @IBOutlet weak var homeTitle : UILabel!
    
    @IBOutlet weak var confirm : UIButton!
    @IBOutlet weak var cancel  : UIButton!
    
    private var playInfo : BasketballListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        setData()
        initSubview()
    }

    private func setData(){
        visiTitle.text = "客\n队"
        homeTitle.text = "主\n队"
    }
    
    private func initSubview() {
        self.viewHeight = 270
        
        self.shenfenchaView.removeFromSuperview()
        
        self.pushBgView.addSubview(self.shenfenchaView)
        shenfenchaView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    
}

extension CXMMBasketballSFCPlayPop {
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
    }
}
// MARK: - 确认，，取消，，点击事件
extension CXMMBasketballSFCPlayPop {
    @IBAction func confirmClick(_ sender : UIButton) {
        
    }
    @IBAction func cancelClick(_ sender : UIButton) {
        
    }
}

extension CXMMBasketballSFCPlayPop : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CXMMBasketballSFCPlayPop : UICollectionViewDataSource {
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
                    
                    switch play.isShow {
                    case true :
                        if let visi = play.visitingCell {
                            cell.configure(with: visi.cellSons[indexPath.row], isShow: true)
                        }
                    case false:
                        cell.configure(with: nil, isShow: false)
                    }
                    
                case 1:
                    switch play.isShow {
                    case true :
                        if let home = play.homeCell {
                            cell.configure(with: home.cellSons[indexPath.row], isShow: true)
                        }
                    case false:
                        cell.configure(with: nil, isShow: false)
                    }
                    
                default : break
                }
                
                
            default: break
            }
        }
        
        cell.LeftLine.isHidden = true
        cell.topLine.isHidden = true
        
        if indexPath.row < 3 {
            cell.topLine.isHidden = false
        }
        
        return cell
    }
}
extension CXMMBasketballSFCPlayPop : UICollectionViewDelegateFlowLayout {
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
        switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        default:
            return CGSize(width: 1, height: 18)
        }
        
    }
}
