//
//  SurpriseMatchCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol SurpriseMatchCellDelegate {
    func didSelectItem(info : LeagueInfoModel ,indexPath: IndexPath) -> Void
}

class SurpriseMatchCell: UITableViewCell {

    public var delegate : SurpriseMatchCellDelegate!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var itemList : [LeagueInfoModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
extension SurpriseMatchCell {
    public func configure(with list : [SurpriseItemInfo]) {
        //self.itemList = list
        
        self.collectionView.reloadData()
    }
    
    public func configure(with list : [LeagueInfoModel]) {
        self.itemList = list
        
        self.collectionView.reloadData()
    }
}

extension SurpriseMatchCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        delegate.didSelectItem(info: itemList[indexPath.row], indexPath: indexPath)
    }
}

extension SurpriseMatchCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList != nil ? itemList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseMatchItem", for: indexPath) as! SurpriseMatchItem
        cell.configure(with: itemList[indexPath.row])
        
        cell.topLine.isHidden = true
        if indexPath.row == 0 || (indexPath.row + 1) % 4 == 1 {
            cell.leftLine.isHidden = false
        }else {
            cell.leftLine.isHidden = true
        }
        
        if indexPath.row < 4 {
            cell.topLine.isHidden = false
        }
        return cell
    }
}

extension SurpriseMatchCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 32) / 4 - 0.01, height: SurpriseMatchItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
