//
//  BBGetBetInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON


struct BBGetBetInfoModel : HandyJSON {
    /// 注数
    var betNum : String = ""
    /// 倍数
    var times : String = ""
    var issue : String = ""
    /// 最大奖金
    var maxBonus : String = ""
    /// 最大投注彩票金额
    var maxLotteryMoney : String = ""
    /// 最小奖金
    var minBonus : String = ""
    /// 彩票金额
    var money : String = ""
}
