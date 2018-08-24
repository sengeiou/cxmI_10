//
//  CXMMDLTNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift



let dltProvider = MoyaProvider<DLTAPIManager>(requestClosure: requestClosure,plugins:[RequestLoadingPlugin()])


enum DLTAPIManager {
    /// 大乐透列表
    case tickenInfo
    /// 订单详情
    case orderDetail(orderId: String)
    /// 出票方案
    case ticketScheme(orderSn: String, programmeSn: String)
    /// 走势图
    /// compute : 是否计算统计，0不统计，1统计，默认1
    /// count : 期数，30，50，100，默认100
    /// drop : 是否显示遗漏0不显示，1显示，默认1
    /// sort : 排序, 0正序1倒序，默认为0
    case chartData(compute : Bool, count: String, drop : Bool, sort : Bool, tab : String)
    /// 投注确认
    case setInfo(model : DLTBetInfoRequestModel)
}

extension DLTAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .tickenInfo:
            return "/lotto/lotto/getTicketInfo"
        case .orderDetail:
            return "/order/order/getLottoOrderDetail"
        case .ticketScheme:
            return "/order/order/getLottoTicketScheme"
        case .chartData:
            return "/lotto/lotto/getChartData"
        case .setInfo:
            return "/lotto/lotto/saveBetInfo"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .tickenInfo:
            //dic["s"] = ""
            break
        case .orderDetail(let orderId):
            dic["orderId"] = orderId
        case .ticketScheme(let orderSn, let programmeSn):
            dic["orderSn"] = orderSn
            dic["programmeSn"] = programmeSn
        case .chartData(let compute, let count, let drop, let sort, let tab):
            dic["compute"] = compute
            dic["count"] = count
            dic["drop"] = drop
            dic["sort"] = sort
            dic["tab"] = tab
        case .setInfo(let model):
            dic = model.toJSON()!
            
        default:
            return .requestPlain
        }
        
        var dict : [String: Any] = [:]
        dict["body"] = dic
        dict["device"] = DeviceManager.share.device.toJSON()
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        return .requestData(jsonStr!)
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
            //"token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxZDg4OTYxZDUtYjI0Yi00NzAxLWJhZWMtNzBkZmUxY2MwMDAzIiwidXNlcklkIjoiNDAwMDY4In0.1aBwA_Rasiew0kiLK8uR3AiUGj1iJ6ZZ8Hvup5v8tNUVMpQWWHVQBSrUBGCxZ28Lmsk0I-cQGQkOcAdoJKJQE1GGjDqSfAWGD951Kyq187C_axWKNazkRK1b-RIuuXV4ZSSSYhn0o45KsLCUh1YO76Q19oFnuVCbrF8DTvXTbSY"
        ]
    }
    
    var method : Moya.Method {
        switch self {
        default:
            return .post
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
