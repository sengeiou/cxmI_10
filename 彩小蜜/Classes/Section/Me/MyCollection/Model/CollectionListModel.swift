//
//  CollectionListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct CollectionListModel: HandyJSON {
    var endRow: String!
    var firstPage: Int!
    var hasNextPage: Bool!
    var hasPreviousPage: Bool!
    var isFirstPage: Bool!
    var isLastPage: Bool!
    var lastPage: Int!
    var navigateFirstPage: Int!
    var nextPage: Int!
    var pageNum: Int!
    var pageSize: Int!
    var pages: Int!
    var prePage: Int!
    var size: Int!
    var startRow: Int!
    var total: Int!
    var list:[CollectionModel]!
}

struct CollectionModel: HandyJSON {
    var addTime: String!
    var articleId: String!
    var collectFrom: String!
    var id: String!
}
