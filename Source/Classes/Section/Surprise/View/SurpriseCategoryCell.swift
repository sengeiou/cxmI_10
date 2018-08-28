//
//  SurpriseCategoryCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum SurpriseCategoryType {
    case category
    case hotLeague
}

protocol SurpriseCategoryCellDelegate {
    func didSelectItem(info : SurpriseItemInfo ,indexPath: IndexPath) -> Void
}

class SurpriseCategoryCell: UITableViewCell {

    public var delegate : SurpriseCategoryCellDelegate!
    
    public var style : SurpriseCategoryType = .category
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var itemList : [SurpriseItemInfo]!
    private var hotItemList : [SurpriseLeagueInfo]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        self.collectionView.isScrollEnabled = false
    }

}

extension SurpriseCategoryCell {
    public func configure(with list : [SurpriseItemInfo]) {
        self.itemList = list
        self.collectionView.reloadData()
    }
    public func configure(with list : [SurpriseLeagueInfo]) {
        self.hotItemList = list
        self.collectionView.reloadData()
    }
}

extension SurpriseCategoryCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        delegate.didSelectItem(info: itemList[indexPath.row], indexPath: indexPath)
    }
}

extension SurpriseCategoryCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch style {
        case .category:
            return itemList != nil ? itemList.count : 0
        case .hotLeague:
            return hotItemList != nil ? hotItemList.count : 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseCollectionCell", for: indexPath) as! SurpriseCollectionCell
        
        switch style {
        case .category:
            cell.configure(with: itemList[indexPath.row])
        case .hotLeague:
            cell.configure(with: hotItemList[indexPath.row])
        }
        
        return cell
    }
}

extension SurpriseCategoryCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SurpriseCollectionCell.width, height: SurpriseCollectionCell.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
