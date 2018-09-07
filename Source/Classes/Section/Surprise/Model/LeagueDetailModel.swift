//
//  LeagueDetailModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct LeagueDetailModel: HandyJSON {
    var leagueAddr: String = ""
    var leagueId : String = ""
    /// 联赛赛程
    var leagueMatch : LeagueMatchList!
    var leagueName: String = ""
    /// 联赛LOGO
    var leaguePic : String = ""
    /// 联赛规则
    var leagueRule : String = ""
    var leagueScore : LeagueScoreList!
    var leagueShooter : LeagueShooterList!
    /// 联赛球队
    var leagueTeam : LeagueTeamList!
}

struct LeagueScoreList : HandyJSON {
    var hteamScoreList : [LeagueTeamScoreInfo] = [LeagueTeamScoreInfo]()
    var tteamScoreList : [LeagueTeamScoreInfo] = [LeagueTeamScoreInfo]()
    var vteamScoreList : [LeagueTeamScoreInfo] = [LeagueTeamScoreInfo]()
    
}

struct LeagueTeamScoreInfo : HandyJSON {
    /// 净胜球
    var ballClean : String = ""
    /// 进球数
    var ballIn : String = ""
    /// 失去数
    var ballLose : String = ""
    /// 平场次数
    var matchD : String = ""
    /// 胜场次数
    var matchH : String = ""
    /// 负场次数
    var matchL : String = ""
    /// 比赛场次数
    var matchNum : String = ""
    /// 积分
    var score : String = ""
    var teamId : String = ""
    /// 球队名称
    var teamName : String = ""
    /// 排名
    var teamOrder : String = ""
}
struct LeagueMatchList : HandyJSON {
    var futureMatchDTOList : [LeagueMatchInfo] = [LeagueMatchInfo]()
}
struct LeagueMatchInfo : HandyJSON {
    var homeTeamAbbr : String = ""
    var leagueAbbr : String = ""
    var matchTime : String = ""
    var visitorTeamAbbr : String = ""
}

struct LeagueShooterList : HandyJSON {
    var leagueShooterInfoList : [LeagueShooterInfo] = [LeagueShooterInfo]()
}

struct LeagueShooterInfo : HandyJSON {
    var inNum : String = ""
    var matchSeasonId : String = ""
    /// 球员名称
    var playerName : String = ""
    /// 球队名称
    var playerTeam : String = ""
    /// 排名
    var sort : String = ""
}
struct LeagueTeamList : HandyJSON {
    var leagueTeamInfoDTOList : [LeagueTeamInfo] = [LeagueTeamInfo]()
}
struct LeagueTeamInfo : HandyJSON {
    var teamAddr : String = ""
    var teamPic : String = ""
    var teamId : String = ""
}
