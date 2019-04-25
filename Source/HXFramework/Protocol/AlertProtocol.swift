//
//  AlertProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

enum AlertStyle {
    case defaultd
    case confimOnly
    case cancelOnly
}

protocol AlertPro {
    
}
extension AlertPro {
    
    /// 无按钮提示
    public func showHUD(message: String) {
        HUD.flash(.label(message), delay: 2.0)
        
    }
    
    public func showCXMAlert(title: String?, message: NSAttributedString, action: String, cancel: String?,confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.setValue(message, forKey: "attributedMessage")
            
            
            let action = UIAlertAction(title: action, style: .default, handler: confirm)
            action.setValue(ColorEA5504, forKey:"titleTextColor")
            
            if cancel != nil {
                let cancelAct = UIAlertAction(title: cancel, style: .cancel, handler: nil)
                cancelAct.setValue(Color505050, forKey: "titleTextColor")
                alert.addAction(cancelAct)
            }
            
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
    
    public func showCXMAlert(title: String?, message: String, action: String, cancel: String?, on vc : UIViewController , confirm: ((UIAlertAction)->Void)?) {
        let attStr = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: Color787878])
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(attStr, forKey: "attributedMessage")
        
        let action = UIAlertAction(title: action, style: .default, handler: confirm)
        action.setValue(ColorEA5504, forKey:"titleTextColor")
        
        
        if cancel != nil {
            let cancelAct = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            cancelAct.setValue(Color505050, forKey: "titleTextColor")
            alert.addAction(cancelAct)
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    public func showCXMAlert(title: String?, message: String, action: String, cancel: String?,confirm: ((UIAlertAction)->Void)?, canceled : ((UIAlertAction)-> Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            
            let attStr = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: Color787878])
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.setValue(attStr, forKey: "attributedMessage")
            
            let action = UIAlertAction(title: action, style: .default, handler: confirm)
            action.setValue(ColorEA5504, forKey:"titleTextColor")
            
            if cancel != nil {
                let cancelAct = UIAlertAction(title: cancel, style: .cancel, handler: canceled)
                cancelAct.setValue(Color505050, forKey: "titleTextColor")
                alert.addAction(cancelAct)
            }
            
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
    public func showCXMAlert(title: String?, message: String, action: String, cancel: String?,confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            
            let attStr = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: Color787878])
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.setValue(attStr, forKey: "attributedMessage")
            
            let action = UIAlertAction(title: action, style: .default, handler: confirm)
            action.setValue(ColorEA5504, forKey:"titleTextColor")
        
            if cancel != nil {
                let cancelAct = UIAlertAction(title: cancel, style: .cancel, handler: nil)
                cancelAct.setValue(Color505050, forKey: "titleTextColor")
                alert.addAction(cancelAct)
            }
        
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
    
}
