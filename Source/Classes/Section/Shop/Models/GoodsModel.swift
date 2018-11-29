//
//  GoodsModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct GoodsListModel : HandyJSON {
    /// 描述
    var description : String = ""
    /// id
    var goodsId : String = ""
    /// 历史价格
    var historyPrice : String = ""
    /// 商品图片
    var mainPic : String = ""
    /// 付款人数
    var paidNum : String = ""
    /// 当前价格
    var presentPrice : String = ""
}

struct GoodsDetailModel: HandyJSON {
    /// 轮播图
    var bannerList : [BannerModel]!
    /// 基本属性
    var baseAttributeList : [String]!
    /// 描述
    var description : String = ""
    /// 详情图
    var detailPic : String = ""
    /// 历史价格
    var historyPrice : String = ""
    /// 付款人数
    var paidNum : String = ""
    /// 当前价格
    var presentPrice : String = ""
}


