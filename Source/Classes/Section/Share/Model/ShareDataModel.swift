//
//  ShareDataModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON


enum ShareCode {
    /// QQ
    case ShareQQ
    /// 短信
    case Share_SMS
    /// 复制连接
    case ShareLink
    /// QQ空间
    case ShareQzone
    /// 微信好友
    case ShareWeixin
    /// 二维码
    case ShareQRCode
    /// 新浪微博
    case ShaerSinaWeibo
    /// 微信朋友圈
    case ShareWeixinCircle
}

class ShareDataManager {
    static let share : ShareDataManager = ShareDataManager()
    
    func getShardList() -> [ShareDataModel] {
        var shareList = [ShareDataModel]()
        
        var share = ShareDataModel()
        share.title = "朋友圈"
        share.iconPic = "朋友圈"
        share.shareCode = .ShareWeixinCircle
        var weixin = ShareDataModel()
        weixin.title = "微信"
        weixin.iconPic = "微信"
        weixin.shareCode = .ShareWeixin
        var copy = ShareDataModel()
        copy.title = "复制链接"
        copy.iconPic = "复制"
        copy.shareCode = .ShareLink
        
        if WXApi.isWXAppInstalled(){
            shareList.append(share)
            shareList.append(weixin)
        }
        
        
        shareList.append(copy)
        
        return shareList
    }
}

struct ShareDataModel {
    var title : String!
    var iconPic : String!
    var shareCode: ShareCode!
}

struct ShareContentModel {
    /// 标题
    var title : String! = ""
    /// 链接
    var urlStr: String!
    /// 图片
    var sharePic: UIImage!
    var sharePicUrl: String!
    var sharePicData: Data!
    /// 描述
    var description: String! = ""
}
