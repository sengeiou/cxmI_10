//
//  SettingDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct SettingSectionModel: HandyJSON {
    var sectionTitle : String! = ""
    var list : [SettingListDataModel] = [SettingListDataModel]()
}

struct SettingListDataModel: HandyJSON {
    var title : String!
    var detail : String!
    var icon: String!
    var actUrl: String!
    var iconStr: String!
    var pushType: UserInfoSettingPushType = .设置密码
    var pwIsSeted : Bool = false
}
