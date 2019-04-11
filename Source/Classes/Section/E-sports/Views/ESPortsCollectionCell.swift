//
//  ESPortsCollectionCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/3/1.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ESPortsCollectionCellProtocol {
    func didTipItem(view : ESPortsCollectionCell, type : ItemType, section : Int, index : Int) -> Void
}

class ESPortsCollectionCell: UITableViewCell {

    public var delegate : ESPortsCollectionCellProtocol!
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    public var playModel : ESportsPlayModel!
    
    public var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}

extension ESPortsCollectionCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        switch indexPath.section {
        case 0:
            delegate.didTipItem(view: self, type: .homeTeam, section : self.tag, index: indexPath.row)
        case 1:
            delegate.didTipItem(view: self, type: .visiTeam, section : self.tag, index: indexPath.row)
        default: break
        }
    }
}
extension ESPortsCollectionCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return playModel.homeItems.count
        case 1:
            return playModel.visiItems.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ESPortsCollectionItem", for: indexPath) as! ESPortsCollectionItem
        
        switch indexPath.section {
        case 0:
            let item = playModel.homeItems[indexPath.row]
            item.attText.bind(to: cell.title.rx.attributedText).disposed(by: bag)
            item.itemBackgroundColor.bind(to: cell.title.rx.backgroundColor).disposed(by: bag)
        case 1:
            let item = playModel.visiItems[indexPath.row]
            item.attText.bind(to: cell.title.rx.attributedText).disposed(by: bag)
            item.itemBackgroundColor.bind(to: cell.title.rx.backgroundColor).disposed(by: bag)
        default: break
            
        }
        
        return cell
    }
    
    
}
extension ESPortsCollectionCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: playModel.itemWidth, height: playModel.itemheight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
}
