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
    
    public var betNum = BehaviorSubject(value: 0)
    public var reloadData = BehaviorSubject(value: false)
}

extension DLTTrendBottomModel {
    public func selected(model : DaletouDataModel) {
        
        switch model.style {
        case .red:
            switch model.selected {
            case true:
                seRedSet.insert(model)
                
            case false:
                seRedSet.remove(model)
            }
            
            setBettingNum(model: model, isRed: true)
            
        case .blue:
            switch model.selected {
            case true:
                seBluSet.insert(model)
            case false:
                seBluSet.remove(model)
            }
            setBettingNum(model: model, isRed: false)
        default : break
        }
        
        
        
        
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
