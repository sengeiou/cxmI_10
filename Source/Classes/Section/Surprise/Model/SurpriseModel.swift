//
//  SurpriseModel.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import Foundation
import HandyJSON

struct SurpriseModel: HandyJSON {
    var discoveryHallClassifyList : [SurpriseItemInfo] = [SurpriseItemInfo]()
    
    var dlArticlePage : BasePageModel<ArticleInfo>!
}

struct SurpriseItemInfo : HandyJSON {
    var classImg : String = ""
    var className : String = ""
    var redirectUrl : String = ""
    var subTitle : String = ""
}

struct ArticleInfo : HandyJSON {
    var addTime : String = ""
    var articleId : String = ""
    var articleThumb: String = ""
    var author : String = ""
    var clickNumber : String = ""
    var extendCat : String = ""
    var isStick : String = ""
    var keywords : String = ""
    var link : String = ""
    var listStyle : String = ""
    var matchId : String = ""
    var relatedTeam : String = ""
    var summary : String = ""
    var title : String = ""
}
