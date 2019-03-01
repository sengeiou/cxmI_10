//
//  LoLViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa
import SVProgressHUD

/// 投注页ViewModel
struct LoLModel : ESportsLottery, AlertPro {
    typealias Item = LoLData
    
    var data: [LoLData] = [LoLData]()
    
}
extension LoLModel {
    func request() {
        
        _ = eSportsProvider.rx.request(.lolList).asObservable()
            .mapObject(type: LoLData.self)
            .subscribe(onNext: { (data) in
                
            }, onError: { (error) in
                
            }, onCompleted: nil , onDisposed: nil)
    }
}



/// 玩法
struct LoLPlayModel : ESportsPlay {
    var selectData: Set<ESportsPlayModel> = Set()
    
    var homeTeam: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var visiTeam: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    
    typealias Item = LoLData
    
    var data: LoLData = LoLData()
    
    var list: [ESportsPlayModel] = [ESportsPlayModel]()
}
extension LoLPlayModel {
    
    mutating func setData(data: LoLData) {
        self.data = data
        homeTeam.onNext(data.homeTeam)
        visiTeam.onNext(data.visiTeam)
        
        for item in data.play {
            var play = ESportsPlayModel()
            for odd in item.odds {
                var od = ESportsItemModel()
                
                od.text = BehaviorSubject(value: odd)
                
                play.items.append(od)
            }
            play.title.onNext(item.title)
            list.append(play)
        }
        
        
        reloadData.onNext(true)
    }
}


/// 投注确认页ViewModel
struct LoLConfirmModel : ESportsConfirm {
    typealias Item = LoLData
    
    
}
