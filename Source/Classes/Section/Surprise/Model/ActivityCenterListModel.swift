//
//  ActivityCenterListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct ActivityListModel : HandyJSON {
    var offlineList : [ActivityInfo] = [ActivityInfo]()
    var onlineList : [ActivityInfo] = [ActivityInfo]()
}
struct ActivityInfo : HandyJSON {
    var bannerImage : String = ""
    var bannerLink : String = ""
    var bannerName : String = ""
}

