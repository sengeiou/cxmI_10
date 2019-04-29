//
//  SurpriseHomeMoreVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/4.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class SurpriseHomeMoreVC: BaseViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    private var list : [HomeFindModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "更多"
        setCollectionView()
        surpriseMoreRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

extension SurpriseHomeMoreVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = list[indexPath.row]
        pushRouterVC(urlStr: model.redirectUrl, from: self)
    }
}

extension SurpriseHomeMoreVC : UICollectionViewDataSource {
    private func setCollectionView() {
        collectionView.register(HomeFootballCell.self, forCellWithReuseIdentifier: HomeFootballCell.identifier)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFootballCell.identifier, for: indexPath) as! HomeFootballCell
        cell.configure(with: list[indexPath.row])
        return cell
    }
}

extension SurpriseHomeMoreVC : UICollectionViewDelegateFlowLayout {
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
// MARK: - 网络请求
extension SurpriseHomeMoreVC {
    private func surpriseMoreRequest() {
        weak var weakSelf = self
        _ = surpriseProvider.rx.request(.surpriseMoreList).asObservable()
            .mapArray(type: HomeFindModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.list = data
                weakSelf?.collectionView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
