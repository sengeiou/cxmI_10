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
    var betDetail : BehaviorSubject<String> { get set }
    var homeTeam : String { get set }
    var visiTeam : String { get set }
}

extension ESportsModel {

}



/// 投注页 业务逻辑 协议
protocol ESportsLottery {
    associatedtype Item : ESportsModel
    var data : [Item] { get set }
    
    func request() -> Void
}
extension ESportsLottery {
    /// 赛事总场次
    var matchCount : Driver<String> {
        return Driver.just("共有场比赛可以投注")
    }
    /// 选取赛事后显示文本
    var seDetail : Driver<String> {
        return Driver.just("请至少选择1场单关比赛\n多选场次都按单关计算")
    }
    /// 确认按钮状态颜色
    var confirmColor : Driver<UIColor> {
        return Driver.just(Color9F9F9F)
    }
    /// 确认按钮是否响应事件
    var confirmStyle : Driver<Bool> {
        return Driver.just(true)
    }
    /// 刷新列表
    var reload : BehaviorSubject<Bool> {
        return BehaviorSubject(value: true)
    }
    
    var selectPlay : Set<Item> {
        set{}
        get{ return Set() }
       
    }
    
}

extension ESportsLottery {
    
    /// 添加选中的赛事
    public mutating func addMatch(play : Item) {
        selectPlay.insert(play)
        
        
    }
    /// 刷新列表
    public func reloadData() {
        
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
        let story = UIStoryboard(storyboard: .ESports)
        let confirm = story.instantiateViewController(withIdentifier: "LoLPlayConfirm") as! LoLPlayConfirm
        vc.navigationController?.pushViewController(confirm, animated: true)
    }
    
    
}





// MARK: - 投注确认
protocol ESportsConfirm {
    associatedtype Item : ESportsModel
}

extension ESportsConfirm {
    /// 赛事总场次
    var betCount : Driver<String> {
        return Driver.just("已选比赛， 总计玩法")
    }
    /// 投注信息
    var betDetail : Driver<String> {
        return Driver.just("注")
    }
    /// 投注倍数
    var betNum : BehaviorSubject<NSAttributedString> {
        return BehaviorSubject(value: NSAttributedString(string: "倍数"))
    }
    /// 确认按钮颜色
    var confirmColor : BehaviorSubject<UIColor> {
        return BehaviorSubject(value:ColorEA5504)
    }
    /// 确认按钮是否响应事件
    var confirmStyle : BehaviorSubject<Bool> {
        return BehaviorSubject(value:true)
    }
    
    /// 选取的玩法
    var selectPlays : [Item] {
        return [Item]()
    }
    
}

extension ESportsConfirm {
    /// 删除选项
    public func delete(with index : Int) {
        
    }
    
}
