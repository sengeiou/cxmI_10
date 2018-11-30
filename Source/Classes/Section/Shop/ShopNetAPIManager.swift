//
//  ShopNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Moya
import RxSwift

let shopProvider = MoyaProvider<ShopNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum ShopNetAPIManager {
    /// 轮播图
    case bannerList
    /// 计算商品价钱
    case calculatePrice(orderId : String, goodsNum : String)
    /// 提交商品（订单）
    case goodsAdd(goodsId : String)
    /// 商品详情
    case goodsDetail(goodsId : String)
    /// 商品首页
    case goodsList(page : Int)
    /// 商品信息更新 (购买)
    case goodsUpdate(model : GoodsOrderUpdate)
    /// 订单q详情
    case orderDetail(orderId : String)
}

extension ShopNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath )!
    }
    
    var xpath : String {
        switch self {
        case .bannerList:
            return "/order/goods/bannerList"
        case .calculatePrice:
            return "/order/goods/calculatePrice"
        case .goodsAdd:
            return "/order/goods/goodsAdd"
        case .goodsDetail:
            return "/order/goods/goodsDetail"
        case .goodsList:
            return "/order/goods/goodsList"
        case .goodsUpdate:
            return "/order/goods/goodsUpdate"
        case .orderDetail:
            return "/order/goods/orderDetail"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .goodsList(let page):
            dic["page"] = page
            dic["size"] = "20"
        case .goodsDetail(let goodsId):
            dic["goodsId"] = goodsId
        case .goodsAdd(let goodsId):
            dic["goodsId"] = goodsId
        case .orderDetail(let orderId):
            dic["orderId"] = orderId
        case .calculatePrice(let orderId, let goodsNum):
            dic["orderId"] = orderId
            dic["num"] = goodsNum
        case .goodsUpdate(let model):
            dic = model.toJSON()!
        case .bannerList:
            dic["emptyStr"] = ""
        default:
            return .requestPlain
        }
        var dict : [String: Any] = [:]
        dict["body"] = dic
        dict["device"] = DeviceManager.share.device.toJSON()
        let jsonStr = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return .requestData(jsonStr!)
    }
    
    var path : String { return ""}
    
    var method : Moya.Method {
        switch self {
            
        default:
            return .post
        }
    }
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
        ]
    }
    var parameters: [String: Any]? {
        switch self {
            
        default:
            return nil
        }
    }
    
    
    
    var parameterEncoding: ParameterEncoding {
        switch self {
            
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
