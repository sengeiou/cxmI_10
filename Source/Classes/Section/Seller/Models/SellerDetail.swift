//
//  SellerDetail.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct SellerListModel : HandyJSON {
    var list : [SellerInfoModel]!
    var protocalUrl : String!
}

struct SellerInfoModel : HandyJSON {
    var collNum : String = ""
    var cooperAuth : String = ""
    var storeId : String = ""
    var logo : String = ""
    var name : String = ""
}

struct SellerDetailModel : HandyJSON {
    /// 是否有营业执照
    var bizPermit : String = ""
    /// 收藏人数
    var collNum : String = ""
    /// 是否是合作店铺 0非合作店铺 1合作店铺
    var cooperAuth : String = ""
    var storeId : String = ""
    var imgWechat : String = ""
    
    var jumpUrl : String = ""
    var logo : String = ""
    var name : String = ""
    var wechat : String = ""
    /// 营业执照
    var bizPermitUrl : String = ""
}


