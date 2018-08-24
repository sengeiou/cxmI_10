//
//  HomeNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift



let homeProvider = MoyaProvider<HomeNetAPIManager>(requestClosure: requestClosure,plugins:[RequestLoadingPlugin()])


enum HomeNetAPIManager {
    /// 彩票大厅列表
    case homeList
    /// 彩票玩法列表
    case playList (fyId: String)
    /// 赛事列表
    case matchList (playType: String, leagueId: String)
    /// 赛事筛选 联赛列表
    case filterMatchList
    /// 筛选条件，开奖
    case filterList(dateStr: String)
    /// 计算投注信息
    case getBetInfo (requestModel: FootballRequestMode)
    /// 保存投注信息
    case saveBetInfo(requestModel: FootballRequestMode)
    /// 球队分析信息
    case matchTeamInfo(matchId: String)
    /// 球队分析信息 弹窗
    case matchTeamInfoSum(matchId: String)
    /// 咨询首页列表
    case newsList(page: Int)
    /// 咨询详情
    case newsDetail(articleId: String)
    /// 相关文章
    case newsRecommend(articleId: String, page: Int)
    /// 彩票大厅数据，和 咨询列表数据
    case hallMixData(page: Int, isTransaction: String)
    /// 彩票大厅数据，彩种新接口
    case hallMix(page: Int, isTransaction: String)
}

extension HomeNetAPIManager : TargetType {
    
    var baseURL : URL {
        return URL(string : baseURLStr + "/lottery" + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .homeList:
            return "/lottery/hall/getHallData"
        case .playList:
            return "/lottery/hall/getPlayClassifyList"
        case .matchList:
            return "/lottery/match/getMatchList"
            
        case .filterMatchList:
            return "/lottery/match/filterConditions"
        case .filterList:
            return "/lottery/match/getFilterConditionsSomeDay"
        case .getBetInfo:
            return "/lottery/match/getBetInfo"
        case .saveBetInfo:
            return "/lottery/match/nSaveBetInfo"
        case .matchTeamInfo:
            return "/lottery/match/matchTeamInfos"
        case .matchTeamInfoSum:
            return "/lottery/match/matchTeamInfosSum"
        case .newsList:
            return "/dl/article/list"
        case .newsDetail:
            return "/dl/article/detail"
        case .newsRecommend:
            return "/dl/article/relatedArticles"
        case .hallMixData:
            return "/lottery/hall/getHallMixData"
        case .hallMix:
            return "/lottery/hall/getAllLotteryInHallMixData"
            
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        
        
        switch self {
        case .playList(let fyId):
            dic["lotteryClassifyId"] = fyId
        case .matchList(let playType, let leagueId):
            dic["playType"] = playType
            dic["leagueId"] = leagueId
        case .filterMatchList:
            dic["str"] = ""
        case .filterList(let dateStr):
            dic["dateStr"] = dateStr
        case .matchTeamInfo(let matchId) :
            dic["matchId"] = matchId
        case .matchTeamInfoSum(let matchId) :
            dic["matchId"] = matchId
        case .getBetInfo(let requestModel) :
            dic = requestModel.toJSON()!
        case .saveBetInfo(let requestModel) :
            dic = requestModel.toJSON()!
        case .newsList(let page):
            dic["page"] = page
            dic["size"] = "20"
        case .newsDetail(let articleId):
            dic["articleId"] = articleId
        case .newsRecommend(let articleId, let page):
            dic["currentArticleId"] = articleId
            dic["page"] = page
        case .hallMixData(let page, let isTransaction ):
            dic["page"] = page
            dic["size"] = "20"
            dic["isTransaction"] = isTransaction
        case .hallMix(let page, let isTransaction ):
            dic["page"] = page
            dic["size"] = "20"
            dic["isTransaction"] = isTransaction
            
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
