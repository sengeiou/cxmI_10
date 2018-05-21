//
//  UserInfoDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct UserInfoDataModel: HandyJSON {
    var birthday: String!
    var detailAddress: String!
    var email : String!
    var frozenMoney: String!
    var headimg : String!
    var isReal : Bool!
    var lastIp : String!
    var lastTime : String!
    var mobile : String!
    var mobileCity : String!
    var mobileProvince : String!
    var mobileSupplier : String!
    var nickname : String!
    var passWrongCount : String!
    var password : String!
    var payPoint : String!
    var payPwdSalt : String!
    var rankPoint : String!
    var regFrom : String!
    var regIp : String!
    var regTime : String!
    var salt : String!
    var sex : String!
    var surplusPassword : String!
    var userId : String!
    var userMoney : String!
    var userMoneyLimit : String!
    var userName : String!
    var userRemark : String!
    var userStatus : String!
    var userType : String!
    var totalMoney: String!
    var activityDTOList : [MeListDataModel]!
}




