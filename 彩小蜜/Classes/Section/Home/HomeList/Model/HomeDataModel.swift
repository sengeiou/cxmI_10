//
//  HomeDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import HandyJSON


struct HomeDataModel : HandyJSON {
    var activity: HomeActivityModel!
    var dlPlayClassifyDetailDTOs: [HomePlayModel]!
    var navBanners: [BannerModel]!
    var winningMsgs: [WinningMsgModel]!
}

/// 玩法
struct HomePlayModel: HandyJSON {
    var playClassifyId: String!
    var playClassifyImg: String!
    var playClassifyLabelId: String!
    var playClassifyLabelName: String!
    var playClassifyName: String!
    var playType: String!
}

/// 活动栏
struct HomeActivityModel: HandyJSON {
    var actImg: String!
    var actTitle: String!
    var actUrl: String!
}
