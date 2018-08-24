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
    var omissionNum : String = ""
    
    static func getData(ballStyle : BallStyle) -> [DaletouDataModel] {
        var list = [DaletouDataModel]()
        
        switch ballStyle {
        case .red:
            for i in 1...35 {
                let model = DaletouDataModel()
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .blue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .danRed:
            for i in 1...35 {
                let model = DaletouDataModel()
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .dragRed:
            for i in 1...35 {
                let model = DaletouDataModel()
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .danBlue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .dragBlue:
            for i in 1...12 {
                let model = DaletouDataModel()
                model.style = .blue
                if i < 10 {
                    model.num = "0\(i)"
                }else {
                    model.num = "\(i)"
                }
                model.number = i
                model.style = ballStyle
                list.append(model)
            }
        case .line:
            break
        }
        return list
    }
    
}

class DaletouDataList: NSObject, Algorithm {
    required override init() {}

    var type : DaletouType = .标准选号
    
    var redList = [DaletouDataModel]()
    var blueList = [DaletouDataModel]()
    var danRedList = [DaletouDataModel]()
    var dragRedList = [DaletouDataModel]()
    var danBlueList = [DaletouDataModel]()
    var dragBlueList = [DaletouDataModel]()
    
    /// 注数
    var bettingNum : Int = 0
    /// 倍数
    var multiple : Int = 1
    /// 钱数
    var money : Int = 2
    /// 追加
    var isAppend = false
    
    func getBettingNum () {
        switch type {
        case .标准选号:
            bettingNum = getStandardBettingNum()
        case .胆拖选号:
            bettingNum = getDanBettingNum()
        }
    }
    
    private func getStandardBettingNum() -> Int {
        return standardBettingNum(m: redList.count, n: blueList.count)
    }
    private func getDanBettingNum() -> Int {
        return danBettingNum(a: danRedList.count,
                             b: dragRedList.count,
                             c: danBlueList.count,
                             d: dragBlueList.count)
    }
}

