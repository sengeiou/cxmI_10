//
//  DaletouConfirmCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

protocol DaletouConfirmCellDelegate {
    func didTipDelete(model : DaletouDataList) -> Void
}

class DaletouConfirmCell: UITableViewCell {
    
    public var delegate : DaletouConfirmCellDelegate!
    
    @IBOutlet weak var deleteBut: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBAction func deleteClick(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.didTipDelete(model: self.data)
    }
    
    private var dataList : [DaletouDataModel]!
    private var data : DaletouDataList!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DaletouConfirmCell {
    public func configure(with data : DaletouDataList) {
        self.data = data
        let detail = "\(data.bettingNum)注 \(data.multiple)倍 \(data.bettingNum * data.money * data.multiple).00"
        
        switch data.type {
        case .标准选号:
            var arr = data.redList
            arr.append(contentsOf: data.blueList)
            self.dataList = arr
            
            
            
            if self.dataList.count > 7 {
                self.detailLabel.text = "复试 \(detail)"
            }
            else {
                self.detailLabel.text = "单式 \(detail)"
            }
            
        case .胆拖选号:
            var arr = data.danRedList
            
            let model1 = DaletouDataModel()
            model1.num = "-"
            model1.style = .red
            arr.append(model1)
            
            arr.append(contentsOf: data.dragRedList)
            if data.danBlueList.count > 0 {
                arr.append(model1)
            }
            arr.append(contentsOf: data.danBlueList)
            arr.append(model1)
            arr.append(contentsOf: data.dragBlueList)
            
            self.dataList = arr
            self.detailLabel.text = "胆拖 \(detail)"
        }
        
        
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






