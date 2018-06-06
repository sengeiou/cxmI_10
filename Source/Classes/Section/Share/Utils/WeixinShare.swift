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
    
    func shareImage(content: ShareContentModel, scene : WXScene) {
        guard content.sharePic != nil else { return }
        if scene == WXSceneSession {
            share(title: content.title, description: content.description, image: content.sharePic, url: content.urlStr, scene: scene)
        }else if scene == WXSceneTimeline {
            share(title: content.title, description: "", image: content.sharePic, url: content.urlStr, scene: scene)
        }
    }
    
    func shareVideo(content: ShareContentModel, scene: WXScene) {
        guard content.sharePic != nil else { return }
        guard let data = UIImagePNGRepresentation(content.sharePic) else { return }
        if scene == WXSceneSession {
            share(title: content.title, description: content.description, imageDate: data, videoUrl: content.urlStr, scene: scene)
        }else if scene == WXSceneTimeline {
            share(title: content.title, description: "", imageDate: data, videoUrl: content.urlStr, scene: scene)
        }
    }
    
    private func share(title: String, description: String, image: UIImage, url: String, scene: WXScene) {

        guard let data = image.compressImage(image: image, maxLength: 32) else { return }
        share(title: title, description: description, imageDate: data, url: url, scene: scene)
        
    }
    
    private func share(title: String, description: String, imageDate: Data, url: String, scene: WXScene) {
        WXApi.registerApp(WeixinAppID)
        let mediaObject = WXWebpageObject()
        mediaObject.webpageUrl = url
        
        let message = WXMediaMessage()
        message.title = title
        message.mediaObject = mediaObject
        message.thumbData = imageDate
        message.description = description
        let request = SendMessageToWXReq()
        request.scene = Int32(scene.rawValue)
        request.message = message
        WXApi.send(request)
    }
    
    private func share(title: String, description: String, imageDate: Data, videoUrl: String, scene: WXScene) {
        WXApi.registerApp(WeixinAppID)

        
        let videoObject = WXVideoObject()
        videoObject.videoUrl = videoUrl
        
        let message = WXMediaMessage()
        message.title = title
        message.mediaObject = videoObject
        message.thumbData = imageDate
        message.description = description
        let request = SendMessageToWXReq()
        request.scene = Int32(scene.rawValue)
        request.message = message
        
        WXApi.send(request)
    }
}







