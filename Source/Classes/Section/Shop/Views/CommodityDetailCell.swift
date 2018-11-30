//
//  CommodityDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityDetailCell: UITableViewCell {

    @IBOutlet weak var collectionView : UICollectionView!
    
    private var dataList : [String]!
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        collectionView.isScrollEnabled = false
    }

}

extension CommodityDetailCell {
    public func configure(with data : [String]) {
        dataList = data
        collectionView.reloadData()
    }
}
extension CommodityDetailCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommodityDetailItem", for: indexPath) as! CommodityDetailItem
        cell.configure(with: dataList[indexPath.row])
        return cell
    }
}

extension CommodityDetailCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommodityDetailItem.width, height: CommodityDetailItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
