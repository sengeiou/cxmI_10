//
//  DLTBetInfoRequest.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/14.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


struct DLTBetInfoRequestModel {
    /// 注数
    var betNum : Int = 0
    var bonusId : String!
    /// 是否追加
    var isAppend : Bool!
    var lotteryClassifyId : String!
    var lotteryPlayClassifyId : String!
    var matchTime : String!
    /// 订单金额
    var orderMoney : String!
    
    /// 倍数
    var times : Int!
    
    var betInfos : [BetInfo] = [BetInfo]()
    
    
    struct BetInfo {
        var amount : Int!
        var betInfo : String!
        var betNum : Int!
        var palyType : String!
    }
    
    static func getRequestModel (list : [DaletouDataList], isAppend : Bool) -> DLTBetInfoRequestModel {
        
        var requestModel = DLTBetInfoRequestModel()
        requestModel.lotteryClassifyId = "2"
        
        switch isAppend {
        case true:
            requestModel.lotteryPlayClassifyId = "10"
        case false:
            requestModel.lotteryPlayClassifyId = "9"
        }
        
        var money : Int = 0
        
        for data in list {
            requestModel.betNum += data.bettingNum
            requestModel.times = data.multiple
            money += data.money * data.multiple * data.bettingNum
            requestModel.isAppend = data.isAppend
            
            var model = BetInfo()
            model.amount = data.money * data.multiple * data.bettingNum
            model.betNum = data.bettingNum
            
            switch data.type {
            case .标准选号:
                if data.redList.count + data.blueList.count > 7 {
                    model.palyType = "1"
                }else {
                    model.palyType = "0"
                }
                
                var betInfo = ""
                
                var i = 1
                for info in data.redList {
                    if i == data.redList.count {
                        betInfo = betInfo + info.num
                    }else{
                        betInfo = betInfo + info.num + ","
                    }
                    
                    i += 1
                }
                betInfo = betInfo + "|"
                
                var j = 1
                for info in data.blueList {
                    if j == data.blueList.count {
                        betInfo = betInfo + info.num
                    }else {
                        betInfo = betInfo + info.num + ","
                    }
                    j += 1
                }
                
                model.betInfo = betInfo
            case .胆拖选号:
                model.palyType = "2"
            }
            
            requestModel.betInfos.append(model)
        }
        
        requestModel.orderMoney = "\(money)"
        
        return requestModel
    }
    
}


