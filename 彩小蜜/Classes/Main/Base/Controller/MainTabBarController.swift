//
//  MainTabBarController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.creatSubViewControllers()
    }

    
    private func creatSubViewControllers()
    {
        // 主页
        let home = HomeTableViewController()
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem.title = "大厅"
        homeNav.view.backgroundColor = UIColor.white
        
        // 开奖
        let lottery = LotteryViewController()
        
        let lotteryNav = UINavigationController(rootViewController: lottery)
        lotteryNav.tabBarItem.title = "开奖"
        lotteryNav.view.backgroundColor = UIColor.white
        
        // me
        let me = MeViewController()
        
        let meNav = UINavigationController(rootViewController: me)
        meNav.tabBarItem.title = "我的"
        meNav.view.backgroundColor = UIColor.white
        
        
        self.viewControllers = [homeNav, lotteryNav, meNav]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
