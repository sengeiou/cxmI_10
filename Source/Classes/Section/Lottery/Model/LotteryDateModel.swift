
//
//  LotteryDateModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class LotteryDateModel : NSObject, HandyJSON {
    required override init() { }
    
    var isSelected : Bool = false
    var date : String!
    
    
    
    func getDates() ->[LotteryDateModel] {
        var dates = [LotteryDateModel]()
        
        let currentDate = Date()
        let userCalendar = Calendar.current
        
        for index in -16...3 {
            let date = userCalendar.date(byAdding: .day, value: index, to: currentDate)
            let dateFor = DateFormatter()
            dateFor.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFor.string(from: date!)
            let dateModel = LotteryDateModel()
            dateModel.date = dateStr
            dates.append(dateModel)
        }
        dates[16].isSelected = true
        return dates
    }
}
