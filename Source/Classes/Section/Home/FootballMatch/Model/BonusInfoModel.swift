//
//  BonusInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class BonusInfoModel: HandyJSON {
    required init() { }
    
    var isSelected : Bool = false
    
    var bonusId: String!
    var bonusName: String!
    var bonusPrice: String!
    var bonusStatus: String!
    var bonusType: String!
    var isCanReceive: String!
    var limitTime: String! = ""
    var lotteryId: [String]!
    var minGoodsAmount: String!
    var useHelp: String!
    var useRange: String!
    var userBonusId: String!
    var leaveTime: String = ""
}
