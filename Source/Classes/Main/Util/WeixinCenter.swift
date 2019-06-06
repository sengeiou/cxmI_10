//
//  WeixinCenter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol WeixinShareDelegate {
    func onShardWeixin(response: SendMessageToWXResp) -> Void
    func pushOrderDetail() -> Void
}
protocol WeixinPayDelegate {
    func onPaybuyWeixin(response: PayResp) -> Void
}

class WeixinCenter : NSObject, WXApiDelegate{
    
    
    static let share = WeixinCenter()
    
    public var shareDelegate : WeixinShareDelegate!
    public var payDelegate : WeixinPayDelegate!
    public var pushOrderDetail : Bool!
    
    override init() {
        
        super.init()
    }
    
    public func weixinHandle(url: URL) {
        WXApi.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: SendMessageToWXResp.self) {
            guard shareDelegate != nil else { return }
            shareDelegate.onShardWeixin(response: resp as! SendMessageToWXResp)
            if pushOrderDetail == true{
                pushOrderDetail = false
                shareDelegate.pushOrderDetail()
            }
        }else if resp.isKind(of: PayResp.self) {
            guard payDelegate != nil else { return }
            payDelegate.onPaybuyWeixin(response: resp as! PayResp)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
