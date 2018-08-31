//
//  CXMMLeaguePagerVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMLeaguePagerVC: BasePagerViewController {

    private var hot : CXMMLeagueHotVC!
    private var international : CXMMLeagueMatchVC!
    private var europe : CXMMLeagueMatchVC!
    private var asia : CXMMLeagueMatchVC!
    private var america : CXMMLeagueMatchVC!
    private var africa : CXMMLeagueMatchVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadNewData()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return getLeagueMatchVC()
    }
    
    private func getLeagueMatchVC() -> [UIViewController] {
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        hot = story.instantiateViewController(withIdentifier: "LeagueHotVC") as! CXMMLeagueHotVC
        
        international = story.instantiateViewController(withIdentifier: "LeagueMatchVC") as! CXMMLeagueMatchVC
        international.style = .国际
        europe = story.instantiateViewController(withIdentifier: "LeagueMatchVC") as! CXMMLeagueMatchVC
        europe.style = .欧洲
        asia = story.instantiateViewController(withIdentifier: "LeagueMatchVC") as! CXMMLeagueMatchVC
        asia.style = .亚洲
        america = story.instantiateViewController(withIdentifier: "LeagueMatchVC") as! CXMMLeagueMatchVC
        america.style = .美洲
        africa = story.instantiateViewController(withIdentifier: "LeagueMatchVC") as! CXMMLeagueMatchVC
        africa.style = .非洲
        
        return [hot, international, europe, asia, america, africa]
    }

}

extension CXMMLeaguePagerVC {
    private func loadNewData() {
        leagueHomeRequest()
    }
    private func leagueHomeRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.leaguePager())
            .asObservable()
            .mapArray(type: LeagueMatchModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.hot.leagueList = data[0].leagueInfoList
            }, onError: { (error) in
                
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                       // weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        //weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
