//
//  ShareProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/24.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol ShareProtocol {
    
}

extension ShareProtocol {
    func share(_ content : ShareContentModel, from vc : BaseViewController) {
        var contentModel = content
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        var turn = "0"
        
        if turnOn {
            turn  = "1"
        }
        
        contentModel.urlStr = content.urlStr + "&frz=\(turn)"
        
        let share = ShareViewController()
        share.shareContent = contentModel
        vc.present(share)
    }
}
