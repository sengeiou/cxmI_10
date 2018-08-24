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
    var dlArticlePage: NewsListModel!
    var bigNewsList : [NewsInfoModel] = [NewsInfoModel]()
}
