//
//  TongJiProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

enum TongJi : String {
    static func log(_ eventId : TongJi, label: String? = "") {
        BaiduMobStat.default().logEvent(eventId.rawValue, eventLabel: label)
    }
    
    static func log(_ eventId : TongJi, label: String! = "",att: TongJiFenLei) {
        BaiduMobStat.default().logEvent(eventId.rawValue, eventLabel: label, attributes: [att.rawValue: label])
    }
    
    static func start(_ name: String) {
        BaiduMobStat.default().pageviewStart(withName: name)
    }
    static func end(_ name: String) {
        BaiduMobStat.default().pageviewEnd(withName: name)
    }
    
    case show = "show"
    case banner = "banner"
    case 足彩彩种 = "caizhongzc"
    case 场次返回 = "changcifanhuizc"
    case 赛事筛选 = "shaixuansszc"
    case 比赛筛选 = "sszhongleizc"
    case 帮助    = "saishibangzhuzc"
    case 场次确认 = "changciqdzc"
    case 串关 = "chuanguanzc"
    case 串关种类 = "cgzhongleizc"
    case 倍数 = "beishuzc"
    case 倍数确定 = "bsqdzc"
    case 倍数选择 = "bsxuanzezc"
    case 投注返回 = "touzhufanhuizc"
    case 投注确认 = "touzhuqdzc"
    case 余额抵扣 = "yuedikouzc"
    case 优惠券抵扣 = "youhuiquanzc"
    case 微信支付 = "wxzhifuzc"
    case 确认支付 = "querenzhifuzc"
    case 支付返回  = "zhifufanhuizc"
    case 登录返回  = "dlfanhui"
    case 登录输手机号  = "dlshushouji"
    case 登录输密码  = "dlshumima"
    case 登录  = "denglu"
    case 新用户注册  = "xinzhuce"
    case 注册页返回  = "zcfanhui"
    case 注册输手机号  = "zcshushouji"
    case 注册输密码  = "zcshumima"
    case 注册获取验证码  = "zchuoquyzm"
    case 注册输入验证码  = "zcshuruyzm"
    case 注册用户协议 = "zcyonghuxueyi"
    case 注册  = "zhuce"
    case 短信验证码登录 = "yanzhengmadl"
    case 验证码登录返回  = "yzmdlfanhui"
    case 验证码登录输手机号 = "yzmdlshushoujihao"
    case 验证码登录获取验证码 = "yzmdlhuoquyzm"
    case 验证码登录输入验证码 = "yzmdlshuruyzm"
    case 验证码登录页登录 = "yzmdldenglu"
    case 忘记密码 = "wangjimima"
    case 忘记密码页返回  = "wjmmfanhui"
    case 忘记密码输入手机号 = "wjmmshushouji"
    case 忘记密码下一步 = "wjmmxiayibu"
    case 忘记密码获取验证码 = "wjmmhuoquyzm"
    case 忘记密码输入验证码 = "wjmmshuruyzm"
    case 忘记密码确定 = "wjmmqueding"
    case 实名认证 = "shimingrenzheng"
    case 实名认证输入姓名 = "smrzshuxingming"
    case 实名认证输入身份证 = "smrzshushenfenzheng"
    case 实名认证认证 = "smrzrenzheng"
    case 充值  = "chongzhi"
    case 充值输入金额 = "czshurujine"
    case 充值固定金额 = "czgudingjine"
    case 充值支付 = "czzhifu"
    case 提现  = "tixian"
    case 输入提现金额 = "txshurujine"
    case 提现提交 = "txtijiao"
    case 添加银行卡 = "tianjiayinhangka"
    case 输入银行卡 = "shuruyhk"
    case 银行卡添加 = "yhktianjia"
    case 投注记录 = "touzhujilu"
    case 投注记录返回 = "tzjlfanhui"
    case 投注记录全部 = "tzjlquanbu"
    case 投注记录中奖 = "tzjlzhongjiang"
    case 投注记录待开奖 = "tzjldaikaijiang"
    case 账户明细 = "zhanghumingxi"
    case 账户明细返回 = "zhmxfanhui"
    case 账户明细全部  = "zhmxquanbu"
    case 账户明细奖金 = "zhmxjiangjin"
    case 账户明细充值 = "zhmxchongzhi"
    case 账户明细购彩 = "zhmxgoucai"
    case 账户明细提现 = "zhmxtixian"
    case 账户明细红包 = "zhmxhongbao"
    case 我的卡券  = "wodekaquan"
    case 我的卡券返回 = "wdkqfanhui"
    case 我的卡券未使用 = "wdkqweishiyong"
    case 我的卡券已使用 = "wdkqyishiyong"
    case 我的卡券已过期 = "wdkqyiguoqi"
    case 消息中心 = "xiaoxizhongxin"
    case 消息中心返回 = "xxzxfanhui"
    case 消息中心通知 = "xxzxtongzhi"
    case 消息中心消息 = "xxzxxiaoxi"
    case 我的收藏 = "wodeshoucang"
    case 我的收藏返回 = "wdscfanhui"
    case 帮助中心 = "bangzhuzhongxin"
    case 帮助中心返回 = "bzzxfanhui"
    case 联系客服 = "lianxikefu"
    case 联系客服呼叫 = "lxkfhujiao"
    case 联系客服取消 = "lxkfquxiao"
    case 关于我们 = "guanyuwomen"
    case 关于我们返回 = "gywmfanhui"
    case 关于我们投诉建议 = "gywmtousu"
    case 投诉建议客服 = "tousukefu"
    case 投诉建议发送 = "tousufasong"
    case 投诉建议返回 = "tousufanhui"
    case 关于我们安全保障 = "gywmanquan"
    case 退出登录  = "tuichudenglu"
    
}

enum TongJiFenLei : String {
    case 彩种 = "彩种"
    case 赛事 = "赛事"
    case 串关 = "串关"
    case 倍数 = "倍数"
    case 终端 = "终端"
    case url = "url"
}
