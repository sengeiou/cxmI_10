//
//  SettingDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

class SettingSectionModel: HandyJSON {
    required init() { }
    
    var sectionTitle : String! = ""
    var list : [SettingRowDataModel] = [SettingRowDataModel]()
}

class SettingRowDataModel: HandyJSON {
    required init() { }
    
    var title : String!
    var detail : String!
    var icon: String!
    var actUrl: String!
    var iconStr: String!
    var pushType: UserInfoSettingPushType = .设置密码
    var pwIsSeted : Bool = false
    var image : UIImage = UIImage(named: "head")!
    var imageStr : String!
}
