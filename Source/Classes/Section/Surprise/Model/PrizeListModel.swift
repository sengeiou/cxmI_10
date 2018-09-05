//
//  PrizeListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON


struct PrizeListModel : HandyJSON {
    /// 彩种 0: 数字彩,1: 竞彩
    var classifyStatus : String = ""
    /// 1 代表足球 0代表篮球
    var ballColor : String = ""
    /// 彩种Icon
    var lotteryIcon : String = ""
    /// 彩种Id
    var lotteryId : String = ""
    /// 彩种名称
    var lotteryName: String = ""
    /// 其次
    var period : String = ""
    
    var date : String = ""
    /// 篮球
    var blueBall : [String] = [String]()
    /// 红球
    var redBall : [String] = [String]()
    /// 主队
    var homeTeam : String = ""
    /// 客队
    var visitingTeam : String = ""
    /// 比分
    var score : String = ""
}

struct PrizeLottoInfo : HandyJSON {
    var bluePrizeNumList : [String] = [String]()
    var redPrizeNumList : [String] = [String]()
    /// 其次
    var period : String = ""
    /// 期号
    var termNum : String = ""
    /// 开奖日期
    var prizeDate : String = ""
    /// 玩法ID
    var lotteryId : String = ""
}

struct PrizeLottoDetailModel : HandyJSON {
    var bluePrizeNumList : [String] = [String]()
    var redPrizeNumList : [String] = [String]()
    /// 其次
    var period : String = ""
    /// 期号
    var termNum : String = ""
    /// 开奖日期
    var prizeDate : String = ""
    /// 玩法ID
    var lotteryId : String = ""
    /// 奖池金额
    var prizes : String = ""
    /// 销售金额
    var sellAmount : String = ""
    /// 获奖详情
    var superLottoRewardDetailsList : [PrizeRewardDetailModel] = [PrizeRewardDetailModel]()
}

struct PrizeRewardDetailModel : HandyJSON {
    /// 获奖级别1，2，3，4，5，6
    var rewardLevel : String = ""
    //// 基本中奖注数
    var rewardNum1 : String = ""
    /// 追加中奖注数
    var rewardNum2 : String = ""
    /// 基本单注奖金
    var rewardPrice1 : String = ""
    /// 追加单注奖金
    var rewardPrice2 : String = ""
}
