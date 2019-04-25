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
    
    private var home : CXMHomeViewController!
    public var me : BaseViewController!
    private var lottery : CXMScoreViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = ColorFFFFFF
        self.tabBar.backgroundColor = ColorFFFFFF
        self.tabBar.barTintColor = ColorFFFFFF
        
        self.tabBar.shadowImage = UIImage(named : "line1")
        self.tabBar.backgroundImage = UIImage()
        self.delegate = self

        setupChildControllers()
        
        guard getUserData() != nil else {
            getAppConfigRequest()
            return
            
        }
        
        if let reachability = Reachability() {
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
            reachability.whenReachable = { reachability in
                self.getAppConfigRequest()
            }
            reachability.whenUnreachable = { _ in
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - 网络请求
    func getAppConfigRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": data.turnOn])
                UserDefaults.standard.set(data.turnOn, forKey: TurnOn)
                UserDefaults.standard.synchronize()

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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": true])
                }else {
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /*
        if viewController == self.viewControllers![3] {
            if getUserData() == nil {
                me = CXMVCodeLoginViewController()
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
         */
        
//        if viewController == self.viewControllers![1] {
//            lottery.backDefault = tr
//        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension MainTabBarController {
    private func setupChildControllers() {
        
        let surpriseStory = UIStoryboard(name: "Surprise", bundle: nil)
        
        let surprise = surpriseStory.instantiateViewController(withIdentifier: "ServiceHome") as! ServiceHome
        let shopStory = UIStoryboard(storyboard: .Shop)
        let shopHome = shopStory.instantiateViewController(withIdentifier: "ShopHomeViewController") as! ShopHomeViewController
        
//        let vcArray: [UIViewController] = [CXMHomeViewController(),CXMScoreViewController(),surprise, shopHome, CXMMeViewController()]
//        let titleArray = [("首页","tab_home"),("开奖","tab_lot"),("发现","tab_fw"),("商城","tab_shch"),("我的","tab_min")]
        
        let vcArray: [UIViewController] = [CXMHomeViewController(),CXMScoreViewController(),surprise, CXMMeViewController()]
        let titleArray = [("首页","tab_dt"),("开奖","tab_bs"),("发现","tab_fx"),("我的","tab_wd")]
    
        
        for (index, vc) in vcArray.enumerated() {
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            vc.tabBarItem.image = UIImage(named: titleArray[index].1 + "_nor")?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named: titleArray[index].1 + "_sel")?.withRenderingMode(.alwaysOriginal)
            
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.barTintColor = ColorD12120
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font17, NSAttributedString.Key.foregroundColor: UIColor.white]
            addChild(nav)
        }
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
