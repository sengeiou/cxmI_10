//
//  FootballLiveInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//  赛况Model

import Foundation
import HandyJSON

struct FootballLiveInfoModel: HandyJSON {
    var changci: String!
    /// 事件列表
    var eventList:[FootballLiveEventInfo] = [FootballLiveEventInfo]()
    var homeTeamAbbr: String!
    var visitingTeamAbbr: String!
    var leagueAddr: String!
    /// 统计数据
    var matchLiveStatisticsDTO: FootballStatisticsInfo!
    var matchTime: String!
}

struct FootballLiveEventInfo: HandyJSON {
    /// 事件编码
    var eventCode: String!
    /// 事件名称
    var eventName: String!
    /// 事件类型
    var eventType: String!
    /// 主客队
    var isHa: String!
    /// 时间
    var minute: String!
    /// 队员
    var person: String!
    /// 队员ID
    var personId: String!
}

struct FootballStatisticsInfo : HandyJSON {
    var attacks: FootballLiveTeamData!
    var corners: FootballLiveTeamData!
    var dangerousAttacks: FootballLiveTeamData!
    var fouls: FootballLiveTeamData!
    var freeKicks: FootballLiveTeamData!
    var goalKicks: FootballLiveTeamData!
    var goals: FootballLiveTeamData!
    var offsides: FootballLiveTeamData!
    var posession: FootballLiveTeamData!
    var possession: FootballLiveTeamData!
    var shotsBlocked: FootballLiveTeamData!
    var shotsOffTarget: FootballLiveTeamData!
    var shotsOnTarget: FootballLiveTeamData!
    var substitutions: FootballLiveTeamData!
    var throwIns: FootballLiveTeamData!
    var yellowCards: FootballLiveTeamData!
    
}

struct FootballLiveTeamData: HandyJSON {
    var teamAData: String!
    var teamHData: String!
}
