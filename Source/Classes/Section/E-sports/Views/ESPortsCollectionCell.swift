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


class ESPortsCollectionCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    public var playModel : ESportsPlayModel!
    
    public var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension ESPortsCollectionCell : UICollectionViewDelegate {
    
}
extension ESPortsCollectionCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ESPortsCollectionItem", for: indexPath) as! ESPortsCollectionItem
        
        let item = playModel.items[indexPath.row]
        
        switch indexPath.section {
        case 0:
            item.text.bind(to: cell.title.rx.title()).disposed(by: bag)
        case 1:
            item.text.bind(to: cell.title.rx.title()).disposed(by: bag)
        default: break
            
        }
        
        return cell
    }
    
    
}
extension ESPortsCollectionCell : UICollectionViewDelegateFlowLayout {
    
}
