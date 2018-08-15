//
//  PaymentNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let paymentProvider = MoyaProvider<PaymentNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum PaymentNetAPIManager {
    /// 支付
    case payment (payCode: String, payToken: String)
    /// 支付订单结果
    case paymentQuery(payLogId: String)
    /// 充值
    case paymentRecharge (payCode: String, totalAmount: String)
    /// 提现
    case paymentWithdraw (totalAmount: String, userBankId: String)
    /// 可用第三方支付方式 list
    case paymentAll
    /// 可用第三方支付方式 list
    case allPayment
    
    /// 新支付
    case paymentNew(payCode: String, payToken: String)
    /// 支付订单金额计算
    case payBefore(bonusId: String, payToken: String)
    
}

extension PaymentNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr + "/payment" + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .payment:
            return "/payment/app"
        case .paymentNew:
            return "/payment/nUnifiedOrder"
        case .paymentQuery:
            return "/payment/query"
        case .paymentRecharge:
            return "/payment/recharge"
        case .paymentWithdraw:
            return "/cash/withdraw"
        case .paymentAll:
            return "/payment/allPayment"
        case .allPayment:
            return "/payment/allPaymentWithRecharge"
        case .payBefore:
            return "/payment/unifiedPayBefore"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .payment(let payCode, let payToken):
            dic["payCode"] = payCode
            dic["payToken"] = payToken
        case .paymentNew(let payCode, let payToken):
            dic["payCode"] = payCode
            dic["payToken"] = payToken
            
        case .paymentRecharge(let payCode, let totalAmount):
            dic["payCode"] = payCode
            dic["totalAmount"] = totalAmount
        case .paymentWithdraw(let totalAmount, let userBankId):
            dic["totalAmount"] = totalAmount
            dic["userBankId"] = userBankId
        case .paymentQuery(let payLogId):
            dic["payLogId"] = payLogId
        case .paymentAll:
            break
        case .payBefore(let bonusId, let payToken):
            dic["bonusId"] = bonusId
            dic["payToken"] = payToken
        default:
            break
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
