//
//  XCMMTrendViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouTrendVC:  WMPageController, AlertPro {

    private var titleDatas : [String] = ["开奖号码","红球走势","篮球走势","红球冷热","篮球冷热"]
    
    override func viewDidLoad() {
        
        setMenuView()
        
        super.viewDidLoad()

        self.title = "彩小秘 · 走势图"
        
        setRightItem()
        setLeftBarButton()
    }

}
// MARK: - Navigation
extension CXMMDaletouTrendVC {
    private func setRightItem() {
        let but = UIButton(type: .system)
        but.setImage(UIImage(named: "TrendSetting"), for: .normal)
        
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    }
    private func setLeftBarButton() {
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    @objc private func settingClick(_ sender : UIButton) {
        
    }
    @objc func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setMenuView() {
        self.menuViewStyle = .line
        self.titleColorNormal = Color505050
        self.titleColorSelected = ColorEA5504
        self.titleSizeNormal = 15
        self.titleSizeSelected = 15
        
        self.menuItemWidth = UIScreen.main.bounds.size.width / 5
        
        self.progressWidth = 60
        self.progressViewIsNaughty = true
    }
}

extension CXMMDaletouTrendVC {
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        
        return self.titleDatas.count
    }
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return self.titleDatas[index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        
        switch index {
        case 0:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DLTHistoryTrendVC") as! CXMMDLTHistoryTrendVC
            
            
            return vc
        case 1:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DLTRedTrendVC") as! CXMMDLTRedTrendVC
            
            
            return vc
        default:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "CXMMDaletouConfirmVC") as! CXMMDaletouConfirmVC
            
            
            return vc
        }
        
        
       
        
    }
    
    override func menuView(_ menu: WMMenuView!, didSelectedIndex index: Int, currentIndex: Int) {
        super.menuView(menu, didSelectedIndex: index, currentIndex: currentIndex)
        
        
    }
    
    override func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        //CXMGCDTimer.shared.cancleTimer(WithTimerName: "cxmTimer")
        guard let index = info["index"] as? Int else { return }
        
        
    }
    
    override func menuView(_ menu: WMMenuView!, initialMenuItem: WMMenuItem!, at index: Int) -> WMMenuItem! {
        
        if index != 0 {
            let view = UIView(frame: CGRect(x: -1, y: 7.5, width: 1, height: 32))
            view.backgroundColor = ColorC8C8C8
            
            initialMenuItem.addSubview(view)
            
        }
        
        return initialMenuItem
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        return CGRect(x: 0, y: SafeAreaTopHeight, width: Int(screenWidth), height: 50)
    }
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        return CGRect(x: 0, y: CGFloat( SafeAreaTopHeight + 50), width: UIScreen.main.bounds.size.width, height: screenHeight - CGFloat( SafeAreaTopHeight + 50) - 50 )
    }
}
