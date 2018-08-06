//
//  DaletouConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouConfirmCell: UITableViewCell {
    @IBOutlet weak var deleteBut: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func deleteClick(_ sender: UIButton) {
    }
    
    private var dataList : [DaletouDataModel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DaletouConfirmCell {
    public func configure(with data : [DaletouDataModel]) {
        self.dataList = data
        self.collectionView.reloadData()
    }
}
extension DaletouConfirmCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension DaletouConfirmCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.dataList != nil else { return 0 }
        return self.dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaletouConfirmItem", for: indexPath) as! DaletouConfirmItem
        cell.configure(with: self.dataList[indexPath.row])
        return cell
    }
}

extension DaletouConfirmCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}






