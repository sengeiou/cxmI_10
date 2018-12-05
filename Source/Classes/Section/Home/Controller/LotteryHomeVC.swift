//
//  LotteryHomeVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class LotteryHomeVC: BaseViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

extension LotteryHomeVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension LotteryHomeVC : UICollectionViewDataSource {
    private func setCollectionView() {
        collectionView.register(HomeFootballCell.self, forCellWithReuseIdentifier: HomeFootballCell.identifier)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFootballCell.identifier, for: indexPath) as! HomeFootballCell
        return cell
    }
}

extension LotteryHomeVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FootballSportCellWidth, height: FootballSportCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellLineSportSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellInteritemSportSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: HomesectionTopSportSpacing, left: 20.0, bottom: HomesectionTopSportSpacing, right: 20.0)
    }
}
