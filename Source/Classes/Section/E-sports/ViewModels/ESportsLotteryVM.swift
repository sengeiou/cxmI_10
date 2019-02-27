//
//  ESportsLotteryVM.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HandyJSON

protocol ESportsModel : HandyJSON, Hashable {
    var betDetail : BehaviorSubject<String> {set get }
}

extension ESportsModel {

}


/// 业务逻辑 协议
protocol ESportsLottery {
    associatedtype Item : ESportsModel
    var data : [Item] { get set }
}
extension ESportsLottery {
    var matchCount : Driver<String> {
        return Driver.just("共有场比赛可以投注")
    }
    var seDetail : Driver<String> {
        return Driver.just("请至少选择1场单关比赛\n多选场次都按单关计算")
    }
    var confirmStyle : Driver<UIColor> {
        return Driver.just(Color9F9F9F)
    }
    
    var selectPlay : Set<Item> {
        set{}
        get{ return Set() }
    }
    
    /// 删除选中项
    public mutating func deleteAllSelect() {
        for play in selectPlay {
            play.betDetail.onNext("玩法投注")
        }
        selectPlay.removeAll()
    }
    
    /// 确认投注
    public func confirm(vc : UIViewController) {
        
    }
    
    
}






