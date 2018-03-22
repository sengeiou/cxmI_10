//
//  MeNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let userProvider = MoyaProvider<MeNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum MeNetAPIManager {
    /// 用户信息
    case userInfo
    /// 实名认证
    case realNameAuth (idcode: String, realName: String)
    /// 实名认证信息
    case realInfo
    /// 添加银行卡
    case addBankCard (bankCardNo : String)
    /// 查询银行卡信息
    case bankList
    /// 提现界面的数据显示
    case withDrawDataShow
    /// 设置当前银行卡为默认卡
    case setBankDefault (cardId : String)
    /// 删除银行卡
    case deleteBank (status: String, cardId: String)
    /// 支付
    case payment (payCode: String, payToken: String)
    /// 支付订单结果
    case paymentQuery
    /// 充值
    case paymentRecharge (payCode: String, totalAmount: String)
    /// 提现
    case paymentWithdraw (totalAmount: String, userBankId: String)
}

extension MeNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr)!
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
        ]
    }
    
    var path : String {
        switch self {
        case .userInfo:
            return "/user/userInfoExceptPass"
        case .realNameAuth:
            return "/user/real/realNameAuth"
        case .realInfo:
            return "/user/real/userRealInfo"
        case .addBankCard:
            return "/user/bank/addBankCard"
        case .bankList:
            return "/user/bank/queryUserBankList"
        case .withDrawDataShow:
            return "/user/bank/queryWithDrawShow"
        case .setBankDefault:
            return "/user/bank/updateUserBankDefault"
        case .deleteBank:
            return "/user/bank/deleteUserBank"
        case .payment:
            return "/payment/app"
        case .paymentQuery:
            return "/payment/query"
        case .paymentRecharge:
            return "/payment/recharge"
        case .paymentWithdraw:
            return "/payment/withdraw"
            
            
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .realNameAuth(let idcode, let realName):
            dic["idcode"] = idcode
            dic["realName"] = realName
        case .addBankCard(let bankCardNo):
            dic["bankCardNo"] = bankCardNo.replacingOccurrences(of: " ", with: "")
            
        case .userInfo:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .realInfo:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .bankList:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .withDrawDataShow:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .setBankDefault ( let cardId ):
            dic["id"] = cardId
        case .deleteBank (let status, let cardId):
            dic["id"] = cardId
            dic["status"] = status
        case .payment(let payCode, let payToken):
            dic["payCode"] = payCode
            dic["payToken"] = payToken
        case .paymentRecharge(let payCode, let totalAmount):
            dic["payCode"] = payCode
            dic["totalAmount"] = totalAmount
        case .paymentWithdraw(let totalAmount, let userBankId):
            dic["totalAmount"] = totalAmount
            dic["userBankId"] = userBankId
        default:
            return .requestPlain
        }
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    
        
        return .requestData(jsonStr!)
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
