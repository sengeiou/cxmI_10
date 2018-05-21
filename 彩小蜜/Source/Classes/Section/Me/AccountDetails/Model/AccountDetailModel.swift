//
//  AccountDetailModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct AccountDetailModel: HandyJSON {
    var accountSn: String!
    var addTime: String!
    var changeAmount: String!
    var isShow: String!
    var note: String!
    /// 0-全部 1-奖金 2-充值 3-购彩 4-提现 5-红包 ,
    var processType : String!
    var processTypeChar: String!
    var processTypeName: String!
    var shotTime: String!
    var status: String!
    var id : String!
    var payId: String!
    
}
