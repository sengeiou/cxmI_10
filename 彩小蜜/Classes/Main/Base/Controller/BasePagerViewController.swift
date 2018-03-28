//
//  BasePagerViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum PagerViewType: String {
    case coupon = "彩小秘 · 我的优惠券"
    case purchaseRecord = "彩小秘 · 购彩记录"
    case message = "彩小秘 · 消息中心"
    case accountDetails = "彩小秘 · 账户明细"
}

class BasePagerViewController: ButtonBarPagerTabStripViewController {
    
    var pagerType: PagerViewType!
    
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
        self.title = self.pagerType.rawValue
        setLiftButtonItem()
        
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return getViewController()
    }
    
    func getViewController() -> [UIViewController] {
        
        switch pagerType {
        case .coupon:
            return getCouponViewController()
        case .purchaseRecord:
            return getPurchaseRecordVC()
        case .message:
            return getMessageCenterVC()
        case .accountDetails:
            return getAccountDetailsVC()
        default:
            return[]
        }
        
    
    }
    
    //MARK: - 初始化控制器
    private func getCouponViewController() -> [UIViewController]{
        let notUsed = CouponViewController()
        notUsed.couponType = .unUsed
        let used = CouponViewController()
        used.couponType = .used
        let overdue = CouponViewController()
        overdue.couponType = .overdue
        
        return [notUsed, used, overdue]
    }
    
    private func getPurchaseRecordVC() -> [UIViewController] {
        let all = PurchaseRecordVC()
        all.recordType = .all
        let winning = PurchaseRecordVC()
        winning.recordType = .winning
        let prize = PurchaseRecordVC()
        prize.recordType = .prize
        return [all, winning, prize]
    }
    
    private func getMessageCenterVC() -> [UIViewController] {
        let notice = MessageCenterVC()
        notice.messageType = .notice
        let message = MessageCenterVC()
        message.messageType = .message
        return [notice, message]
    }
    private func getAccountDetailsVC() -> [UIViewController] {
        let all = AccountDetailsVC()
        all.accountType = .all
        let bonus = AccountDetailsVC()
        bonus.accountType = .bonus
        let recharge = AccountDetailsVC()
        recharge.accountType = .recharge
        let buy = AccountDetailsVC()
        buy.accountType = .buy
        let withdrawal = AccountDetailsVC()
        withdrawal.accountType = .withdrawal
        let coupon = AccountDetailsVC()
        coupon.accountType = .coupon
        return [all, bonus, recharge, buy, withdrawal, coupon]
    }
    
    
    
    
    
    
    
    
    
    private func setLiftButtonItem() {
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        leftBut.setBackgroundImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc private func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
