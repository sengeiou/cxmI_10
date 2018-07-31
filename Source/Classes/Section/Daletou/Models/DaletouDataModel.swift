//
//  DaletouDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

class DaletouDataModel: NSObject {
    required override init() {}
    
    var num : String!
    var selected : Bool = false
    
    static func getData(isRed : Bool) -> [DaletouDataModel] {
        var list = [DaletouDataModel]()
        
        if isRed {
            for i in 1...35 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                list.append(model)
            }
        }
        else {
            for i in 1...12 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                list.append(model)
            }
        }
        
        return list
    }
    
}
