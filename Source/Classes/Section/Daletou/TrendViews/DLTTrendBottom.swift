//
//  DLTTrendBottom.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTTrendBottom: UIView {
    @IBOutlet weak var redCollectionView : UICollectionView!
    @IBOutlet weak var blueCollectionView : UICollectionView!
    
    private var redList : [DaletouDataModel]!
    private var blueList : [DaletouDataModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.redCollectionView.delegate = self
//        self.blueCollectionView.delegate = self
    }
}

extension DLTTrendBottom {
    public func configure(red : [DaletouDataModel], blue : [DaletouDataModel]) {
        self.redList = red
        self.blueList = blue
        self.redCollectionView.reloadData()
        self.blueCollectionView.reloadData()
    }
}

extension DLTTrendBottom : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.redCollectionView {
            redList[indexPath.row].selected = !redList[indexPath.row].selected
            collectionView.reloadData()
        }else if collectionView == self.blueCollectionView {
            blueList[indexPath.row].selected = !blueList[indexPath.row].selected
            collectionView.reloadData()
        }
    }
}

extension DLTTrendBottom : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.redCollectionView {
            return redList != nil ? redList.count : 0
        }
        else if collectionView == self.blueCollectionView {
            return blueList != nil ? blueList.count : 0
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTTrendBallItem", for: indexPath) as! DLTTrendBallItem
        
        if collectionView == self.redCollectionView {
            cell.configure(with: redList[indexPath.row])
        }
        else if collectionView == self.blueCollectionView {
            cell.configure(with: blueList[indexPath.row])
        }
        
        
        return cell
    }
    
    
}

extension DLTTrendBottom : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DLTTrendBallItem.width, height: DLTTrendBallItem.heiht)
    }
}
