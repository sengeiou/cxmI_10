//
//  FootballLineupInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct FootballLineupInfoModel : HandyJSON {
    var changci: String!
    var homeTeamAbbr: String!
    /// 联赛
    var leagueAddr: String!
    var matchTime: String!
    var visitingTeamAbbr: String!
    /// 客队替补队员
    var abenchPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队受伤队员
    var ainjureiesPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队首发队员
    var alineupPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队停赛队员
    var asuspensionPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队替补队员
    var hbenchPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队受伤队员
    var hinjureiesPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队首发队员
    var hlineupPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队停赛队员
    var hsuspensionPersons:[FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
}

struct FootballLineupMemberInfo : HandyJSON {
    var personId: String!
    var personName: String!
    ///队员位置
    var position: String!
    ///队员位置X
    var positionX: String!
    ///队员位置Y
    var positionY: String!
}
