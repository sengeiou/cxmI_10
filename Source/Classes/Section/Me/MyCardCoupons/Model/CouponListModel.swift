//
//  CouponListModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct CouponListModel: HandyJSON {
    var list : [CouponInfoModel]!
    var endRow : String!
    var pageSize : String!
    var nextPage : Int!
    var isLastPage : Bool!
}
