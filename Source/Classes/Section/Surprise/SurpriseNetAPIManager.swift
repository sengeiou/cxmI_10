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
    case surpriseList()
    /// 开奖结果
    case prizeList()
    /// 活动中心
    case activityCenter()
    /// 联赛信息 首页
    case leagueList(groupId: String)
    /// 联赛详情
    case leagueDetail(leagueId : String)
    /// 历史开奖
    case lottoPrizeList(page : Int, lotteryId : String)
    /// 竞彩历史开奖
    case matchPrizeList(date : String, lotteryId : String)
    /// 开奖详情  （期号）
    case lottoPrizeDetail(termNum : String)
    /// 小白课堂
    case schoolList()
    
}

extension SurpriseAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .surpriseList:
            return "/lottery/discoveryPage/homePage"
        case .prizeList:
            return "/lottery/discoveryPage/openPrize"
        case .activityCenter:
            return "/lottery/discoveryPage/activeCenter"
        case .leagueList:
            return "/lottery/discoveryPage/leagueHomePageByGroupId"
        case .leagueDetail:
            return "/lottery/discoveryPage/leagueDetail"
        case .lottoPrizeList:
            return "/lottery/discoveryPage/szcDetailList"
        case .lottoPrizeDetail:
            return "/lottery/discoveryPage/lottoDetails"
        case .schoolList:
            return "/lottery/discoveryPage/noviceClassroom"
        case .matchPrizeList:
            return "/lottery/discoveryPage/queryJcOpenPrizesByDate"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .surpriseList:
            dic["emptyStr"] = "20"
        case .prizeList:
            dic["emptyStr"] = "20"
        case .activityCenter:
            dic["emptyStr"] = "20"
        case .leagueList (let groupId):
            dic["groupId"] = groupId
        case .leagueDetail(let leagueId):
            dic["leagueId"] = leagueId
        case .lottoPrizeList(let page, let lotteryId):
            dic["page"] = page
            dic["size"] = "20"
            dic["lotteryClassify"] = lotteryId
        case .lottoPrizeDetail(let termNum) :
            dic["termNum"] = termNum
        case .schoolList:
            dic["emptyStr"] = "20"
        case .matchPrizeList(let date, let lotteryId):
            dic["dateStr"] = date
            dic["lotteryClassify"] = lotteryId
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
