//
//  FootballMatchInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct FootballMatchInfoModel: HandyJSON {
    /// 历史交锋
    var hvMatchTeamInfo: MatchTeamInfoModel!
    /// 主场战绩
    var hMatchTeamInfo : MatchTeamInfoModel!
    /// 客场战绩
    var vMatchTeamInfo: MatchTeamInfoModel!
    /// 主场积分
    var homeTeamScoreInfo: TeamScoreInfoModel!
    /// 客场积分
    var visitingTeamScoreInfo: TeamScoreInfoModel!
    /// 亚盘
    var leagueMatchAsias: [MatchAsiasModel]!
    /// 欧赔
    var leagueMatchEuropes: [MatchEuropeModel]!
    
    
    
}

struct MatchTeamInfoModel : HandyJSON{
    /// 胜数
    var win : Int!
    /// 平局数
    var draw : Int!
    /// 负场数
    var lose : Int!
    /// 总数
    var total : Int!
    /// 球队名称
    var teamAbbr: String!
    /// 比赛详情
    var matchInfos: [TeamInfo]!
    
}
struct TeamScoreInfoModel: HandyJSON {
    /// 主
    var hteamScore : TeamScoreInfo!
    /// 客
    var lteamScore : TeamScoreInfo!
    /// 总
    var tteamScore : TeamScoreInfo!
    var teamId : String!
    var teamName: String!
}
struct MatchAsiasModel: HandyJSON {
    /// 亚盘对应竞彩网id
    var asiaId: String!
    /// 赛事编号
    var changciId: String!
    ///  公司名称
    var comName : String!
    /// 凯利指数客
    var indexA : String!
    /// 凯利指数主
    var indexH : String!
    /// 初始水位
    var initOdds1 : String!
    /// 初始水位赔率
    var initOdds2 : String!
    ///  初始盘口
    var initRule: String!
    /// 变化趋势:0equal,1up,2down
    var odds1Change: String!
    /// 变化趋势:0equal,1up,2down
    var odds2Change: String!
    /// 最新概率客
    var ratioA: String!
    /// 最新概率主
    var ratioH: String!
    /// 即时水位
    var realOdds1: String!
    /// 即时水位赔率
    var realOdds2: String!
    /// 即时盘口
    var realRule: String!
    /// 最新更新时间，以分为单位，如：大于一小时展示用
    var timeMinus: String!
}
struct MatchEuropeModel: HandyJSON {
    ///  赛事编号
    var changciId: String!
    /// 公司名称
    var comName: String!
    /// 平变化趋势:0equal,1up,2down
    var drawChange: String!
    /// 凯利指数平
    var drawIndex: String!
    /// 最新概率平
    var drawRatio: String!
    /// 亚盘对应竞彩网id
    var europeId: String!
    /// 初始奖金平
    var initDraw: String!
    ///  初始奖金负
    var initLose: String!
    /// 排名
    var initWin: String!
    /// 负变化趋势:0equal,1up,2down
    var loseChange: String!
    /// 凯利指数负
    var loseIndex: String!
    ///  凯利指数负
    var loseRatio: String!
    /// 排名
    var orderNum: String!
    ///
    var per : String!
    /// 即时奖金平
    var realDraw: String!
    /// 即时奖金负
    var realLose: String!
    /// 即时奖金胜
    var realWin: String!
    /// 最新更新时间，以分为单位，如：大于一小时展示用
    var timeMinus: String!
    /// 胜变化趋势:0equal,1up,2down
    var winChange: String!
    /// 凯利指数胜
    var winIndex: String!
    /// 最新概率胜
    var winRatio: String!
}
struct TeamInfo : HandyJSON {
    /// 主队名称
    var homeTeamAbbr: String!
    /// 联赛名称
    var leagueAddr: String!
    /// 比赛日期
    var matchDay : String!
    /// 比赛结果
    var matchRs: String!
    /// 客队名称
    var visitingTeamAbbr: String!
    ///  比赛比分
    var whole: String!
}

struct TeamScoreInfo: HandyJSON {
    /// 净球数
    var ballClean : Int!
    /// 进球数
    var ballIn : Int!
    /// 失球数
    var ballLose: Int!
    /// 0总1主2客 ,
    var flag : String!
    /// 平场次数
    var matchD: Int!
    /// 胜场次数
    var matchH: Int!
    /// 负场次数
    var matchL: Int!
    /// 比赛场次数
    var matchNum: Int!
    /// 均得
    var preH: Int!
    /// 均失
    var preL: Int!
    /// 平率
    var ratioD: Int!
    /// 胜率
    var ratioH: Int!
    /// 负率 ,
    var ratioL: Int!
    /// 积分
    var score: Int!
    ///
    var teamId: String!
    /// 球队名称
    var teamName: String!
}
