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
    
}
