//
//  MessageCenterModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct MessageCenterModel: HandyJSON {
    var contentDesc: String!
    var receiverMobile: String!
    var sendTime: String!
    var content: String!
    var msgUrl: String!
    var msgType: String!
    var isRead: Bool!
    var objectType: String!
    var title: String!
    var msgDesc: String!
    var msgId: String!
    var receiver: String!
    var contentUrl: String!
    
}

