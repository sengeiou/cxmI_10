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
    case lotteryResult (date: String, isAlready: Bool, leagueIds: String, finished: Bool)
}

extension LotteryNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr + "7077" + xpath )!
    }
    
    var xpath : String {
        switch self {
        case .lotteryResult:
            return "/lottery/match/queryMatchResult"
        }
    }
    
    var path : String {
        
        switch self {
        
        case .lotteryResult:
            return ""
        }
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
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .lotteryResult(let date, let isAlready, let leagueIds, let finished ):
            dic["dateStr"] = date
            if isAlready == false {
                dic["isAlreadyBuyMatch"] = ""
            }else {
                dic["isAlreadyBuyMatch"] = isAlready
            }
            if finished {
                dic["matchFinish"] = finished
            }else{
                dic["matchFinish"] = ""
            }
            
            if leagueIds == "" {
                dic["leageuIds"] = [String]()
            }else {
                let leaList = leagueIds.components(separatedBy: ",")
                
                dic["leageuIds"] = leaList
            }
            
            
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
