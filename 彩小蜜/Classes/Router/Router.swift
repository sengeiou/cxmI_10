//
//  Router.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UIKit

struct Router : RouterMatcher {
    func pushRouterVC(urlStr: String) {
        let type = matcherHttp(urlStr: urlStr)
        
        switch type {
        case .首页:
            break
        case .登录:
            break
        case .注册:
            break
        case .网页:
            let web = WebViewController()
            web.urlStr = urlStr
            pushViewController(web)
            break
        case .浏览器:
            if let url = URL(string: urlStr) {
                UIApplication.shared.openURL(url)
            }
        case .足球胜平负:
            
            break
        case .足球让球胜平负:
            break
        case .足球比分:
            break
        case .足球半全场:
            break
        case .足球总进球:
            break
        case .足球混合过关:
            break
        case .足球二选一:
            break
            
        default:
            break
        }
    }
    
    private func pushViewController(_ vc: UIViewController) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
             rootVC.navigationController?.pushViewController(vc, animated: true )
        }
    }
    
    
    func getCurrentVC()->UIViewController{
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.shared.windows
            for  tempwin in windows{
                if tempwin.windowLevel == UIWindowLevelNormal{
                    window = tempwin
                    break
                }
            }
        }
        let frontView = (window?.subviews)![0]
        let nextResponder = frontView.next
        
        if nextResponder?.isKind(of: UIViewController.classForCoder()) == true{
            
            return nextResponder as! UIViewController
        }else if nextResponder?.isKind(of: UINavigationController.classForCoder()) == true{
            
            return (nextResponder as! UINavigationController).visibleViewController!
        }
        else {
            
            if (window?.rootViewController) is UINavigationController{
                return ((window?.rootViewController) as! UINavigationController).visibleViewController!//只有这个是显示的controller 是可以的必须有nav才行
            }else if (window?.rootViewController) is MainTabBarController{
                return ((window?.rootViewController) as! UITabBarController).selectedViewController! //不行只是最三个开始的页面
            }
            
            return (window?.rootViewController)!
            
        }
        
    }
    
}



