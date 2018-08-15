//
//  DLTTrendBottomModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift

class DLTTrendBottomModel: Algorithm {
    private var seRedSet = Set<DaletouDataModel>()
    private var seBluSet = Set<DaletouDataModel>()
    
    public var seCount = 0
    public var betNum = BehaviorSubject(value: 0)
    public var reloadData = BehaviorSubject(value: false)
    public var confirm = PublishSubject<DaletouDataList>()
    public var showMsg = PublishSubject<String>()
}

extension DLTTrendBottomModel {
    public func selected(model : DaletouDataModel) {
        
        switch model.style {
        case .red:
            switch model.selected {
            case true:
                seRedSet.insert(model)
                seCount += 1
            case false:
                seRedSet.remove(model)
                seCount -= 1
            }
            
            setBettingNum(model: model, isRed: true)
            
        case .blue:
            switch model.selected {
            case true:
                seBluSet.insert(model)
                seCount += 1
            case false:
                seBluSet.remove(model)
                seCount -= 1
            }
            setBettingNum(model: model, isRed: false)
        default : break
        }
    }
    
    public func removeAll () {
        self.seRedSet.removeAll()
        self.seBluSet.removeAll()
        self.betNum.onNext(0)
        seCount = 0
    }
    public func confirmClick() {
        
        let list = DaletouDataList()
        
        list.redList = seRedSet.sorted{$0.number < $1.number}
        list.blueList = seBluSet.sorted{$0.number < $1.number}
        list.type = .标准选号
        list.bettingNum = standardBettingNum(m: seRedSet.count, n: seBluSet.count)
        self.confirm.onNext(list)
    }
    
    private func setBettingNum (model : DaletouDataModel, isRed: Bool) {
        switch isRed {
        case true:
            let bettingNum = standardBettingNum(m: seRedSet.count, n: seBluSet.count)
            
            guard seRedSet.count <= 18 else {
                seRedSet.remove(model)
                model.selected = false
                self.showMsg.onNext("最多只能选择18个红球")
                reloadData.onNext(false)
                return
            }
            
            guard bettingNum * 2 <= 20000 else {
                
                seRedSet.remove(model)
                model.selected = false
                self.showMsg.onNext("单次投注最多2万元")
                reloadData.onNext(false)
                return
            }
            
            if seRedSet.count >= 5 && seBluSet.count >= 2{
                betNum.onNext(bettingNum)
            }else{
                betNum.onNext(0)
            }
            
            reloadData.onNext(true)
        case false:
            let bettingNum = standardBettingNum(m: seRedSet.count, n: seBluSet.count)
            
            guard bettingNum * 2 <= 20000 else {
                
                seBluSet.remove(model)
                model.selected = false
                self.showMsg.onNext("单次投注最多2万元")
                reloadData.onNext(false)
                return
            }
            
            
            if seRedSet.count >= 5 && seBluSet.count >= 2{
                betNum.onNext(bettingNum)
            }else {
                betNum.onNext(0)
            }

            reloadData.onNext(true)
       
        }
    }
    
}
