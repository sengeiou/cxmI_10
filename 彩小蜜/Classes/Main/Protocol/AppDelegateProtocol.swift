//
//  AppDelegateProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol AppDelegateProtocol {
    
}

extension AppDelegateProtocol where Self : AppDelegate {
    
    /// 注册开放平台
    func registerApp() {
        // 注册微信开放平台
        WXApi.registerApp("xxxxx")
    }
}
