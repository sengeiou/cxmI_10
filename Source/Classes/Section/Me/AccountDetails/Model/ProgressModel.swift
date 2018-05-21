//
//  ProgressModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import HandyJSON

struct ProgressLogModel: HandyJSON {
    var logCode: String!
    var logName: String!
    var logTime: Int!
    var withdrawSn: String!
    var amount: String!
    var card: String!
    var status : String!
}

struct ProgressModel: HandyJSON {
    
    var userWithdrawLogs: [ProgressLogModel]!
    var amount: String!
    var card : String!
    var status : String!
}
