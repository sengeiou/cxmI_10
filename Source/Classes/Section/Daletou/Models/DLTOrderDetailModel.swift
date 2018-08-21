//
//  DLTOrderDetailModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct DLTOrderDetailModel: HandyJSON  {
   
    var acceptTime : String = ""
    var bonus : String!
    var lotteryClassifyId: String!
    var lotteryClassifyImg: String!
    var lotteryClassifyName: String!
    /// 订单投注详情
    var cathecticResults : [DLTOrderResult]!
    var createTime: String = ""
    var moneyPaid: String!
    var orderSn: String!
    var orderStatus: String!
    var orderStatusDesc: String!
    var payName: String!
    /// 开奖前提示
    var prePrizeInfo : String!
    /// 开奖号码
    var prizeNum: [String]!
    var programmeSn: String = ""
    var surplus: String = ""
    var termNum: String = ""
    var thirdPartyPaid: String = ""
    var ticketAmount: String = ""
    var ticketTime: String = ""
    var userSurplus: String!
    var userSurplusLimit: String!
    var winningMoney : String = ""
}

struct DLTOrderResult : HandyJSON {
    /// 彩票购买金额
    var amount : String = ""
    /// 投注注数
    var betNum: String = ""
    var blueCathectics: [DLTOrderItemInfo]!
    var blueDanCathectics : [DLTOrderItemInfo]!
    /// 投注倍数
    var cathectic: String = ""
    /// 是否追加，0否1是 ,
    var isAppend: String!
    /// 玩法:0单式，1复式，2胆拖 ,
    var playType: String!
    var redCathectics : [DLTOrderItemInfo]!
    var redDanCathectics : [DLTOrderItemInfo]!
    var redTuoCathectics : [DLTOrderItemInfo]!
    var blueTuoCathectics: [DLTOrderItemInfo]!
    
}

class DLTOrderItemInfo : NSObject, HandyJSON {
    
    required override init() { }
    
    /// 投注号码
    var cathectic : String!
    ///是否猜中 0-没猜中 1-猜中
    var isGuess : Bool = false
    var style : BallStyle = .red
}

struct DLTTicketSchemeModel: HandyJSON {
    var programmeSn = ""
    var lottoTicketSchemeDetailDTOs : [DLTTicketSchemeInfo]!
}

struct DLTTicketSchemeInfo : HandyJSON {
    /// 彩票购买金额
    var amount : String = ""
    /// 投注注数
    var betNum: String = ""
    var blueCathectics: [DLTOrderItemInfo]!
    var blueDanCathectics : [DLTOrderItemInfo]!
    /// 投注倍数
    var cathectic: String = ""
    /// 倍数
    var multiple : String = ""
    /// 序号
    var number : String = ""
    /// 出票状态， 0-待出票 1-已出票 2-出票失败 3-出票中
    var status : String!
    /// 投注内容
    var tickeContent: String!
    /// 出票编号
    var ticketSn: String!
    /// 是否追加，0否1是 ,
    var isAppend: String!
    /// 玩法:0单式，1复式，2胆拖 ,
    var playType: String!
    var redCathectics : [DLTOrderItemInfo]!
    var redDanCathectics : [DLTOrderItemInfo]!
    var redTuoCathectics : [DLTOrderItemInfo]!
    var blueTuoCathectics: [DLTOrderItemInfo]!
}
