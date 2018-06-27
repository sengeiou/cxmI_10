//
//  AccountDetailData.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct AccountDetailData: HandyJSON {
    var pageInfo : BasePageModel<AccountDetailModel>!
    var userAccountByTimeDTO: AccountStatisticsModel!
}

