//
//  NumPlusReduceViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/4.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import RxSwift

class NumPlusReduceViewModel {
    var number : BehaviorSubject = BehaviorSubject(value: "1")
    var totalPrice : BehaviorSubject = BehaviorSubject(value: "")
    var imageStr : BehaviorSubject = BehaviorSubject(value: "--")
    private var num : Int = 1 {
        didSet{
            if num <= 0 {
                num = 1
            }
            if num <= 1 {
                imageStr.onNext("--")
            }
            if num > 1 {
                imageStr.onNext("-")
            }
        }
    }
}

extension NumPlusReduceViewModel{
    public func changeNum(num : Int) {
        self.num = num
        number.onNext("\(num)")
    }
    public func reduce() {
        num -= 1
        number.onNext("\(num)")
    }
    public func plus() {
        num += 1
        number.onNext("\(num)")
        
    }
    
}
