//
//  LineNumberProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol LineNumberProtocol {}

extension LineNumberProtocol {
    func lineNumber(totalNum: Int, horizonNum : Int) -> Int{
        guard totalNum > 0 else { return 0 }
        let count : Int = totalNum / horizonNum
        
        if count == 0 {
            return 1
        }else {
            let num : Int = totalNum % horizonNum
            if num == 0 {
                return count
            }else {
                return count + 1
            }
        }
    }
}
