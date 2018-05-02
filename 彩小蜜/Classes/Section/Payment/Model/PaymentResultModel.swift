//
//  PaymentResultModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct PaymentResultModel : HandyJSON {
    var showMsg : String!
    var orderId: String!
    var payUrl: String!
    var wxAppPayInfo: PaymentInfoModel!
}

struct PaymentInfoModel: HandyJSON {
    var appid: String!
    var noncestr: String!
    var packageValue: String!
    var partnerid: String!
    var prepayid: String!
    var sign: String!
    var timestamp: String!
    
}

struct PaymentWeixinModel: HandyJSON {
    
}
