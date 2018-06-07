//
//  PaymentList.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct AllPaymentModel: HandyJSON {
    /// 0-没有充值活动 1-有充值活动
    var isHaveRechargeAct : Bool!
    /// 支付方式
    var paymentDTOList: [PaymentList]!
    /// 充值用户具体信息
    var rechargeUserDTO: RechargeUserInfo!
}

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

struct RechargeUserInfo: HandyJSON {
    var donationPriceList : [RechargeDonationPrice]!
    /// 0-未充过值，即新用户 1- 充过值，即老用户
    var oldUserBz: String!
}

struct RechargeDonationPrice: HandyJSON {
    var donationAmount: String!
    var minRechargeAmount: Double!
}
