//
//  SuspendedViewController.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/7/19.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class SuspendedViewController: BaseViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

      homeSuspendedView.delegate = self
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

}

extension SuspendedViewController :HomeSuspendedViewDelegate{
    func clickSuspendedBallBtn(urlStr: String) {
        let vc = UIViewController.currentViewController
        pushRouterVC(urlStr: urlStr, from: vc())
    }
}

extension UIViewController{
    class func currentViewController() -> UIViewController {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        return UIViewController.findBestViewController(vc: vc!)
    }
    class func findBestViewController(vc : UIViewController) -> UIViewController {
        
        if vc.presentedViewController != nil {
            return UIViewController.findBestViewController(vc: vc.presentedViewController!)
        } else if vc.isKind(of:UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBestViewController(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let nvc = vc as! UINavigationController
            if nvc.viewControllers.count > 0 {
                return UIViewController.findBestViewController(vc: nvc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let tvc = vc as! UITabBarController
            if (tvc.viewControllers?.count)! > 0 {
                return UIViewController.findBestViewController(vc: tvc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
}
