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
    
    private var leagueMatchModel : LeagueMatchListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setEmpty(title: "暂无数据", collectionView)
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
            .mapObject(type: LeagueMatchListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.collectionView.endrefresh()
                
                weakSelf?.leagueMatchModel = data
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

extension CXMMLeagueMatchVC : LeagueMatchFilterDelegate {
    func didSelectItem(leagueInfo: LeagueInfoModel) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        
        let detail = story.instantiateViewController(withIdentifier: "LeagueMatchDetailVC") as! CXMMLeagueMatchDetailVC
        
        detail.leagueInfo = leagueInfo
        
        pushViewController(vc: detail)
    }
}
extension CXMMLeagueMatchVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch style {
        case .国际:
            let story = UIStoryboard(name: "Surprise", bundle: nil)
            
            let detail = story.instantiateViewController(withIdentifier: "LeagueMatchDetailVC") as! CXMMLeagueMatchDetailVC
            
            detail.leagueInfo = leagueMatchModel.groupLeagues[indexPath.row]
            
            pushViewController(vc: detail)
        default:
            let match = CXMMLeagueMatchFilterVC()
            match.delegate = self
            match.leagueMatch = leagueMatchModel.contrys[indexPath.row]
            present(match)
        }
        
        
    }
}
extension CXMMLeagueMatchVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch style {
        case .国际:
            return 1
        default:
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch style {
        case .国际:
            return leagueMatchModel != nil ? leagueMatchModel.groupLeagues.count : 0
        default:
            switch section {
            case 0:
                return leagueMatchModel != nil ? leagueMatchModel.contrys.count : 0
            case 1:
                return leagueMatchModel != nil ? leagueMatchModel.groupLeagues.count : 0
            default : return 0
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueMatchItem", for: indexPath) as! LeagueMatchItem
        
        switch style {
        case .国际:
            cell.configure(with: leagueMatchModel.groupLeagues[indexPath.row])
        default:
            switch indexPath.section {
            case 0:
                cell.configure(with: leagueMatchModel.contrys[indexPath.row])
            case 1:
                cell.configure(with: leagueMatchModel.groupLeagues[indexPath.row])
            default : break
            }
            
        }
        
        cell.topLine.isHidden = true
        
        if indexPath.row == 0 || (indexPath.row + 1) % 3 == 1 {
            cell.leftLine.isHidden = false
        }else {
            cell.leftLine.isHidden = true
        }
        
        if indexPath.row < 3 {
            cell.topLine.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "LeagueMatchReusableView", for: indexPath) as! LeagueMatchReusableView
        
        return header
    }
    
}
extension CXMMLeagueMatchVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LeagueMatchItem.width, height: LeagueMatchItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
