//
//  SchoolListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct SchoolListModel : HandyJSON {
    var noviceClassroomList : [SchoolInfo] = [SchoolInfo]()
}

struct SchoolInfo : HandyJSON {
    var bannerImage : String = ""
    var bannerLink: String = ""
    var bannerName : String = ""
}
