//
//  AppDelegateProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UserNotifications
import PushKit

protocol AppDelegateProtocol {
    
}

extension AppDelegateProtocol where Self : AppDelegate {
    
    /// 注册开放平台
    func registerApp() {
        // 注册微信开放平台
        WXApi.registerApp(WeixinAppID)
        
        // 启动个推
        GeTuiSdk.start(withAppId: GetuiAppID, appKey: GetuiAppKey, appSecret: GetuiSecrct, delegate: self)
        
        
        
        
        // 百度统计
        BaiduMobStat.default().start(withAppId: BaiduAppKey)
        BaiduMobStat.default().getTestDeviceId()
        BaiduMobStat.default().channelId = "c16010"
        
        // 智齿客服
        ZCLibClient.setZCLibUncaughtExceptionHandler() // 错误日志收集
        ZCLibClient.getZCLibClient().initSobotSDK(ZhiChiAppKey)
        
        // 注册APNS
        registerRemoteNotification()
    }
    
    func registerRemoteNotification() {
        /*
         警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
         */
        
        /*
         警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
         以下为演示代码，仅供参考，详细说明请参考苹果开发者文档，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken。
         */
        
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue;
        if systemVer >= 10.0 {
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self;
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        
                        print("注册通知成功") //点击允许
                        
                    } else {
                        print("注册通知失败") //点击不允许
                    }
                })
                
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                if #available(iOS 8.0, *) {
                    let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(userSettings)
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
            };
        }else {
            if #available(iOS 8.0, *) {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}
