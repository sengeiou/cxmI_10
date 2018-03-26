//
//  OrderSchemeInfoModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct OrderSchemeInfoModel: HandyJSON {
    var programmeSn: String!
    var ticketSchemeDetailDTOs: [SchemeDetail]!
}

struct SchemeDetail: HandyJSON {
    var multiple: String!
    var number: String!
    var passType: String!
    var tickeContent: String!
}
