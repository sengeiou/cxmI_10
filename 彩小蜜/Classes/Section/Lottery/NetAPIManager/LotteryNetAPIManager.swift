//
//  LotteryNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let lotteryProvider = MoyaProvider<LotteryNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum LotteryNetAPIManager {
    case lottery
}

extension LotteryNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var path : String {
        
        switch self {
        
        case .lottery:
            return ""
        }
    }
    
    var method : Moya.Method {
        switch self {
        
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        default:
            return nil
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        dic["loginSource"] = "2"
        
        switch self {
//        case .register(let mobile ,let password, let vcode):
//            dic["mobile"] = mobile
//            dic["password"] = password
//            dic["smsCode"] = vcode
//        case .loginByPass(let mobile, let password):
//            dic["mobile"] = mobile
//            dic["password"] = password
        default:
            return .requestPlain
        }
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return .requestData(jsonStr!)
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
