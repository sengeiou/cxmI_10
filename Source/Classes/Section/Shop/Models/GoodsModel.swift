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
    var detailPicList : [GoodsImage]!
    /// 历史价格
    var historyPrice : String = ""
    /// 付款人数
    var paidNum : String = ""
    /// 当前价格
    var presentPrice : String = ""
}

struct GoodsImage : HandyJSON {
    var image : String = ""
}

struct GoodsOrderDetail : HandyJSON {
    var description : String = ""
    var orderId : String = ""
    var orderPic : String = ""
    var price : String = ""
}
struct GoodsCalculate : HandyJSON {
    var totalPrice : String = ""
}
struct GoodsOrderUpdate : HandyJSON {
    var address : String = ""
    var contactsName : String = ""
    var goodsId : String = ""
    var num : String = ""
    var phone : String = ""
}
