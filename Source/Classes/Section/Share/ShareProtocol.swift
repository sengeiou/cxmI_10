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
        
        if contentModel.urlStr != "" {
            contentModel.urlStr = content.urlStr + "&frz=\(0)" + "&qd=\(Channel)"
        }
        
        if contentModel.sharePicUrl == nil ||
            contentModel.sharePicUrl == "" {
            if contentModel.sharePic == nil {
                contentModel.sharePic = UIImage(named: "fenxiangtubiao")
            }
            
            if vc.classForCoder == CXMRechargeViewController.self{
                let share = CXMShareViewController()
                share.contact = true
                share.shareContent = contentModel
                vc.present(share)
            }else{
                let share = CXMShareViewController()
                share.contact = false
                share.shareContent = contentModel
                vc.present(share)
            }

        }else {
            if let url = URL(string: contentModel.sharePicUrl) {
                UIImageView().kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil , completionHandler: { (image, error, type , url) in
                    guard image != nil else { return }
                    DispatchQueue.main.async {
                        contentModel.sharePic = image
                        let share = CXMShareViewController()
                        share.shareContent = contentModel
                        vc.present(share)
                    }
                })
            }
        }
    }
}
