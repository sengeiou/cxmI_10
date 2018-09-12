//
//  Router.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import UIKit

protocol RouterPro : RouterMatcher, AlertPro { }

extension RouterPro {
    /// 路由跳转
    func pushRouterVC(_ name: String = "", urlStr: String, from vc : UIViewController) {
        //let urlStr = "http://192.168.31.205:8080/activity/rechangeActivity?cxmxc=scm&showtitle=1&type=1&usinfo=2"
        //"http://39.106.18.39:9805/activity/tuiguang?cxmxc=scm&type=1&usinfo=1&showtitle=1&cfrom=app"
        
        let type = matcherHttp(urlStr: urlStr)
        
        switch type.0 {
        case .首页:
            break
        case .登录:
            break
        case .注册:
            break
        case .网页:
            pushWebview(name, urlStr: urlStr, from: vc)
        case .浏览器:
            if let url = URL(string: urlStr) {
                UIApplication.shared.openURL(url)
            }
        case .竞彩足球:
            pushFootballVC(from: vc)
        case .大乐透:
            pushDaletou(from: vc)
        case .竞彩篮球:
            pushLotto(urlStr: urlStr, from: vc)
//            pushBasketball(from: vc)
        case .快3:
            pushLotto(urlStr: urlStr, from: vc)
//            pushKuai3(from: vc)
        case .双色球:
            pushLotto(urlStr: urlStr, from: vc)
//            pushShuangSeQiu(from: vc)
        case .北京单场:
            pushLotto(urlStr: urlStr, from: vc)
//            pushBeijing(from: vc)
        case .广东11选5:
            pushLotto(urlStr: urlStr, from: vc)
//            pushGuangdong(from: vc)
        case .更多彩种:
            pushLotto(urlStr: urlStr, from: vc)
//            pushMore(from: vc)
        case .咨询详情:
            guard let id = type.1?.id else { return }
            pushNewsDetail( articleId: id, from: vc )
        case .球队详情:
            guard let id = type.1?.id else { return }
            pushMatchInfo(matchId: id, from: vc)
        case .开奖结果:
            pushPrize(from: vc )
        case .专家广场:
            pushExpert(from: vc)
        case .彩票学堂:
            pushLottoSchool(from: vc )
        case .活动中心:
            pushActivityCenter(from: vc )
        case .资讯信息:
            pushInformation(from: vc )
        case .晒单公园:
            pushShaidan(from: vc)
        case .实时统计:
            pushStatistics(from: vc )
        case .发现更多:
            pushSurpriseMore(from: vc)
            
        default:
            break
        }
    }
    
    private func pushLotto(urlStr: String, from vc : UIViewController ) {
        let web = CXMActivityViewController()
        web.urlStr = urlStr
        pushViewController(web, from: vc)
    }
    
    private func pushNewsDetail(articleId: String, from vc : UIViewController) {
        let detail = CXMNewsDetailViewController()
        detail.articleId = articleId
        pushViewController(detail, from: vc)
    }
    
    private func pushMatchInfo(matchId: String, from vc : UIViewController) {
        let match = CXMFootballMatchInfoVC()
        match.matchId = matchId
        pushViewController(match, from: vc)
    }
    
    private func pushFootballVC(from vc : UIViewController) {
        let football = CXMFootballMatchVC()
        
//        switch playType {
//        case "1":
//            football.matchType = .让球胜平负
//        case "2":
//            football.matchType = .胜平负
//        case "3":
//            football.matchType = .比分
//        case "4":
//            football.matchType = .总进球
//        case "5":
//            football.matchType = .半全场
//        case "6":
//            football.matchType = .混合过关
//        case "7":
//            football.matchType = .二选一
//        default:
//            break
//        }

        pushViewController(football, from: vc)
    }
    private func pushDaletou(from vc : UIViewController) {
        let stor = UIStoryboard(name: "Daletou", bundle: nil)
        
        let dlt = stor.instantiateViewController(withIdentifier: "DaletouViewController") as! CXMMDaletouViewController
        
        pushViewController(dlt, from: vc)
    }
    private func pushBasketball(from vc : UIViewController) {
        showHUD(message: "敬请期待")
    }
    private func pushKuai3(from vc : UIViewController) {
        showHUD(message: "敬请期待")
    }
    private func pushShuangSeQiu(from vc : UIViewController) {
        showHUD(message: "敬请期待")
    }
    private func pushBeijing(from vc : UIViewController){
        showHUD(message: "敬请期待")
    }
    private func pushGuangdong(from vc : UIViewController) {
        showHUD(message: "敬请期待")
    }
    private func pushMore(from vc : UIViewController) {
        showHUD(message: "敬请期待")
    }
    
    /// 开奖结果
    private func pushPrize(from vc : UIViewController) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        let prize = story.instantiateViewController(withIdentifier: "PrizeListVC") as! CXMMPrizeListVC
        pushViewController(prize, from: vc)
    }
    /// 专家广场
    private func pushExpert(from vc : UIViewController) {
        
    }
    /// 彩票学堂
    private func pushLottoSchool(from vc : UIViewController) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        let school = story.instantiateViewController(withIdentifier: "LotterySchoolVC") as! CXMMLotterySchoolVC
        pushViewController(school, from: vc)
    }
    /// 活动中心
    private func pushActivityCenter(from vc : UIViewController) {
        pushPagerView(pagerType: .activityCenter, from: vc)
    }
    /// 资讯信息
    private func pushInformation(from vc : UIViewController) {
        pushWebview(urlStr: getCurentBaseWebUrl() + SurpriseUrl, from: vc)
    }
    /// 晒单公园
    private func pushShaidan(from vc : UIViewController) {
        
    }
    /// 实时统计
    private func pushStatistics(from vc : UIViewController) {
        pushPagerView(pagerType: .leagueMatch, from: vc)
    }
    /// 发现更多
    private func pushSurpriseMore(from vc : UIViewController) {
        
    }
    
    
    private func pushViewController(_ vc: UIViewController, from formvc: UIViewController) {
        formvc.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func pushPagerView(pagerType: PagerViewType, from formvc: UIViewController) {
        let storyboard = UIStoryboard(name: "Storyboard", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "BasePagerViewController") as! BasePagerViewController
        vc.pagerType = pagerType
        
        formvc.navigationController?.pushViewController(vc, animated: true)
    }
    private func pushWebview(_ name : String = "", urlStr : String, from vc: UIViewController) {
        let web = CXMActivityViewController()
        web.webName = name
        if urlStr.contains("?") {
            web.urlStr = urlStr + "&cfrom=app"
        }else {
            web.urlStr = urlStr + "?cfrom=app"
        }
        
        //web.urlStr = "http://192.168.31.205:8080/activity/discount?cxmxc=scm&usinfo=1&cmshare=1&from=app&showtitle=1"
        //web.urlStr = "http://192.168.31.232:8080/activity/tuiguang?cxmxc=scm&type=1&usinfo=1&showtitle=1"
        pushViewController(web, from: vc)
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
        let football = CXMFootballMatchVC()
        
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




