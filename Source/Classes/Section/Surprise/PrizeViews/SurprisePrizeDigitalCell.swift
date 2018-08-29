//
//  SurprisePrizeDigitalCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurprisePrizeDigitalCell: UITableViewCell {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var stageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    public var style : PrizeStyle!
    
    public var viewModel : PrizeDigitalViewModel = PrizeDigitalViewModel()
    
    private var list : [PrizeDigitalData]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        _ = viewModel.list.asObserver()
            .subscribe(onNext: { (list) in
                self.list = list
                self.collectionView.reloadData()
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
}

extension SurprisePrizeDigitalCell {
    public func configure(with data : PrizeListModel, style : PrizeStyle) {
        if let url = URL(string: data.lotteryIcon) {
            icon.kf.setImage(with: url)
        }
        title.text = data.lotteryName
        stageLabel.text = data.period
        dateLabel.text = data.date
        viewModel.style = style
        viewModel.setData(red: data.redBall, blue: data.blueBall)
        
    }
    
    
}


extension SurprisePrizeDigitalCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension SurprisePrizeDigitalCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurprisePrizeDigitalItem", for: indexPath) as! SurprisePrizeDigitalItem
        cell.configure(with: list[indexPath.row])
        return cell
    }
}

extension SurprisePrizeDigitalCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: SurprisePrizeDigitalItem.width, height: SurprisePrizeDigitalItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
