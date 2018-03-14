//
//  HomeDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import HandyJSON

struct HomeDataModel : HandyJSON {
    
    var content_url: String?
    var cover_image_url: String?
    var created_at: String?
    var id: String?
    var liked: String?
    var likes_count: Int = 0
    var share_msg: String?
    var published_at: String?
    var short_title: String?
    var status: String?
    var type: String?
    var title: String?
    var template: String?
    var updated_at: String?
    var url : String?
//    init() {
//        
//    }
    
}
