//
//  LeagueListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct LeagueMatchModel : HandyJSON {
    
    var contryName: String = ""
    var contryPic : String = ""
    var groupId : String = ""
    var leagueInfoList : [LeagueInfoModel] = [LeagueInfoModel]()
}

struct LeagueInfoModel : HandyJSON {
    var leagueAddr : String = ""
    var leagueId : String = ""
    var leagueName: String = ""
    var leaguePic: String = ""
    /// 联赛首字母缩写
    var leagueInitials : String = ""
    /// 赛季ID
    var seasonId : String = ""
}


