//
//  ActivityNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let activityProvider = MoyaProvider<ActivityNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum ActivityNetAPIManager {
    /// 用户信息
    case receiveRechargeBonus(payLogId : String)
    /// 保存世界杯投注信息
    case saveWCBetInfo(dic: [String: String])
    /// 首页弹屏
    case activity
    /// 首页弹屏 新版本
    case activityNew
}

extension ActivityNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath)!
    }
    
    var xpath: String {
        switch self {
        case .receiveRechargeBonus:
            return "/member/user/bonus/rechargeSucReiceiveBonus"
        case .saveWCBetInfo:
            return "/lottery/dl/wc/saveBetInfo"
        case .activity:
            return "/lottery/lottery/nav/banner/openNavs"
        case .activityNew:
            return "/lottery/lottery/nav/banner/openNavsNew"
        }
    }
    
    var task: Task {
        
        var dic : [String: Any] = [:]
        //dic["header"] = DeviceManager.share.device
        
        switch self {
        case .receiveRechargeBonus(let payLogId):
            dic["payLogId"] = payLogId
        case .saveWCBetInfo(let dict):
            dic = dict
        case .activityNew:
            dic["emptyStr"] = ""
        case .activity:
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
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "token" : UserInfoManager().getToken(),
            //            "header": DeviceManager.share.device.toJSONString()!
            //"token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxZDg4OTYxZDUtYjI0Yi00NzAxLWJhZWMtNzBkZmUxY2MwMDAzIiwidXNlcklkIjoiNDAwMDY4In0.1aBwA_Rasiew0kiLK8uR3AiUGj1iJ6ZZ8Hvup5v8tNUVMpQWWHVQBSrUBGCxZ28Lmsk0I-cQGQkOcAdoJKJQE1GGjDqSfAWGD951Kyq187C_axWKNazkRK1b-RIuuXV4ZSSSYhn0o45KsLCUh1YO76Q19oFnuVCbrF8DTvXTbSY"
        ]
    }
    var path : String {
        return ""
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
