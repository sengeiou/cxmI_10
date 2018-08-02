//
//  DaletouDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift

class DaletouDataModel: NSObject {
    required override init() {}
    
    var num : String!
    var number: Int!
    var style : BallStyle = .red
    var selected : Bool = false
    
    var isselected = Variable<Bool>(false)
    
    static func getData(ballStyle : BallStyle) -> [DaletouDataModel] {
        var list = [DaletouDataModel]()
        
        switch ballStyle {
        case .red:
            for i in 1...35 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                model.number = i
                list.append(model)
            }
        case .blue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                model.num = "\(i)"
                model.number = i
                list.append(model)
            }
        }
        return list
    }
    
}
