//
//  FootballFilterModel.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

class FilterData: HandyJSON {
    
    required init() { }
}

class FilterModel: HandyJSON {
    var isSelected : Bool = false
    required init() { }
}
