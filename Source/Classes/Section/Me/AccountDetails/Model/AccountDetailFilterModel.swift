//
//  AccountDetailFilterModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

class AccountDetailFilterModel: NSObject {
    required override init() { }
    
    var isSelected : Bool = false
    var date : String!
    var filterTime: FilterTime!
    
    static func getDate() -> [AccountDetailFilterModel] {
        var list = [AccountDetailFilterModel]()
        
        let model1 = AccountDetailFilterModel()
        model1.date = "当天"
        model1.filterTime = .当天
        list.append(model1)
        
        let model2 = AccountDetailFilterModel()
        model2.date = "最近一周"
        model2.filterTime = .最近一周
        model2.isSelected = true
        list.append(model2)
        
        let model3 = AccountDetailFilterModel()
        model3.date = "最近一月"
        model3.filterTime = .最近一月
        list.append(model3)
        
        let model4 = AccountDetailFilterModel()
        model4.date = "最近三月"
        model4.filterTime = .最近三月
        list.append(model4)
        
        let model5 = AccountDetailFilterModel()
        model5.date = "全部"
        model5.filterTime = .全部
        list.append(model5)
        
        return list
    }
}
