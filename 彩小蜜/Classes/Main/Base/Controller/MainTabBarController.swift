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
        let home = HomeViewController()
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        homeNav.title = ""
        
        homeNav.view.backgroundColor = UIColor.white
        
        let homeImage = UIImage(named: "tab_home_nor")?.withRenderingMode(.alwaysOriginal)
        let homeSelectImage = UIImage(named: "tab_home_sel")?.withRenderingMode(.alwaysOriginal)
        
        homeNav.tabBarItem.image = homeImage
        homeNav.tabBarItem.selectedImage = homeSelectImage
        homeNav.tabBarItem.title = ""
        
        
        // 开奖
        let lottery = LotteryViewController()
        
        let lotteryNav = UINavigationController(rootViewController: lottery)
        lotteryNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        lotteryNav.view.backgroundColor = UIColor.white
        
        let loImg = UIImage(named: "tab_lot_nor")?.withRenderingMode(.alwaysOriginal)
        let loSelImg = UIImage(named: "tab_lot_sel")?.withRenderingMode(.alwaysOriginal)
        
        lotteryNav.tabBarItem.image = loImg
        lotteryNav.tabBarItem.selectedImage = loSelImg
        
        // me
        let me = MeViewController()
        
        let meNav = UINavigationController(rootViewController: me)
        meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        meNav.view.backgroundColor = UIColor.white
        
        let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
        let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
        
        meNav.tabBarItem.image = meImg
        meNav.tabBarItem.selectedImage = meSelImg
        
        
        self.viewControllers = [homeNav, lotteryNav, meNav]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
