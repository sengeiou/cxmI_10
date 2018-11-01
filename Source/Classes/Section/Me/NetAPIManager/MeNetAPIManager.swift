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
    /// 优惠券列表  红包状态:空字符串-全部 0-未使用 1-已使用 2-已过期
    case couponList (status: String, pageNum: Int)
    /// 单个优惠券
    case coupon (userBonusId: String)
    /// 订单列表 - 投注记录 -1 -所有订单 2-待开奖 4-已中奖  fyId :
    case orderInfoList (fyd : String, orderStatus: String, pageNum: Int)
    /// 订单详情
    case orderInfo (orderId: String)
    /// 出票方案
    case orderScheme (programmeSn: String, orderSn: String)
    /// 账户明细列表
    case accountDetailsList (amountType: String, pageNum: Int, timeType: String)
    /// 统计账户信息
    case accountStatistics(timeType: String)
    /// 消息列表 0通知，1消息 
    case messageList (msgType: String, pageNum: Int)
    /// 提现进度
    case withdrawProgressList (withdawSn: String)
    /// 添加收藏
    case collectAdd(articledId: String)
    /// 删除收藏
    case collectDelete(collectId : String)
    /// 收藏列表
    case collectList(pageNum: Int)
    /// 切换
    case configQuety
    /// 用户投诉
    case complain(content: String)
    /// 查询用户卡券or消息提示
    case queryUserNotice
    /// 更新未读消息提示  type: 1我的卡券，2消息中心
    case updateUnReadNotic(type: String)
    /// 设置用户登录密码、修改用户登录密码
    case setLoginPass(oldPass: String?, newPass: String, type : String)
    
    /// 账户明细列表，带统计信息
    case accountDetailsListAndTotal(amountType: String, pageNum: Int, timeType: String)
    /// 收藏赛事
    case collectMatch(matchId: String, dateStr: String)
    /// 取消收藏赛事
    case collectMatchCancle(matchId: String, dateStr: String)
    /// 发现
    case surprise(page: Int, extendCat: String)
    /// 展示文案 1- 提现说明文案
    case copywriting(type : String)
}

extension MeNetAPIManager : TargetType {
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath)!
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "token" : UserInfoManager().getToken(),
//            "header": DeviceManager.share.device.toJSONString()!
            //"token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxZDg4OTYxZDUtYjI0Yi00NzAxLWJhZWMtNzBkZmUxY2MwMDAzIiwidXNlcklkIjoiNDAwMDY4In0.1aBwA_Rasiew0kiLK8uR3AiUGj1iJ6ZZ8Hvup5v8tNUVMpQWWHVQBSrUBGCxZ28Lmsk0I-cQGQkOcAdoJKJQE1GGjDqSfAWGD951Kyq187C_axWKNazkRK1b-RIuuXV4ZSSSYhn0o45KsLCUh1YO76Q19oFnuVCbrF8DTvXTbSY"
        ]
    }
    
    var path : String {
        return ""
    }
    
    var xpath: String {
        switch self {
        case .userInfo:
            return "/member/user/userInfoExceptPass"
        case .realNameAuth:
            return "/member/user/real/realNameAuth"
        case .realInfo:
            return "/member/user/real/userRealInfo"
        case .addBankCard:
            return "/member/user/bank/addBankCard"
        case .bankList:
            return "/member/user/bank/queryUserBankList"
        case .withDrawDataShow:
            return "/member/user/bank/queryWithDrawShow"
        case .setBankDefault:
            return "/member/user/bank/updateUserBankDefault"
        case .deleteBank:
            return "/member/user/bank/deleteUserBank"
        case .couponList:
            return "/member/user/bonus/queryBonusListByStatus"
        case .coupon:
            return "/member/user/bonus/queryUserBonus"
        case .orderInfoList:
            return "/order/order/ngetOrderInfoListV2"
        case .orderInfo:
            return "/order/order/getOrderDetail"
        case .orderScheme:
            return "/order/order/getTicketScheme"
        case .accountDetailsList:
            return "/member/user/account/getUserAccountList"
        case .messageList:
            return "/member/user/message/list"
        case .accountStatistics:
            return "/member/user/account/countMoneyCurrentMonth"
        case .withdrawProgressList:
            return "/payment/payment/withdraw/list"
        case .collectAdd:
            return "/member/user/collect/add"
        case .collectDelete:
            return "/member/user/collect/delete"
        case .collectList:
            return "/member/user/collect/list"
        case .configQuety:
            return "/member/switch/config/query"
        case .complain:
            return "/member/dl/complain/add"
        case .queryUserNotice:
            return "/member/user/queryUserNotice"
        case .updateUnReadNotic:
            return "/member/user/updateUnReadNotice"
        case .setLoginPass:
            return "/member/user/setLoginPass"
        case .accountDetailsListAndTotal:
            return "/member/user/account/getUserAccountListAndCountTotal"
        case .collectMatch:
            return "/member/user/matchCollect/collectMatchId"
        case .collectMatchCancle:
            return "/member/user/matchCollect/cancle"
        case.surprise:
            return "/lottery/dl/article/findList"
        case .copywriting:
            return "/member/appDoc/queryAppDocByType"
        }
    }
    
    
    var task: Task {
        
        
        var dic : [String: Any] = [:]
        //dic["header"] = DeviceManager.share.device
        
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
        case .couponList(let status, let pageNum):
            dic["status"] = status
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .coupon(let userBonusId):
            dic["userBonusId"] = userBonusId
        case .orderInfoList(let fyd, let orderStatus, let pageNum):
            dic["lotteryClassifyId"] = fyd
            dic["orderStatus"] = orderStatus
            dic["pageNum"] = pageNum
        case .orderInfo(let orderId):
            dic["orderId"] = orderId
        case .orderScheme(let programmeSn, let orderSn):
            dic["orderSn"] = orderSn
            dic["programmeSn"] = programmeSn
        case .accountDetailsList(let amountType, let pageNum, let timeType):
            dic["amountType"] = amountType
            dic["timeType"] = timeType
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .accountStatistics (let timeType):
            dic["timeType"] = timeType
        case .accountDetailsListAndTotal(let amountType, let pageNum, let timeType):
            dic["amountType"] = amountType
            dic["timeType"] = timeType
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .messageList(let msgType, let pageNum):
            dic["msgType"] = msgType
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .withdrawProgressList(let withdawSn):
            dic["withdrawSn"] = withdawSn
        case .collectAdd(let articledId):
            dic["articleId"] = articledId
//            dic["articleTitle"] = articleTitle
//            dic["collectFrom"] = collectFrom
        case .collectDelete(let collectId):
            dic["id"] = collectId
        case .collectList(let pageNum):
            dic["pageNum"] = pageNum
            dic["pageSize"] = "20"
        case .configQuety:
            dic["str"] = "ssss"
        case .complain(let content):
            dic["complainContent"] = content
        case .updateUnReadNotic(let type):
            dic["type"] = type
        case .queryUserNotice:
            dic["str"] = "d14fs54df4sf韩笑孟宪征"
        case .setLoginPass(let oldPass, let newPass, let type):
            dic["oldLoginPass"] = oldPass
            dic["userLoginPass"] = newPass
            dic["type"] = type
        case .collectMatch(let matchId, let dateStr ) :
            dic["matchId"] = matchId
            dic["dateStr"] = dateStr
        case .collectMatchCancle(let matchId, let dateStr ) :
            dic["matchId"] = matchId
            dic["dateStr"] = dateStr
        case.surprise(let page, let extendCat):
            dic["page"] = page
            dic["size"] = "20"
            dic["extendCat"] = extendCat
        case .copywriting(let type):
            dic["docClassify"] = type
            
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
