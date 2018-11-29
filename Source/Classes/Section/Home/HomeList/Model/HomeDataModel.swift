//
//  HomeDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import HandyJSON
import RealmSwift

class HomeRealmData : Object {
    @objc dynamic var data : Data = Data()
    @objc dynamic var homeStyle = 0
    @objc dynamic var idStr = "UUID().uuidString"

    override class func primaryKey() -> String? {
        return "idStr"
    }
}

struct HomeListModel : HandyJSON {
    var dlHallDTO : HomeDataModel!
    var dlArticlePage: NewsListModel!
}

struct HomeDataModel :  HandyJSON {
    var activity: HomeActivityModel!
    var lotteryClassifys: [HomePlayModel]! = [HomePlayModel]()
    var navBanners: [BannerModel]!
    var winningMsgs: [WinningMsgModel]!
    var discoveryHallClassifyDTOList : [HomeFindModel] = [HomeFindModel]()
}
/// 发现
struct HomeFindModel : HandyJSON {
    var classImg : String = ""
    var className : String = ""
    var classifyId: String = ""
    var redirectUrl: String = ""
    /// 是否上线 0 待上线,1上线
    var status : String = ""
    var statusReason : String = ""
    /// 发现页业务类型
    var type : String = ""
}
/// 玩法
struct HomePlayModel:  HandyJSON {
    var lotteryId: String!
    var playClassifyId: String!
    var lotteryImg: String = ""
    var playClassifyLabelId: String!
    var playClassifyLabelName: String!
    var lotteryName: String!
    var playType: String!
    var redirectUrl: String!
    var subTitle : String = ""
    var status : String = ""
    var statusReason : String = ""
}

/// 活动栏
struct HomeActivityModel:  HandyJSON {
    var actImg: String!
    var actTitle: String! = ""
    var actUrl: String!
}
