//
//  HomeNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let homeProvider = MoyaProvider<HomeNetAPIManager>(plugins:[RequestLoadingPlugin()])


enum HomeNetAPIManager {
    case homeList
    case footBall
}

extension HomeNetAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var path : String {
        
        switch self {
        case .homeList:
            return "v1/channels/\(1)/items"
        case .footBall:
            return ""
        }
    }
    
    var method : Moya.Method {
        switch self {
        case .homeList:
            return .get
        default:
            return .post
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        
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
        case .homeList:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    
}
