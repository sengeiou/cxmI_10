//
//  TeamDetailModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct TeamDetailModel : HandyJSON {
    /// 城市
    var city : String = ""
    /// 国家
    var contry : String = ""
    /// 球场
    var court : String = ""
    /// 未来赛事
    var futureMatch : TeamFutureDetail!
    /// 球员名单
    var playerlist : TeamMemberDetailList!
    /// 近期战绩
    var recentRecord : TeamRecoreDetail!
    /// 球队简称
    var teamAddr : String = ""
    /// 球场容量
    var teamCapacity : String = ""
    /// 球队Id
    var teamId : String = ""
    /// 球队图标
    var teamPic : String = ""
    /// 成立时间
    var teamTime : String = ""
    /// 球队身价
    var teamValue : String = ""
}

struct TeamFutureDetail : HandyJSON {
    var matchInfoFutureList : [TeamFutureInfo] = [TeamFutureInfo]()
}
struct TeamFutureInfo : HandyJSON {
    var date : String = ""
    var hTeam : String = ""
    var vTeam : String = ""
    /// 赛事名称
    var matchName : String = ""
}
struct TeamMemberDetailList : HandyJSON {
    var playerInfosList : [TeamMemberDetail] = [TeamMemberDetail]()
}
struct TeamMemberDetail : HandyJSON {
    var playerList : [TeamMemberInfo] = [TeamMemberInfo]()
    var palyerType : String = ""
    var playerTypeCode : String = ""
}

struct TeamMemberInfo : HandyJSON {
    var playerName : String = ""
}

struct TeamRecoreDetail : HandyJSON {
    /// 平
    var flat : String = ""
    /// 胜
    var win : String = ""
    /// 负
    var negative : String = ""
    /// 主队名称
    var homeTeam : String = ""
    /// 比赛次数
    var matchCount : String = ""
    ///
    var recentRecordList : [TeamRecordInfo] = [TeamRecordInfo]()
}

struct TeamRecordInfo : HandyJSON {
    var date : String = ""
    var hTeam : String = ""
    var vTeam : String = ""
    var match : String = ""
    var score : String = ""
    var status : String = ""
}
