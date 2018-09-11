//
//  CXMMLeagueHotVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMLeagueHotVC:  BaseViewController, IndicatorInfoProvider {

    public var contryId : String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var leagueList : [LeagueInfoModel]! {
        didSet{
            guard leagueList != nil else { return }
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.headerRefresh {
            self.loadNewData()
        }
        collectionView.beginRefreshing()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "热门")
    }

}

extension CXMMLeagueHotVC {
    private func loadNewData() {
        leagueListRequest()
    }
    private func leagueListRequest() {
        
         weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.leagueList(groupId: "0"))
            .asObservable()
            .mapObject(type: LeagueMatchListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.collectionView.endrefresh()
                
                weakSelf?.leagueList = data.groupLeagues
                weakSelf?.collectionView.reloadData()

            }, onError: { (error) in
                weakSelf?.collectionView.endrefresh()
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

extension CXMMLeagueHotVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        
        let detail = story.instantiateViewController(withIdentifier: "LeagueMatchDetailVC") as! CXMMLeagueMatchDetailVC
        
        detail.leagueInfo = leagueList[indexPath.row]
        
        pushViewController(vc: detail)
    }
}
extension CXMMLeagueHotVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagueList != nil ? leagueList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseMatchItem", for: indexPath) as! SurpriseMatchItem
        cell.configure(with: leagueList[indexPath.row])
        return cell
    }
}
extension CXMMLeagueHotVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SurpriseMatchItem.width, height: SurpriseMatchItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 16, bottom: 10, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
