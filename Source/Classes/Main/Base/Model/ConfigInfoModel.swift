//
//  ConfigInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct ConfigInfoModel: HandyJSON {
    var businessType: String!
    var id : String!
    var platform: String!
    var turnOn : Bool!
    var version : String!
}
