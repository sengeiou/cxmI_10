//
//  BasePageModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON



struct BasePageModel<T>: HandyJSON {
    var list: [T]!
    var endRow: String!
    var firstPage: String!
    var hasNextPage: String!
    var hasPreviousPage: String!
    var isFirstPage: String!
    var isLastPage: Bool!
    var lastPage: String!
    var nextPage: Int!
    var pageNum: Int!
    var pageSize: String!
    var pages: String!
    var prePage: String!
    var size: String!
    var startRow: String!
    var total: String!

}
