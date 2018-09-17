//
//  MatchHisListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct MatchHisListModel: HandyJSON {
    var dateStr : String = ""
    var list : [MatchHisInfo] = [MatchHisInfo]()
    var lotteryClassify : String = ""
    var lotteryName : String = ""
    /// 已开奖
    var prizeMatchStr : String = ""
}

struct MatchHisInfo : HandyJSON {
    var changciId : String = ""
    /// 杯赛名称
    var cupName : String = ""
    /// 半场比分
    var half : String = ""
    /// 主队简称
    var homeTeamAbbr : String = ""
    /// 比分
    var crs : String = ""
    /// 胜平负
    var had : String = ""
    /// 半全场
    var hafu : String = ""
    /// 总进球
    var ttg : String = ""
    /// 让球胜平负
    var hhad : String = ""
    ///比赛时间:时分
    var matchTime : String = ""
    ///客队简称
    var visitTeamAbbr : String = ""
    ///全场比分
    var whole : String = ""
}

