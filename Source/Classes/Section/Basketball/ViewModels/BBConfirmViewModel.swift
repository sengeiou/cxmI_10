//
//  BBConfirmViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BBConfirmViewModel {
    var sePlayList = [BBPlayModel](){
        didSet{
            if sePlayList.isEmpty {
//                selectNumText.onNext("请至少选择一场单关比赛\n或两场非单关比赛")
                confirmButtonState.onNext(false)
            }else if sePlayList.count == 1 {
                let play = sePlayList[0]
                
                if play.shengFenCha.single == true {
//                    selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                    confirmButtonState.onNext(true)
                }else {
                    if play.shengfu.single || play.rangfen.single || play.daxiaofen.single {
//                        selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                        confirmButtonState.onNext(true)
                    }else{
//                        selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                        confirmButtonState.onNext(false)
                    }
                }
            }
            else {
//                selectNumText.onNext("您共选择\(sePlayList.count)场赛事")
                confirmButtonState.onNext(true)
            }
        }
    }
    
    var seNum : BehaviorSubject = BehaviorSubject(value: 0)
    var confirmButtonState : BehaviorSubject = BehaviorSubject(value: false)
    var multiple : BehaviorSubject = BehaviorSubject(value: "5")
}

extension BBConfirmViewModel {
    public func changeMultiple(multiple : String) {
        self.multiple.onNext(multiple)
    }
    public func deletePlay(play : BBPlayModel) {
        self.sePlayList.remove(play)
    }
}
