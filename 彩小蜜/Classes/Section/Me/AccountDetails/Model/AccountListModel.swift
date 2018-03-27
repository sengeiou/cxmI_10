//
//  AccountListModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct AccountListModel: HandyJSON {
    var title : String!
    var list: [AccountDetailModel]! = []
}
