//
//  DateProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/4/4.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation



protocol DateProtocol { }

extension DateProtocol {
    func timeStampToHHmm(_ timeStamp : Int) -> String {
        let timeInterval : TimeInterval = TimeInterval(timeStamp)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH: mm"
        
        return dateFormatter.string(from: date)
    }
    func getWeek() -> String {
        
        let weaks = ["星期日", "星期一","星期二","星期三","星期四","星期五","星期六"]
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        guard let index = comps.weekday else { return "" }
        
        return weaks[index - 1]
    }
}










