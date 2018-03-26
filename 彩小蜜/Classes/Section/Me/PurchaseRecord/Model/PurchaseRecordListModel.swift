//
//  PurchaseRecordListModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct PurchaseRecordListModel: HandyJSON {
    var endRow: String!
    var firstPage: String!
    var hasNextPage: String!
    var hasPreviousPage: String!
    var isFirstPage: String!
    var isLastPage: Bool!
    var lastPage: String!
    var nextPage: Int!

    var list : [PurchaseRecordInfoModel]!
}
