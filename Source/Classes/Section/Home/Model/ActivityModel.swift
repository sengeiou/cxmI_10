//
//  ActivityModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import HandyJSON




class ActivityModel : NSObject, HandyJSON {
    required override init() { }
    
//    var promotionModel: promotionModel!
//    var couponModel: couponModel!
    var name : String!
    
    var bannerImage : String = ""
    var bannerLink : String = ""
    var bannerName : String = ""
    var endTime : String = ""
    var startTime : String = ""
    
    var bonusPrice : String = ""
    var bonusNumber : String = ""
    
}


//struct ActivityModel : HandyJSON {
//    var promotionModel: [promotionModel]!
//    var couponModel: [couponModel]!
//}

struct promotionModel : HandyJSON {
    var bannerImage : String = ""
    var bannerLink : String = ""
    var bannerName : String = ""
    var endTime : String = ""
    var startTime : String = ""
    var name : Int!
}

struct couponModel : HandyJSON {
    var bonusPrice : String = ""
    var name : Int!
    var bonusNumber : String = ""
}
