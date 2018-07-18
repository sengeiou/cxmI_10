//
//  MainTabBarController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import Reachability


let NotificationConfig = "NotificationConfigName"
let TurnOn = "TurnOn"

class MainTabBarController: UITabBarController, UserInfoPro, UITabBarControllerDelegate {

    //private var configInfo : ConfigInfoModel!
    
    private var home : HomeViewController!
    public var me : BaseViewController!
    private var lottery : ScoreViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = ColorFFFFFF
        self.tabBar.backgroundColor = ColorFFFFFF
        self.tabBar.barTintColor = ColorFFFFFF
        
        self.tabBar.shadowImage = UIImage(named : "line1")
        self.tabBar.backgroundImage = UIImage()
        self.delegate = self
        creatSubViewControllers()
        
        guard getUserData() != nil else {
            configRequest()
            return }
        
        if let reachability = Reachability() {
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
            reachability.whenReachable = { reachability in
                self.configRequest()
            }
            reachability.whenUnreachable = { _ in
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - 网络请求
    
    func configRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in
//                if data.turnOn {
//                    weakSelf?.home.homeStyle = .allShow
//                }else {
//                    weakSelf?.home.homeStyle = .onlyNews
//                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": data.turnOn])
                UserDefaults.standard.set(data.turnOn, forKey: TurnOn)
                
                print("开关\(data.turnOn)")
                
                self.queryUserNotice(data.turnOn)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult: break
                    
                    //self.showHUD(message: msg!)
                default: break
                }
                
                let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
                
                if turnOn  {
                    weakSelf?.home.homeStyle = .allShow
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": true])
                }else {
                    weakSelf?.home.homeStyle = .onlyNews
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": false])
                }
                
                
            }, onCompleted: nil, onDisposed: nil )
    }
    
    // 获取用户 卡券或消息提示
    public func queryUserNotice(_ turnOn : Bool) {
        _ = userProvider.rx.request(.queryUserNotice)
            .asObservable()
            .mapObject(type: QueryUserNoticeDataModel.self)
            .subscribe(onNext: { (data) in
                UserDefaults.standard.set(data.bonusNotice, forKey: BonusNotice)
                UserDefaults.standard.set(data.messageNotice, forKey: MessageNotice)
                if turnOn {
                    if data.bonusNotice != "0" || data.messageNotice != "0" {
                        self.tabBar.showBadgeOnItemIndex(index: 3)
                    }else {
                        self.tabBar.hideBadgeOnItemIndex(index: 3)
                    }
                }else {
                    self.tabBar.hideBadgeOnItemIndex(index: 3)
                }
                
            }, onError: { (error) in
                
            }, onCompleted: nil , onDisposed: nil )
    }
    
    
    public func creatSubViewControllers()
    {
        // 主页
        home = HomeViewController()
    
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        homeNav.title = ""
    
        homeNav.view.backgroundColor = UIColor.white
        
        let homeImage = UIImage(named: "tab_home_nor")?.withRenderingMode(.alwaysOriginal)
        let homeSelectImage = UIImage(named: "tab_home_sel")?.withRenderingMode(.alwaysOriginal)
        
        homeNav.tabBarItem.image = homeImage
        homeNav.tabBarItem.selectedImage = homeSelectImage
        homeNav.tabBarItem.title = ""
        
        
        // 开奖
        
        lottery = ScoreViewController()
        
        let lotteryNav = UINavigationController(rootViewController: lottery)
        lotteryNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        lotteryNav.view.backgroundColor = UIColor.white
        
        let loImg = UIImage(named: "tab_lot_nor")?.withRenderingMode(.alwaysOriginal)
        let loSelImg = UIImage(named: "tab_lot_sel")?.withRenderingMode(.alwaysOriginal)
        
        lotteryNav.tabBarItem.image = loImg
        lotteryNav.tabBarItem.selectedImage = loSelImg
        
        // 发现
        let surprise = SurpriseViewController()
        surprise.urlStr = SurpriseUrl
        let surpriseNav = UINavigationController(rootViewController: surprise)
        surpriseNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        surpriseNav.view.backgroundColor = UIColor.white
        
        let surpriseImg = UIImage(named: "tab_dis_nor")?.withRenderingMode(.alwaysOriginal)
        let surpriseSelImg = UIImage(named: "tab_dis_sel")?.withRenderingMode(.alwaysOriginal)
        
        surpriseNav.tabBarItem.image = surpriseImg
        surpriseNav.tabBarItem.selectedImage = surpriseSelImg
        
        // me
        //me : BaseViewController!
        
        let meNav = creatMeVC()
        
        
        self.viewControllers = [homeNav, lotteryNav, surpriseNav, meNav]
        
    }
    
    public func creatMeVC () -> UINavigationController{

        me = MeViewController()
        
        let meNav = UINavigationController(rootViewController: me)
        meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        meNav.view.backgroundColor = UIColor.white
        
        let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
        let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
        
        meNav.tabBarItem.image = meImg
        meNav.tabBarItem.selectedImage = meSelImg
        
        return meNav
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers![3] {
            if getUserData() == nil {
                me = VCodeLoginViewController()
                //me.popRoot = true
                let meNav = UINavigationController(rootViewController: me)
                meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                meNav.view.backgroundColor = UIColor.white
                
                let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
                let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
                
                meNav.tabBarItem.image = meImg
                meNav.tabBarItem.selectedImage = meSelImg
                
                self.present(meNav, animated: true, completion: nil)
                return false
            }
        }
        
        if viewController == self.viewControllers![1] {
            lottery.backDefault = true
        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension UITabBar {
    /**
     添加小红点
     
     - parameter index: index
     */
    func showBadgeOnItemIndex(index : Int){
        // 移除之前的小红点
        removeBadgeOnItemIndex(index: index)
        // 新建小红点
        let badgeView = UIView()
        badgeView.tag = 888 + index
        badgeView.layer.cornerRadius = 3.5
        badgeView.backgroundColor = UIColor.red
        let tabFrame = self.frame
        // 确定小红点的位置
        let percentX = (Double(index) + 0.6) / 4
        let x = ceilf(Float(percentX) * Float(tabFrame.size.width))
        let y = ceilf(0.1 * Float(tabFrame.size.height))
        
        badgeView.frame = CGRect(x: CGFloat(x) , y: CGFloat(y), width: 7, height: 7)
        self.addSubview(badgeView)
    }
    
    func hideBadgeOnItemIndex(index : Int){
        // 移除小红点
        removeBadgeOnItemIndex(index: index)
    }
    func removeBadgeOnItemIndex(index : Int){
        // 按照tag值进行移除
        for itemView in self.subviews {
            if(itemView.tag == 888 + index){
                itemView.removeFromSuperview()
            }
        }
    }
}
