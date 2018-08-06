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

    static func getData(ballStyle : BallStyle) -> [DaletouDataModel] {
        var list = [DaletouDataModel]()
        
        switch ballStyle {
        case .red:
            for i in 1...35 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .blue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .danRed:
            for i in 1...35 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .dragRed:
            for i in 1...35 {
                let model = DaletouDataModel()
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .danBlue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .dragBlue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                model.num = "\(i)"
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        }
        return list
    }
    
}

class DaletouDataList: NSObject {
    required override init() {}

    var type : DaletouType = .标准选号
    
    var redList = [DaletouDataModel]()
    var blueList = [DaletouDataModel]()
    var danRedList = [DaletouDataModel]()
    var dragRedList = [DaletouDataModel]()
    var danBlueList = [DaletouDataModel]()
    var dragBlueList = [DaletouDataModel]()
    
}

