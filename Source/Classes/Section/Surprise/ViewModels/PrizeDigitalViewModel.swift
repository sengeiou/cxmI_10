//
//  PrizeDigitalViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import RxSwift

enum DigitalStyle {
    case red
    case blue
    case seRed
    case seBlue
    
}
enum PrizeStyle {
    case prizeList
    case prizeDetail
}
struct DigitalBallData {
    var title : String = ""
    var lotteryId : String = ""
    var style : DigitalStyle = .red
}

struct PrizeDigitalViewModel {
    public var list = BehaviorSubject(value: [DigitalBallData]())
    public var style : PrizeStyle!
    public var ballStyle : PrizeDigitalStyle = .circular
    public var lotteryId : String = ""
}

extension PrizeDigitalViewModel {
    public func setData(red : [String], blue : [String]) {
        guard let style = self.style else { return }
        var ballList = [DigitalBallData]()
        
        for redDa in red {
            var redData = DigitalBallData()
            redData.title = redDa
            redData.lotteryId = self.lotteryId
            switch style {
            case .prizeList:
                redData.style = .seRed
            case .prizeDetail:
                redData.style = .red
            }
        
            ballList.append(redData)
        }
        for blueStr in blue {
            var blueData = DigitalBallData()
            blueData.title = blueStr
            blueData.lotteryId = self.lotteryId
            switch style {
            case .prizeList:
                blueData.style = .seBlue
            case .prizeDetail:
                blueData.style = .blue
            }
            ballList.append(blueData)
        }
        
        self.list.onNext(ballList)
        
    }
}
