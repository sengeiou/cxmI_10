//
//  DLTProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol Algorithm : Calculation { }

extension Algorithm {
    /// m : 红球
    /// n : 篮球
    func standardBettingNum(m : Int, n : Int) -> Int {
        return calculation(n: 5, m: m) * calculation(n: 2, m: n)
    }
    
    /// a : 胆红球
    /// b : 拖红球
    /// c : 胆篮球
    /// d : 拖红球
    func danBettingNum(a : Int, b : Int, c : Int, d : Int) -> Int {
        return calculation(n: 5 - a, m: b) * calculation(n: 2 - c, m: d)
    }
}

protocol Calculation {
    
}
extension Calculation {
    func calculation(n : Int, m : Int) -> Int {
        let m = m > n ? m : n
        let n = m > n ? n : m
        var result:Int = 1;
        for i in 1...n {
            result = result * (m - n + i)/i
        }
        return result
    }
}


