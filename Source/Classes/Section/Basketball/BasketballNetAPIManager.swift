//
//  BasketballNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/19.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let basketBallProvider = MoyaProvider<BasketballNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum BasketballNetAPIManager {
    /// 篮球赛事列表
    case basketballMatchList(leagueId : String, playType: String)
    /// 篮球赛选条件列表
    case basketballFilterList()
}

extension BasketballNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .basketballMatchList:
            return "/lottery/lottery/match/getBasketBallMatchList"
        case .basketballFilterList:
            return "/lottery/lottery/match/filterBasketBallConditions"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .basketballMatchList(let leagueId, let playType):
            dic["leagueId"] = leagueId
            dic["playType"] = playType
        case .basketballFilterList:
            dic[""] = ""
        default:
            return .requestPlain
        }
        var dict : [String: Any] = [:]
        dict["body"] = dic
        dict["device"] = DeviceManager.share.device.toJSON()
        let jsonStr = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return .requestData(jsonStr!)
    }
    
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
