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

struct BasketballViewModel {
    var selectNumText : BehaviorSubject<String> = BehaviorSubject(value: "请至少选择一场单关比赛\n或两场非单关比赛")
    
    
}

extension BasketballViewModel {
    public func selectMatch() {
        
    }
}
