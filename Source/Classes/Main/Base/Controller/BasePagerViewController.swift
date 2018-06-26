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
    case coupon = "彩小秘 · 我的卡券"
    case purchaseRecord = "彩小秘 · 投注记录"
    case message = "彩小秘 · 消息中心"
    case accountDetails = "彩小秘 · 账户明细"
}

class BasePagerViewController: ButtonBarPagerTabStripViewController {
    
    public var showAccountDetailsFilter : Bool = false {
        didSet{
            if showAccountDetailsFilter {
                setRightButtonItem()
                self.accountFilterList = AccountDetailFilterModel.getDate()
            }
        }
    }
    
    private var rightButton: UIButton!
    
    private var filterTime : FilterTime!
    
    var pagerType: PagerViewType!
    var accountFilterList : [AccountDetailFilterModel]!
    
    private var accountAll : AccountDetailsVC!
    private var accountBonus: AccountDetailsVC!
    private var accountRecharge: AccountDetailsVC!
    private var accountBuy : AccountDetailsVC!
    private var accountWithdrawal : AccountDetailsVC!
    private var accountCoupon : AccountDetailsVC!
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = ColorFFFFFF
        settings.style.buttonBarItemBackgroundColor = ColorFFFFFF
        settings.style.selectedBarBackgroundColor = ColorE95504
        settings.style.buttonBarItemTitleColor = Color505050

        settings.style.selectedBarHeight = 1
        settings.style.buttonBarItemLeftRightMargin = 1
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumInteritemSpacing = 1
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemFont = Font15
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        
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
        self.showAccountDetailsFilter = true
        let all = AccountDetailsVC()
        self.accountAll = all
        all.accountType = .all
        let bonus = AccountDetailsVC()
        self.accountBonus = bonus
        bonus.accountType = .bonus
        let recharge = AccountDetailsVC()
        self.accountRecharge = recharge
        recharge.accountType = .recharge
        let buy = AccountDetailsVC()
        self.accountBuy = buy
        buy.accountType = .buy
        let withdrawal = AccountDetailsVC()
        self.accountWithdrawal = withdrawal
        withdrawal.accountType = .withdrawal
        let coupon = AccountDetailsVC()
        self.accountCoupon = coupon
        coupon.accountType = .coupon
        return [all, bonus, recharge, buy, withdrawal, coupon]
    }
    
    private func setLiftButtonItem() {
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
    
        leftBut.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    
    
    @objc private func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension BasePagerViewController : AccountDetailsFilterDelegate {
    func didSelect(time: FilterTime, title:String) {
        self.rightButton.setTitle(title, for: .normal)
        
        self.accountAll.filterTime = time
        self.accountBonus.filterTime = time
        self.accountRecharge.filterTime = time
        self.accountBuy.filterTime = time
        self.accountWithdrawal.filterTime = time
        self.accountCoupon.filterTime = time
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AccountDetailsFilterName), object: nil, userInfo: ["filterTime": time])
    }
    
    @objc private func rightButtonClick(_ sender: UIButton) {
        let filter = AccountDetailsFilter()
        filter.filterList = self.accountFilterList
        filter.delegate = self
        present(filter, animated: true, completion: nil )
    }
    
    private func setRightButtonItem() {
        
        rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        rightButton.setTitle("最近一周", for: .normal)
        rightButton.titleLabel?.font = Font14
        rightButton.setTitleColor(Color787878, for: .normal)
        rightButton.setImage(UIImage(named: "Collapse"), for: .normal)
        rightButton.contentHorizontalAlignment = .right
        rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: -10)
        rightButton.addTarget(self, action: #selector(rightButtonClick(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    
}
