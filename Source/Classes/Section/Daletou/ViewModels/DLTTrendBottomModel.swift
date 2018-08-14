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
    public var confirm = PublishSubject<[DaletouDataList]>()
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
        
        let list = [DaletouDataList]()
        
        
        
        
        self.confirm.onNext(list)
    }
    
    private func setBettingNum (model : DaletouDataModel, isRed: Bool) {
        switch isRed {
        case true:
            let bettingNum = standardBettingNum(m: seRedSet.count, n: seBluSet.count)
            
            if seRedSet.count >= 5 && seBluSet.count >= 2{
                betNum.onNext(bettingNum)
            }
            
            if bettingNum * 2 > 20000 {
                seRedSet.remove(model)
                model.selected = false
                reloadData.onNext(false)
            }else {
                reloadData.onNext(true)
            }
        case false:
            let bettingNum = standardBettingNum(m: seRedSet.count, n: seBluSet.count)
            
            if seRedSet.count >= 5 && seBluSet.count >= 2{
                betNum.onNext(bettingNum)
            }
            
            if bettingNum * 2 > 20000 {
                seBluSet.remove(model)
                model.selected = false
                reloadData.onNext(false)
            }else {
                reloadData.onNext(true)
            }
       
        }
    }
    
}
