//
//  FootballSaveBetInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class FootballSaveBetInfoModel : HandyJSON{
    required init() { }
    
    var showMsg : String!
    
    var bonusAmount : String!
    var bonusId : String!
    var bonusList: [BonusInfoModel]!
    var orderMoney: String!
    var payToken: String!
    var surplus: String!
    var thirdPartyPaid: Double!
    var lotteryClassifyId : String!
    
    func setBonus() {
        for bonus in bonusList {
            if bonus.userBonusId == bonusId || bonus.bonusId == bonusId{
                bonus.isSelected = true
                return
            }
        }
    }
    
}

struct SaveBetInfoModel : HandyJSON {
    var orderId : String = ""
    var payToken : String = ""
}
