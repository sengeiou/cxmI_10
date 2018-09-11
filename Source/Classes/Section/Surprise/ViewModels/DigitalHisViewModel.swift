//
//  DigitalHisViewModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation




struct DigitalHisViewModel {
    public var style : LottoPlayType = .大乐透
    
    public var ballList : [DigitalBallData] = [DigitalBallData]()
    
    /// 大乐透，详情数据
    public var lottoDetailData : PrizeLottoDetailModel!
    
}
extension DigitalHisViewModel {
    public mutating func setBallData(redList : [String], blueList : [String]) {
        for red in redList {
            var model = DigitalBallData()
            model.title = red
            model.style = .seRed
            ballList.append(model)
        }
        for blue in blueList {
            var model = DigitalBallData()
            model.title = blue
            model.style = .seBlue
            ballList.append(model)
        }
    }
}
