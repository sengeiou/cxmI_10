//
//  Router.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UIKit

protocol RouterPro : RouterMatcher { }

extension RouterPro {
    /// 路由跳转
    func pushRouterVC(urlStr: String, from vc : UIViewController) {
        let type = matcherHttp(urlStr: urlStr)
        
        switch type.0 {
        case .首页:
            break
        case .登录:
            break
        case .注册:
            break
        case .网页:
            let web = ActivityViewController()
            //web.urlStr = urlStr
            web.urlStr = "http://m.caixiaomi.net/#/user/activity/one?cxmxc=scm&type=1"
            pushViewController(web, from: vc)
            break
        case .浏览器:
            if let url = URL(string: urlStr) {
                UIApplication.shared.openURL(url)
            }
        case .足球胜平负:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球让球胜平负:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球比分:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球半全场:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球总进球:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球混合过关:
            pushFootballVC(type.0.rawValue, from: vc)
        case .足球二选一:
            pushFootballVC(type.0.rawValue, from: vc)
        case .咨询详情:
            guard let id = type.1?.id else { return }
            pushNewsDetail( articleId: id, from: vc )
        case .球队详情:
            guard let id = type.1?.id else { return }
            pushMatchInfo(matchId: id, from: vc)
        default:
            break
        }
    }
    
    private func pushNewsDetail(articleId: String, from vc : UIViewController) {
        let detail = NewsDetailViewController()
        detail.articleId = articleId
        pushViewController(detail, from: vc)
    }
    
    private func pushMatchInfo(matchId: String, from vc : UIViewController) {
        let match = FootballMatchInfoVC()
        match.matchId = matchId
        pushViewController(match, from: vc)
    }
    
    private func pushFootballVC(_ playType: String, from vc : UIViewController) {
        let football = FootballMatchVC()
        
        switch playType {
        case "1":
            football.matchType = .让球胜平负
        case "2":
            football.matchType = .胜平负
        case "3":
            football.matchType = .比分
        case "4":
            football.matchType = .总进球
        case "5":
            football.matchType = .半全场
        case "6":
            football.matchType = .混合过关
        case "7":
            football.matchType = .二选一
        default:
            break
        }
    
        TongJi.log(.足彩彩种, label: football.matchType.rawValue, att: .彩种)
        pushViewController(football, from: vc)
    }
    
    private func pushViewController(_ vc: UIViewController, from formvc: UIViewController) {
        formvc.navigationController?.pushViewController(vc, animated: true)
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



struct Router : RouterMatcher {
    
   
    
//    func pushRouterVC(urlStr: String) {
//        let type = matcherHttp(urlStr: urlStr)
//
//        switch type {
//        case .首页:
//            break
//        case .登录:
//            break
//        case .注册:
//            break
//        case .网页:
//            let web = WebViewController()
//            web.urlStr = urlStr
//            pushViewController(web)
//            break
//        case .浏览器:
//            if let url = URL(string: urlStr) {
//                UIApplication.shared.openURL(url)
//            }
//        case .足球胜平负:
//            pushFootballVC(type.rawValue)
//        case .足球让球胜平负:
//            pushFootballVC(type.rawValue)
//        case .足球比分:
//            pushFootballVC(type.rawValue)
//        case .足球半全场:
//            pushFootballVC(type.rawValue)
//        case .足球总进球:
//            pushFootballVC(type.rawValue)
//        case .足球混合过关:
//            pushFootballVC(type.rawValue)
//        case .足球二选一:
//            pushFootballVC(type.rawValue)
//
//        default:
//            break
//        }
//    }
    
    private func pushViewController(_ vc: UIViewController) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
             rootVC.navigationController?.pushViewController(vc, animated: true )
        }
    }
    
    private func pushFootballVC(_ playType: String) {
        let football = FootballMatchVC()
        
        switch playType {
        case "1":
            football.matchType = .让球胜平负
        case "2":
            football.matchType = .胜平负
        case "3":
            football.matchType = .比分
        case "4":
            football.matchType = .总进球
        case "5":
            football.matchType = .半全场
        case "6":
            football.matchType = .混合过关
        case "7":
            football.matchType = .二选一
        default:
            break
        }
        pushViewController(football)
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




