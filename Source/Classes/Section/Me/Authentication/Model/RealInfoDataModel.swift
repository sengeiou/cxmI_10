//
//  RealInfoDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct RealInfoModel: HandyJSON {
    var code : String!
    var msg  : String!
    var data : RealInfoDataModel?
}

struct RealInfoDataModel: HandyJSON {
    var cardPic1 : String!
    var cardPic2 : String!
    var cardPic3 : String!
    var idcode   : String!
    var realName : String!
    var status   : String!
}
