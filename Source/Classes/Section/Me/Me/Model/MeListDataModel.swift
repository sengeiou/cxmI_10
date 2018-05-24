//
//  MeListDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct MeSectionModel: HandyJSON {
    var list : [MeListDataModel] = [MeListDataModel]()
}

struct MeListDataModel: HandyJSON {
    var title : String!
    var detail : String!
    var icon: String!
    var actUrl: String!
    var iconStr: String!
    var pushType: MePushType = .活动
    var showNotic : Bool = false
}
