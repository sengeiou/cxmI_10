//
//  DLTTrendSettingModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/14.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift

class DLTTrendSettingModel  {
    
    public var change = BehaviorSubject(value: false)
    
    public var compute = true // 是否计算统计
    public var count = "100"  // 期数
    public var drop = true    // 是否显示遗漏
    public var sort = true    // 排序 true 倒序，，false 正序
    
    public func setting(with compute : Bool, drop : Bool, sort : Bool, count : String) {
        self.compute = compute
        self.count = count
        self.drop = drop
        self.sort = sort
        self.change.onNext(true)
    }
}

