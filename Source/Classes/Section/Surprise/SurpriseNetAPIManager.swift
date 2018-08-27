//
//  SurpriseNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift



let surpriseProvider = MoyaProvider<SurpriseAPIManager>(requestClosure: requestClosure,plugins:[RequestLoadingPlugin()])


enum SurpriseAPIManager {
    /// 发现首页列表
    case surpriseList(pageNum : Int)
    
}

extension SurpriseAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .surpriseList:
            return "/lottery/dl/article/discoveryPage"
            
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .surpriseList(let pageNum):
            dic["page"] = pageNum
            dic["size"] = "20"
            
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
