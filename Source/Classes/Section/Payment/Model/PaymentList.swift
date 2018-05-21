//
//  PaymentList.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct PaymentList : HandyJSON {
    var isEnable: Bool!
    var payCode: String!
    var payConfig: String!
    var payDesc: String!
    var payFee: String!
    var payId: String!
    var payImg: String!
    var payName: String!
    var paySort: String!
    var payTitle: String!
    var payType: String!
}
