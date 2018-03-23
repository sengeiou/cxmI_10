//
//  MyCouponViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyCouponViewController: ButtonBarPagerTabStripViewController {


    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = ColorFFFFFF
        settings.style.buttonBarItemBackgroundColor = ColorFFFFFF
        settings.style.selectedBarBackgroundColor = ColorE95504
        settings.style.buttonBarItemTitleColor = Color505050

        settings.style.selectedBarHeight = 1
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumInteritemSpacing = 1
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemFont = Font15
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Color505050
            newCell?.label.textColor = ColorE95504
        }

        super.viewDidLoad()
        self.title = "彩小秘 · 账户明细"
        setLiftButtonItem()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let notUsed = CouponViewController()
        notUsed.couponType = .unUsed
        let used = CouponViewController()
        used.couponType = .used
        let overdue = CouponViewController()
        overdue.couponType = .overdue
        return [notUsed, used, overdue]
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
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }




}

