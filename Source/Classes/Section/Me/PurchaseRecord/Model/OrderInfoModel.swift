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
    var acceptTime: String = ""
    var cathectic : String = ""
    var createTime: String = ""
    var lotteryClassifyId: String = ""
    var lotteryPlayClassifyId: String = ""
    var lotteryClassifyImg: String = ""
    var lotteryClassifyName: String = ""
    var matchInfos: [MatchInfo]!
    var moneyPaid: String = ""
    var orderStatus: String!
    var orderStatusDesc: String!
    var passType: String = ""
    var processResult: String!
    var processStatusDesc: String!
    var programmeSn: String!
    var ticketTime: String!
    var forecastMoney: String!
    var orderSn : String = ""
    var playType: String!
    /// 余额支付金额
    var surplus : Double = 0
    /// 第三方支付金额
    var thirdPartyPaid: Double = 0
    /// 红包金额
    var bonus : Double = 0
    /// 彩票购买总金额
    var ticketAmount : String!
    /// 支付方式
    var payName : String = ""
    
    var detailType : String!
    /// web url
    var redirectUrl : String!
    
    var betNum : String = ""
    /// 客服二维码
    var addFriendsQRBarUrl : String = ""
    /// 是否显示合作店铺 0 不显示 1 显示
    var showStore : String = ""
    
    var appendInfoList : [AppendInfo] = [AppendInfo]()
    
}

struct MatchInfo: HandyJSON {
    
    var cathecticResults: [CathecticResult]!
    var changci: String = ""
    var match: String!
    var playType: String!
    var result: String!
    var isDan : Bool = false
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

struct AppendInfo : HandyJSON {
    var imgurl : String = ""
    var phone : String = ""
    var pushurl : String = ""
    var type : String = ""
    var wechat : String = ""
}
