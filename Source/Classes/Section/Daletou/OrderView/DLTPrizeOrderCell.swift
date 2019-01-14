//
//  DLTPrizeOrderCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTPrizeOrderCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    private var itemList : [DLTOrderItemInfo]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isScrollEnabled = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension DLTPrizeOrderCell {
    public func configure(with orderInfo : DLTOrderResult) {
        var type = ""
        var append = ""
        switch orderInfo.playType {
        case "0":
            type = "单式"
            self.itemList = getStandardData(orderInfo)
        case "1":
            type = "复式"
            self.itemList = getStandardData(orderInfo)
        case "2":
            type = "胆拖"
            self.itemList = getDanData(orderInfo)
        default: break
        }
        
        switch orderInfo.isAppend {
        case "0":
            append = ""
        case "1":
            append = "已追加"
        default: break
        }
        
        detailLabel.text = type + " \(orderInfo.betNum)注" + " \(orderInfo.cathectic)倍" + " \(orderInfo.amount).00" + append
         
        
        self.collectionView.reloadData()
    }
    private func getStandardData(_ orderInfo : DLTOrderResult) -> [DLTOrderItemInfo] {
        guard let reds  = orderInfo.redCathectics else { fatalError("红球为空") }
        guard let blues = orderInfo.blueCathectics else { fatalError("篮球为空") }
        
        var list = [DLTOrderItemInfo]()
        
        for model in reds {
            model.style = .red
        }
        for model in blues {
            model.style = .blue
        }
        
        list.append(contentsOf: reds)
        list.append(contentsOf: blues)
        
        return list
    }
    private func getDanData(_ orderInfo : DLTOrderResult) -> [DLTOrderItemInfo] {
        var list = [DLTOrderItemInfo]()
        
        guard let danReds = orderInfo.redDanCathectics else { fatalError("红胆为空") }
        guard let dragReds = orderInfo.redTuoCathectics else { fatalError("红拖为空") }
        guard let dragBlues = orderInfo.blueTuoCathectics else { fatalError("蓝拖为空") }
        
        
        for model in danReds {
            model.style = .danRed
        }
        for model in dragReds {
            model.style = .dragRed
        }
        
        if let danBlues = orderInfo.blueDanCathectics {
            for model in danBlues {
                model.style = .danBlue
            }
        }
        
        for model in dragBlues {
            model.style = .dragBlue
        }
        
        list.append(contentsOf: danReds)
        let line = DLTOrderItemInfo()
        line.style = .line
        
        list.append(line)
        
        list.append(contentsOf: dragReds)
        
        list.append(line)
        if let danBlues = orderInfo.blueDanCathectics {
            list.append(contentsOf: danBlues)
            if danBlues.isEmpty == false {
                list.append(line)
            }
        }

        list.append(contentsOf: dragBlues)
        
        return list
    }
}

extension DLTPrizeOrderCell : UICollectionViewDelegate {
    
}
extension DLTPrizeOrderCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList != nil ? itemList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTOrderItem", for: indexPath) as! DLTOrderItem
        cell.configure(with: itemList[indexPath.row])
        
        return cell
    }
    
}
extension DLTPrizeOrderCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DLTOrderItem.width, height: DLTOrderItem.heiht)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
