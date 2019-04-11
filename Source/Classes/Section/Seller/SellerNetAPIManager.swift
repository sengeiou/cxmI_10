//
//  SellerNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Moya
import RxSwift

let sellerProvider = MoyaProvider<SellerNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum SellerNetAPIManager {
    /// 店铺列表 合作商家
    case sellerList
    /// 店铺详情 合作商家
    case sellerDetail(shopId : String)
}

extension SellerNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath )!
    }
    
    var xpath : String {
        switch self {
        case .sellerList:
            return "/order/store/storelist"
        case .sellerDetail:
            return "/order/store/storedetail"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .sellerList:
            dic["str"] = ""
        case .sellerDetail(let shopId):
            dic["id"] = shopId
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

