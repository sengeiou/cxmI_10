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
    
    var data: [LoLData] = [LoLData(),LoLData()]
    
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
    typealias Item = LoLData
    
    var data: LoLData = LoLData()
}
extension LoLPlayModel {
    
}


/// 投注确认页ViewModel
struct LoLConfirmModel : ESportsConfirm {
    typealias Item = LoLData
    
    
}
