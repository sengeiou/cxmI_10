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
struct PrizeDigitalData {
    var title : String = ""
    var style : DigitalStyle = .red
}

struct PrizeDigitalViewModel {
    public var list = BehaviorSubject(value: [PrizeDigitalData]())
    public var style : PrizeStyle!
   
    
}

extension PrizeDigitalViewModel {
    public func setData(red : [String], blue : [String]) {
        guard let style = self.style else { return }
        var ballList = [PrizeDigitalData]()
        
        for redDa in red {
            var redData = PrizeDigitalData()
            redData.title = redDa
            
            switch style {
            case .prizeList:
                redData.style = .seRed
            case .prizeDetail:
                redData.style = .red
            }
        
            ballList.append(redData)
        }
        for blueStr in blue {
            var blueData = PrizeDigitalData()
            blueData.title = blueStr
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
