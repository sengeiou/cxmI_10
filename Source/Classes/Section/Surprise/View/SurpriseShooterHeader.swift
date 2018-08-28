//
//  SurpriseShooterHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseShooterHeader: UITableViewHeaderFooterView {

    static let identifier = "SurpriseShooterHeader"
    
    private var collectionView : UICollectionView!
    
    public var viewModel : ShooterHeaderViewModel! {
        didSet{
            initViewModel()
            self.collectionView.reloadData()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initViewModel() {
        guard viewModel != nil else { return }
         _ = viewModel.selectedItem.asObserver()
            .subscribe(onNext: { (index) in
                self.collectionView.reloadData()
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
    
    private func initSubview() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = ColorF4F4F4
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SurpriseShooterHeaderItem.self, forCellWithReuseIdentifier: SurpriseShooterHeaderItem.identifier)
        
        self.contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SurpriseShooterHeader : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = collectionView.cellForItem(at: indexPath) as! SurpriseShooterHeaderItem
//        item.title.textColor = ColorE85504
        viewModel.selectedItem(index: indexPath.row)
    }
}
extension SurpriseShooterHeader : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurpriseShooterHeaderItem.identifier, for: indexPath) as! SurpriseShooterHeaderItem
        
        if viewModel.headerList[indexPath.row].selected {
            cell.title.textColor = ColorE85504
        }else {
            cell.title.textColor = Color505050
        }
        
        cell.title.text = viewModel.headerList[indexPath.row].title
        
//        switch indexPath.row {
//        case 0:
//            cell.title.text = "英超-射手榜"
//        case 1:
//            cell.title.text = "德甲-射手榜"
//        case 2:
//            cell.title.text = "意甲-射手榜"
//        case 3:
//            cell.title.text = "西甲-射手榜"
//        case 4:
//            cell.title.text = "法甲-射手榜"
//        default:
//            cell.title.text = ""
//        }
        return cell
    }
}

extension SurpriseShooterHeader : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SurpriseShooterHeaderItem.width, height: SurpriseShooterHeaderItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
