//
//  Servier.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/5.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation

protocol Service {
    
}

extension Service where Self : UIViewController {
    func initZhiChiService(msg : String = "") {
        let initInfo = ZCLibInitInfo()
        
        initInfo.appKey = ZhiChiAppKey
        initInfo.userId = ""
        
        let uiInfo = ZCKitInfo()

        uiInfo.isShowTansfer = true
        
        uiInfo.customBannerColor = ColorD12120
        
        uiInfo.topViewTextColor = UIColor.white
        
        uiInfo.titleFont = Font15
        
        uiInfo.satisfactionSelectedBgColor = ColorEA5504
        
        uiInfo.commentOtherButtonBgColor = ColorEA5504
        
        uiInfo.commentCommitButtonColor = ColorEA5504
        
        uiInfo.commentCommitButtonBgColor = ColorEA5504
        
        uiInfo.commentCommitButtonBgHighColor = ColorD12120
        
        ZCLibClient.getZCLibClient().libInitInfo = initInfo
        
        ZCSobot.startZCChatVC(uiInfo, with: self, target: nil, pageBlock: { (chatVC, type) in
            
        }, messageLinkClick: nil)
    }
}

