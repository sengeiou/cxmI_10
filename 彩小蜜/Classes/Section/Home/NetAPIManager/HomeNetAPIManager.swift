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
    /// 彩票大厅列表
    case homeList
    
    case footBall
}

extension HomeNetAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr + "7077" + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .homeList:
            return "/lottery/hall/getHallData"
        case .footBall:
            return ""
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
            
        default:
            return .requestPlain
        }
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        
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
