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
    var matchLiveStatisticsDTO: [FootballLiveTeamData]!
    var matchTime: Int! = 0
    /// 比赛状态 0-未开赛，1-已完成，2-取消，4-推迟， 5-暂停，6-进行中
    var matchStatus: String!
    /// 比赛时长
    var minute: String! = ""
    /// 全场比分
    var whole : String = "0:0"
    /// 半场比分
    var firstHalf: String = "0:0"
    /// 主队全场比分
    var fsH : String = "0"
    /// 客队全场比分
    var fsA : String = "0"
    /// 主队半场比分
    var htsH: String = "0"
    /// 客队半场比分
    var htsA: String = "0"
    
    static func getDefaultData() -> [FootballLiveTeamData] {
        var list = [FootballLiveTeamData]()
    
        var item1 = FootballLiveTeamData()
        item1.dataName = "控球率"
        item1.teamHData = 0
        item1.teamHData = 0
        item1.dataType = "1"
        list.append(item1)
        
        var item2 = FootballLiveTeamData()
        item2.dataName = "射正"
        item2.teamHData = 0
        item2.teamHData = 0
        list.append(item2)
        
        var item3 = FootballLiveTeamData()
        item3.dataName = "射偏"
        item3.teamHData = 0
        item3.teamHData = 0
        list.append(item3)
        
        var item4 = FootballLiveTeamData()
        item4.dataName = "被封堵"
        item4.teamHData = 0
        item4.teamHData = 0
        list.append(item4)
        
        var item5 = FootballLiveTeamData()
        item5.dataName = "角球"
        item5.teamHData = 0
        item5.teamHData = 0
        list.append(item5)
        
        var item6 = FootballLiveTeamData()
        item6.dataName = "任意球"
        item6.teamHData = 0
        item6.teamHData = 0
        list.append(item6)
        
        var item7 = FootballLiveTeamData()
        item7.dataName = "越位"
        item7.teamHData = 0
        item7.teamHData = 0
        list.append(item7)
        
        var item8 = FootballLiveTeamData()
        item8.dataName = "黄牌"
        item8.teamHData = 0
        item8.teamHData = 0
        list.append(item8)
        
        var item9 = FootballLiveTeamData()
        item9.dataName = "犯规"
        item9.teamHData = 0
        item9.teamHData = 0
        list.append(item9)
        
        var item10 = FootballLiveTeamData()
        item10.dataName = "有威胁助攻"
        item10.teamHData = 0
        item10.teamHData = 0
        list.append(item10)
        
        return list
    }
    
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

struct FootballLiveTeamData: HandyJSON {
    var dataCode: String!
    var dataName: String!
    /// 数据类型:0数字1百分比
    var dataType: String!
    
    var teamAData: Int = 0
    var teamHData: Int = 0
}
