//
//  CXMMLeagueMatchVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum LeagueMatchStyle : String {
    case 热门 = "热门"
    case 国际 = "国际"
    case 欧洲 = "欧洲"
    case 亚洲 = "亚洲"
    case 美洲 = "美洲"
    case 非洲 = "非洲"
}

class CXMMLeagueMatchVC: BaseViewController, IndicatorInfoProvider {
    
    public var style : LeagueMatchStyle = .国际

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var leagueMatchList : [LeagueMatchModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.headerRefresh {
            self.loadNewData()
        }
        collectionView.beginRefreshing()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: style.rawValue)
    }

}

extension CXMMLeagueMatchVC {
    private func loadNewData() {
        leagueListRequest()
    }
    private func leagueListRequest() {
        
        weak var weakSelf = self
        
        var groupId = "4"
        
        switch style {
        case .国际:
            groupId = "4"
        case .欧洲:
            groupId = "1"
        case .亚洲:
            groupId = "3"
        case .美洲:
            groupId = "2"
        case .非洲:
            groupId = "5"
        default: break
        }
        
        _ = surpriseProvider.rx.request(.leagueList(groupId: groupId))
            .asObservable()
            .mapArray(type: LeagueMatchModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.collectionView.endrefresh()
                
                weakSelf?.leagueMatchList = data
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


extension CXMMLeagueMatchVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension CXMMLeagueMatchVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagueMatchList != nil ? leagueMatchList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueMatchItem", for: indexPath) as! LeagueMatchItem
        cell.configure(with: leagueMatchList[indexPath.row])
        
        //if indexPath.row == 2 || indexPath
        
        
        cell.bottomLine.isHidden = true
        
//        if (indexPath.row + 1) % 3 == 0 || leagueMatchList.count == indexPath.row + 1 {
//            cell.rightLine.isHidden = false
//        }else {
//            cell.rightLine.isHidden = true
//        }
        
        if indexPath.row == 0 || (indexPath.row + 1) % 4 == 0 || (indexPath.row + 1) % 4 == 3 {
            cell.leftLine.isHidden = false
        }else {
            cell.leftLine.isHidden = true
        }
        
        if leagueMatchList.count - indexPath.row < 4 {
            cell.bottomLine.isHidden = false
        }
        
        
        return cell
    }
}
extension CXMMLeagueMatchVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LeagueMatchItem.width, height: LeagueMatchItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
