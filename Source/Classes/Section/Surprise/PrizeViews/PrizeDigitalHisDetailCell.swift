//
//  PrizeDigitalHisDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PrizeDigitalHisDetailCell: UITableViewCell {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var termNumber : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    
    private var list : [DigitalBallData]!
    
    private var viewModel : DigitalHisViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension PrizeDigitalHisDetailCell {
    public func configure(with data : DigitalHisViewModel) {
        title.text = data.style.rawValue
        termNumber.text = data.lottoDetailData.period
        dateLabel.text = data.lottoDetailData.prizeDate
        
        list = data.ballList
        viewModel = data
        collectionView.reloadData()
    }
}
extension PrizeDigitalHisDetailCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension PrizeDigitalHisDetailCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurprisePrizeDigitalItem", for: indexPath) as! SurprisePrizeDigitalItem
        cell.configure(with: list[indexPath.row], style: viewModel.style)
        return cell
    }
}

extension PrizeDigitalHisDetailCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch viewModel.ballStyle {
//        case .square:
//            return CGSize (width: SurprisePrizeDigitalItem.width / 2, height: SurprisePrizeDigitalItem.height)
//        default:
//            return CGSize (width: SurprisePrizeDigitalItem.width, height: SurprisePrizeDigitalItem.height)
//        }
        
        return CGSize (width: SurprisePrizeDigitalItem.width, height: SurprisePrizeDigitalItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        switch viewModel.ballStyle {
//        case .square:
//            return 1
//        default :
//            return 1
//        }
        
        return 1
    }
}

