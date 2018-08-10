//
//  DLTTrendBallCollectionView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum TrendBallCollectionStyle {
    case red
    case blue
}

class DLTTrendBallCollectionView: UICollectionView {

    private var list : [DaletouDataModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
}

extension DLTTrendBallCollectionView {
    public func configure(with list : [DaletouDataModel]) {
        self.list = list
        self.reloadData()
    }
}

extension DLTTrendBallCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        list[indexPath.row].selected = !list[indexPath.row].selected
        self.reloadData()
    }
}
extension DLTTrendBallCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTTrendBallItem", for: indexPath) as! DLTTrendBallItem
        cell.configure(with: list[indexPath.row])
        return cell
    }
    
    
}

extension DLTTrendBallCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DLTTrendBallItem.width, height: DLTTrendBallItem.heiht)
    }
}
