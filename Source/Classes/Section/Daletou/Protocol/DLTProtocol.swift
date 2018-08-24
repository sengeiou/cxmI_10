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
    /// d : 拖蓝球
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

protocol DLTRandom { }

extension DLTRandom {
    
    func getFiveRandom() -> [DaletouDataList] {
        var list = [DaletouDataList]()
        
        let num = 5
        
        for _ in 1...num {
            list.append(getOneRandom())
        }
        
        return list
    }
    
    
    func getOneRandom() -> DaletouDataList {
        let model = DaletouDataList()
        model.bettingNum = 1
        for num in getRedRandom() {
            let mo = DaletouDataModel()
            if num < 10 {
                mo.num = "0\(num)"
            }
            else {
                mo.num = "\(num)"
            }
            
            mo.number = num
            mo.selected = true
            mo.style = .red
            model.redList.append(mo)
        }
        for num in getBlueRandom() {
            let mo = DaletouDataModel()
            if num < 10 {
                mo.num = "0\(num)"
            }
            else {
                mo.num = "\(num)"
            }
            mo.number = num
            mo.selected = true
            mo.style = .blue
            model.blueList.append(mo)
        }
        return model
    }
    
    func getRedRandom() -> [Int] {
        let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35]
        return random(arr: arr, scope: 5)
    }
    
    func getBlueRandom() -> [Int] {
        let arr = [1,2,3,4,5,6,7,8,9,10,11,12]
        return random(arr: arr, scope: 2)
    }
    
    private func random(arr : [Int], scope: Int) -> [Int] {
       
        var startArr = Array(arr)
        var resultArr = Array(repeating: 0, count: scope)
        for i in 0..<scope {
            let currentCount = UInt32(startArr.count - i )
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr.remove(at: index)
        }
        return resultArr.sorted()
    }

}












