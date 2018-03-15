//
//  BaseViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SnapKit


public var currentVC : UIViewController?

class BaseViewController: UIViewController, AlertPro {

    // public
    public func pushLoginVC(from vc: UIViewController) {
        let login = LoginViewController()
        currentVC = vc
        self.navigationController?.pushViewController(login, animated: true)
    }
    public func popToCurrentVC() {
        for vc in (self.navigationController?.viewControllers)! {
            if currentVC != nil, vc == currentVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    public func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func pushRootViewController() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = MainTabBarController()
    }
    
    public func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    public func popToLoginViewController() {
        for vc in (self.navigationController?.viewControllers)! {
            if vc .isKind(of: LoginViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    
    public func hideBackBut() {
        self.navigationItem.leftBarButtonItem = nil
    }
    public func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: -
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        setNavigation()
    }

    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        setLiftButtonItem()
        
    }
    
    
    private func setLiftButtonItem() {
        
        let leftBut = UIButton(type: .custom)
        leftBut.setTitle("返回", for: .normal)
        
        leftBut.titleLabel?.font = Font15
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        leftBut.setTitleColor(UIColor.black, for: .normal)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc private func back(_ sender: UIButton) {
        popViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
