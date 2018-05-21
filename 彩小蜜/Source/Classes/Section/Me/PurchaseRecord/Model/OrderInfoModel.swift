//
//  OrderInfoModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct OrderInfoModel: HandyJSON {
    var acceptTime: String!
    var cathectic : String!
    var createTime: String!
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
    var lotteryClassifyImg: String!
    var lotteryClassifyName: String!
    var matchInfos: [MatchInfo]!
    var moneyPaid: String!
    var orderStatus: String!
    var orderStatusDesc: String!
    var passType: String! 
    var processResult: String!
    var processStatusDesc: String!
    var programmeSn: String!
    var ticketTime: String!
    var forecastMoney: String!
    var orderSn : String!
    var playType: String!
}

struct MatchInfo: HandyJSON {
    
    var cathecticResults: [CathecticResult]!
    var changci: String!
    var match: String!
    var playType: String!
    var result: String!
    
}

struct CathecticResult: HandyJSON {
    var cathectics : [Cathectic]!
    var matchResult: String!
    var playType: String!
}

struct Cathectic : HandyJSON {
    var cathectic : String!
    var isGuess : Bool!
}
