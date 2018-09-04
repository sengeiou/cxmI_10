//
//  PrizeDigitalHistoryCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PrizeDigitalHistoryCell: UITableViewCell {

    
    
    @IBOutlet weak var stageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var stateIcon: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PrizeDigitalHistoryCell {
    public func configure(with data : PrizeListModel, style : PrizeStyle) {
        stageLabel.text = data.period
        dateLabel.text = data.date
        viewModel.style = style
        switch data.lotteryId {
        case "8":
            viewModel.ballStyle = .square
        default:
            viewModel.ballStyle = .circular
        }
        viewModel.setData(red: data.redBall, blue: data.blueBall)
    }
}


extension PrizeDigitalHistoryCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension PrizeDigitalHistoryCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurprisePrizeDigitalItem", for: indexPath) as! SurprisePrizeDigitalItem
        cell.configure(with: list[indexPath.row], style: viewModel.ballStyle)
        return cell
    }
}

extension PrizeDigitalHistoryCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.ballStyle {
        case .square:
            return CGSize (width: SurprisePrizeDigitalItem.width / 2, height: SurprisePrizeDigitalItem.height)
        default:
            return CGSize (width: SurprisePrizeDigitalItem.width, height: SurprisePrizeDigitalItem.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.ballStyle {
        case .square:
            return 1
        default :
            return 0
        }
    }
}
