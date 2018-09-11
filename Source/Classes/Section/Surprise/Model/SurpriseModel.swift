//
//  SurpriseModel.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import Foundation
import HandyJSON

struct SurpriseModel: HandyJSON {
    var discoveryHallClassifyList : [SurpriseItemInfo] = [SurpriseItemInfo]()
    
    /// 联赛 list
    var hotLeagueList : [LeagueInfoModel] = [LeagueInfoModel]()
    /// 射手榜List
    var topScorerDTOList : [SurpriseScorerInfo] = [SurpriseScorerInfo]()
    
}

struct SurpriseLeagueInfo : HandyJSON {
    var actUrl: String = ""
    var detail : String = ""
    var iconImg: String = ""
    var title : String = ""
    
    
}

struct SurpriseItemInfo : HandyJSON {
    var classImg : String = ""
    var className : String = ""
    var redirectUrl : String = ""
    var subTitle : String = ""
    var status : String = ""
    var statusReason : String = ""
}

struct SurpriseScorerInfo : HandyJSON {
    var leagueName: String = ""
    var topScorerMemberList : [SurpriseMemberInfo]!
}
struct SurpriseMemberInfo : HandyJSON {
    var memberName: String = ""
    var ranking : String = ""
    var topScorerTeam: String = ""
    var totalGoal: String = ""
}
