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
    /// 比赛结果
    case lotteryResultNew (date: String, isAlready: Bool, leagueIds: String, type: String)
    /// 阵容信息
    case lineupInfo(matchId: String)
    /// 赛况信息
    case liveInfo(matchId: String)
    /// 筛选时间
    case dateFilter
}

extension LotteryNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + "/lottery" + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .lotteryResult:
            return "/lottery/match/queryMatchResult"
        case .lotteryResultNew:
            return "/lottery/match/queryMatchResultNew"
        case .lineupInfo:
            return "/match/lineup/info"
        case .liveInfo:
            return "/match/live/info"
        case .dateFilter:
            return "/lottery/match/giveMatchChooseDate"
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
                dic["isAlreadyBuyMatch"] = "1"
            }
            if finished {
                dic["matchFinish"] = "1"
            }else{
                dic["matchFinish"] = ""
            }
            
            dic["leagueIds"] = leagueIds
        case .lotteryResultNew(let date, let isAlready, let leagueIds, let type) :
            dic["dateStr"] = date
            dic["leagueIds"] = leagueIds
            dic["type"] = type
            if isAlready == false {
                dic["isAlreadyBuyMatch"] = ""
            }else {
                dic["isAlreadyBuyMatch"] = "1"
            }
            
        case .lineupInfo(let matchId):
            dic["matchId"] = matchId
            
        case .liveInfo(let matchId):
            dic["matchId"] = matchId
        case .dateFilter:
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
