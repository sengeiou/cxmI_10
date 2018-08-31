//
//  CXMMLeagueMatchFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMLeagueMatchFilterVC: BasePopViewController {

    private var collectionView : UICollectionView!
    
    private var bottomView: BottomView!
    
    private var titleLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popStyle = .fromCenter
        initSubview()
    }

    private func initSubview() {
        collectionView = UICollectionView()
        collectionView.register(LeagueMatchFilterItem.self,
                                forCellWithReuseIdentifier: LeagueMatchFilterItem.identifier)
        
        titleLabel = UILabel()
        titleLabel.font = Font13
        titleLabel.textColor = Color505050
        titleLabel.textAlignment = .center
        titleLabel.text = "西班牙"
        
        bottomView = BottomView()
        bottomView.delegate = self
        
        
        self.pushBgView.addSubview(titleLabel)
        self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(bottomView.snp.top).offset(-20)
        }
    }
}

extension CXMMLeagueMatchFilterVC : BottomViewDelegate {
    func didTipConfitm() {
        
    }
    
    func didTipCancel() {
        
    }
}

extension CXMMLeagueMatchFilterVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension CXMMLeagueMatchFilterVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeagueMatchFilterItem.identifier, for: indexPath) as! LeagueMatchFilterItem
        
        return cell
    }
}

extension CXMMLeagueMatchFilterVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LeagueMatchFilterItem.width, height: LeagueMatchFilterItem.height)
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











