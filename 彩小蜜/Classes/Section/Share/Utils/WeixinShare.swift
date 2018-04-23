//
//  WeixinShare.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


struct WeixinShare {
    static func share() {
        
    }
}
//+ (BOOL)shareTitle:(NSString *)title img:(NSData *)imageData url:(NSString *)url scene:(int)scene {
//    [WXApi registerApp:WX_APPID];
//    WXWebpageObject *mediaObject = [WXWebpageObject object];
//    mediaObject.webpageUrl = url;
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.mediaObject = mediaObject;
//    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
//    request.scene = scene;
//    request.message = message;
//    message.thumbData = imageData;
//
//    return [WXApi sendReq:request];
//}
protocol WeixinSharePro: WeixinShareDelegate {
    
}
extension WeixinSharePro {
    func share(title: String, url: String, scene: Int) {
        WXApi.registerApp(WeixinAppID)
        let mediaObject = WXWebpageObject()
        mediaObject.webpageUrl = url
        
        let message = WXMediaMessage()
        message.title = title
        message.mediaObject = mediaObject
        
        let request = SendMessageToWXReq()
        request.scene = Int32(scene)
        request.message = message
        
        WXApi.send(request)
    }
}







