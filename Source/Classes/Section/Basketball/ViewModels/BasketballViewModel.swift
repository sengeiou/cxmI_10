//
//  BasketballViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/19.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let maxNum : Int = 3

class BasketballViewModel : AlertPro {
    var selectNumText : BehaviorSubject<String> = BehaviorSubject(value: "请至少选择一场单关比赛\n或两场非单关比赛")
    
    // 选取的 赛事
    var confirmButtonState : BehaviorSubject = BehaviorSubject(value: false)
    
    
    private var sePlayList = [BBPlayModel]() {
        didSet{
            
            if sePlayList.isEmpty {
                selectNumText.onNext("请至少选择一场单关比赛\n或两场非单关比赛")
                confirmButtonState.onNext(false)
            }else {
                selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
            }
        }
    }
    
    private var sePlaySet : Set<BBPlayModel> = Set() {
        didSet{
            sePlayList = sePlaySet.sorted{$0.changci < $1.changci}
        }
    }
    
    public func removeAllSePlay() {
        sePlaySet.removeAll()
    }
}

extension BasketballViewModel {
    public func selectMatch(play : BBPlayModel) -> Bool {
        
        guard sePlaySet.count < maxNum
            || sePlaySet.contains(play) else {

            showHUD(message: "最多选择\(sePlaySet.count)场")

            return false
        }
        
        sePlaySet.insert(play)
        return true
    }
    public func deSelectMatch(play : BBPlayModel) {
        sePlaySet.remove(play)
    }
}
