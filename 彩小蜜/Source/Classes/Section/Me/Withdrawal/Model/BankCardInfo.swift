//
//  BankCardInfo.swift
//  彩小蜜
//
//  Created by HX on 2018/3/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct BankCardInfo: HandyJSON {
    var showMsg  : String!
    var bankLogo : String!
    var bankName : String!
    var cardNo   : String!
    var realName : String!
    var status   : String!
    var userBankId: String!
    var userId   : String!
    var lastCardNo4 : String!
}
