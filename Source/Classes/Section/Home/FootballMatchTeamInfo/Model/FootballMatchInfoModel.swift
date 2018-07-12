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
    /// 主场主战绩
    var hhMatchTeamInfo : MatchTeamInfoModel!
    /// 主场战绩
    var hMatchTeamInfo : MatchTeamInfoModel!
    /// 客场战绩
    var vMatchTeamInfo: MatchTeamInfoModel!
    /// 客场客战绩
    var vvMatchTeamInfo:MatchTeamInfoModel!
    /// 主场积分
    var homeTeamScoreInfo: TeamScoreInfoModel!
    /// 客场积分
    var visitingTeamScoreInfo: TeamScoreInfoModel!
    /// 胜平负支持率
    var hadTeamSupport : TeamSupportModel!
    /// 让球胜平负支持率
    var hhadTeamSupport: TeamSupportModel!
    /// 亚盘
    var leagueMatchAsias: [MatchAsiasModel]!
    /// 欧赔
    var leagueMatchEuropes: [MatchEuropeModel]!
    /// 大小球
    var leagueMatchDaoxiaos: [MatchDaxiaoqModel]!
    /// 赛事信息
    var matchInfo : MatchInfoModel!
    /// 未来赛事，主队
    var hfutureMatchInfos : [MatchFutureInfo]! = [MatchFutureInfo]()
    var vfutureMatchInfos : [MatchFutureInfo]! = [MatchFutureInfo]()
    
}

struct MatchFutureInfo: HandyJSON {
    /// 主队简称
    var homeTeamAbbr: String!
    var homeTeamId: String!
    var homeTeamName: String!
    var leagueAbbr: String!
    var leagueId: String!
    var leagueName: String!
    var matchDate: String!
    var matchId: String!
    var matchTime: String!
    var visitorTeamAbbr: String!
    var visitorTeamId: String!
    var visitorTeamName: String!
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
    var title : String!
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
    var rank : String!
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

struct MatchDaxiaoqModel : HandyJSON {
    var changciId: String!
    var comName: String!
    var daoxiaoId: String!
    
    var initDraw: String!
    var initLose: String!
    var initTime: String!
    var initWin: String!
    var loseChange: String!
    var matchDay: String!
    var orderNum: String!
    //var playList:[]!
    var realDraw: String!
    var realLose: String!
    var realTime: String!
    var realWin: String!
    var winChange: String!
    var drawChange: String!
}

struct MatchInfoModel: HandyJSON {
    var aOdds: String!
    
    var changci: String!
    var changciId: String!
    var dOdds: String!
    
    var hOdds: String!
    
    var homeTeamAbbr: String!
    var homeTeamId: String!
    var homeTeamPic: String!
    var homeTeamRank: String!
    var leagueAddr: String!
    var matchId: String!
    var matchTime: Int!
    var visitingTeamAbbr: String!
    var visitingTeamId: String!
    var visitingTeamPic: String!
    var visitingTeamRank: String!
    
}
struct TeamSupportModel: HandyJSON {
    /// 负支持率
    var aSupport: String!
    /// 平支持率
    var dSupport: String!
    /// 让球数
    var fixedOdds: Int!
    /// 胜支持率
    var hSupport: String!
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
    /// 1- 交锋 2- 主队 3- 客队
    var teamType : String!
}

struct TeamScoreInfo: HandyJSON {
    /// 净球数
    var ballClean : String!
    /// 进球数
    var ballIn : String!
    /// 失球数
    var ballLose: String!
    /// 平场次数
    var matchD: String!
    /// 胜场次数
    var matchH: String!
    /// 负场次数
    var matchL: String!
    /// 比赛场次数
    var matchNum: String!
    
    /// 积分
    var score: String!
    ///
    var teamId: String!
    /// 球队名称
    var teamName: String!
    /// 名次
    var ranking : String!
}
