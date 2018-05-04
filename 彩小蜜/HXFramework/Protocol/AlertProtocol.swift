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
        HUD.flash(.label(message), delay: 1.0)
    }
    
    
    public func showConfirm( message: String, action: String, cancel: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(title: nil, message: message, action: action, cancel: cancel, in: vc, confirm: confirm)
        }
    }
    /// 带取消删除弹窗
    public func showDeleteAlert(message: String, action : String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, action: action, in: vc, confirm: confirm)
        }
    }
    
    public func showAlert(message: String, action : String, in viewController: UIViewController, confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default, handler: confirm)
        action.setValue(ColorEA5504, forKey:"titleTextColor")
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancel.setValue(Color505050, forKey: "titleTextColor")
        
        alert.addAction(action)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
    
    public func showConfirm(title: String, message: NSAttributedString, action: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(title: title, message: message, action: action, in: vc, confirm: confirm)
        }
    }
    
    //在指定视图控制器上弹出普通消息提示框
    public func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        viewController.present(alert, animated: true)
    }
    //在根视图控制器上弹出普通消息提示框
    public func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
    public func showConfirm(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    public func showConfirm(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc)
        }
    }
    
    //在指定视图控制器上弹出确认框
    public func showConfirm(message: String, action: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出确认框
    public func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, action: "确认", in: vc, confirm: confirm)
        }
    }
    
    public func showConfirm(message: String, action : String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, action: action, in: vc, confirm: confirm)
        }
    }
    public func showConfirm(title: String, message: NSAttributedString, action: String, in viewController: UIViewController, confirm: ((UIAlertAction)->Void)?) {
        
    
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.setValue(message, forKey: "attributedMessage")
        
        let action = UIAlertAction(title: action, style: .default, handler: confirm)
        action.setValue(Color505050, forKey:"titleTextColor")
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
    public func showAlert(title: String?, message: String, action: String, cancel: String, in viewController: UIViewController, confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default, handler: confirm)
        action.setValue(ColorEA5504, forKey:"titleTextColor")
        let cancel = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        cancel.setValue(Color505050, forKey: "titleTextColor")
        
        
        alert.addAction(cancel)
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
    /// 彩小秘  知道了
    public func showCXMCancelAlert(title: String?, message: String, action: String,confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            
            let attStr = NSAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor: Color787878])
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.setValue(attStr, forKey: "attributedMessage")
            let action = UIAlertAction(title: action, style: .default, handler: confirm)
            action.setValue(ColorEA5504, forKey:"titleTextColor")
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
    
    public func showCXMAlert(title: String?, message: String, action: String, cancel: String,confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            
            let attStr = NSAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor: Color787878])
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.setValue(attStr, forKey: "attributedMessage")
            
            let action = UIAlertAction(title: action, style: .default, handler: confirm)
            action.setValue(ColorEA5504, forKey:"titleTextColor")
            let cancel = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            cancel.setValue(Color505050, forKey: "titleTextColor")
            
            alert.addAction(cancel)
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
}
