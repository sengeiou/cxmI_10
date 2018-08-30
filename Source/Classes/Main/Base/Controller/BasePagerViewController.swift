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
    case coupon = "我的卡券"
    case purchaseRecord = "投注记录"
    case message = "消息中心"
    case accountDetails = "账户明细"
    case trend = "走势图"
    case activityCenter = "活动中心"
    case leagueMatch = "联赛资料"
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
    
    var pagerType: PagerViewType! {
        didSet{
            
        }
    }
    var accountFilterList : [AccountDetailFilterModel]!
    
    private var accountAll : CXMAccountDetailsVC!
    private var accountBonus: CXMAccountDetailsVC!
    private var accountRecharge: CXMAccountDetailsVC!
    private var accountBuy : CXMAccountDetailsVC!
    private var accountWithdrawal : CXMAccountDetailsVC!
    private var accountCoupon : CXMAccountDetailsVC!
    
    lazy private var redList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var bludList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    lazy private var viewModel : DLTTrendBottomModel = {
        return DLTTrendBottomModel()
    }()
    lazy private var trendSettingModel : DLTTrendSettingModel = {
        return DLTTrendSettingModel()
    }()
    
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
        self.containerView.isScrollEnabled = true
        switch pagerType {
        case .coupon:
            return getCouponViewController()
        case .purchaseRecord:
            return getPurchaseRecordVC()
        case .message:
            return getMessageCenterVC()
        case .accountDetails:
            return getAccountDetailsVC()
        case .trend:
            setTrendRightItem()
            self.containerView.isScrollEnabled = false
            return getTrendVC()
        case .activityCenter:
            return getActivityCenterVC()
        case .leagueMatch:
            return getLeagueMatchVC()
        default:
            return[]
        }
        
    
    }
    
    //MARK: - 初始化控制器
    private func getCouponViewController() -> [UIViewController]{
        let notUsed = CXMCouponViewController()
        notUsed.couponType = .unUsed
        let used = CXMCouponViewController()
        used.couponType = .used
        let overdue = CXMCouponViewController()
        overdue.couponType = .overdue
        
        return [notUsed, used, overdue]
    }
    
    private func getPurchaseRecordVC() -> [UIViewController] {
        let all = CXMPurchaseRecordVC()
        all.recordType = .all
        let winning = CXMPurchaseRecordVC()
        winning.recordType = .winning
        let prize = CXMPurchaseRecordVC()
        prize.recordType = .prize
        return [all, winning, prize]
    }
    
    private func getMessageCenterVC() -> [UIViewController] {
        let notice = CXMMessageCenterVC()
        notice.messageType = .notice
        let message = CXMMessageCenterVC()
        message.messageType = .message
        return [notice, message]
    }
    private func getAccountDetailsVC() -> [UIViewController] {
        self.showAccountDetailsFilter = true
        let all = CXMAccountDetailsVC()
        self.accountAll = all
        all.accountType = .all
        let bonus = CXMAccountDetailsVC()
        self.accountBonus = bonus
        bonus.accountType = .bonus
        let recharge = CXMAccountDetailsVC()
        self.accountRecharge = recharge
        recharge.accountType = .recharge
        let buy = CXMAccountDetailsVC()
        self.accountBuy = buy
        buy.accountType = .buy
        let withdrawal = CXMAccountDetailsVC()
        self.accountWithdrawal = withdrawal
        withdrawal.accountType = .withdrawal
        let coupon = CXMAccountDetailsVC()
        self.accountCoupon = coupon
        coupon.accountType = .coupon
        return [all, bonus, recharge, buy, withdrawal, coupon]
    }
    
    private func getTrendVC() -> [UIViewController] {
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        
        let history = story.instantiateViewController(withIdentifier: "DLTHistoryTrendVC") as! CXMMDLTHistoryTrendVC
        history.settingViewModel = self.trendSettingModel
        
        let redTrend = story.instantiateViewController(withIdentifier: "DLTRedTrendVC") as! CXMMDLTRedTrendVC
        redTrend.style = .red
        redTrend.redList = self.redList
        redTrend.blueList = self.bludList
        redTrend.viewModel = self.viewModel
        redTrend.settingViewModel = self.trendSettingModel
        
        let blueTrend = story.instantiateViewController(withIdentifier: "DLTRedTrendVC") as! CXMMDLTRedTrendVC
        blueTrend.style = .blue
        blueTrend.redList = self.redList
        blueTrend.blueList = self.bludList
        blueTrend.viewModel = self.viewModel
        blueTrend.settingViewModel = self.trendSettingModel
        
        let redHot = story.instantiateViewController(withIdentifier: "DLTHotColdVC") as! CXMMDLTHotColdVC
        redHot.style = .red
        redHot.redList = self.redList
        redHot.blueList = self.bludList
        redHot.viewModel = self.viewModel
        redHot.settingViewModel = self.trendSettingModel
        let blueHot = story.instantiateViewController(withIdentifier: "DLTHotColdVC") as! CXMMDLTHotColdVC
        blueHot.style = .blue
        blueHot.redList = self.redList
        blueHot.blueList = self.bludList
        blueHot.viewModel = self.viewModel
        blueHot.settingViewModel = self.trendSettingModel
        
        return [history, redTrend, blueTrend, redHot, blueHot]
    }
    
    private func getActivityCenterVC() -> [UIViewController] {
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        let propress = story.instantiateViewController(withIdentifier: "ActivityCenterVC") as! CXMMActivityCenterVC
        propress.style = .progress
        
        let over = story.instantiateViewController(withIdentifier: "ActivityCenterVC") as! CXMMActivityCenterVC
        over.style = .over
        
        return [propress, over]
    }
    
    private func getLeagueMatchVC() -> [UIViewController] {
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        let hot = story.instantiateViewController(withIdentifier: "ActivityCenterVC") as! CXMMActivityCenterVC
        
        
        
        return [hot]
    }
    
    
    
    private func setTrendRightItem() {
        let leftBut = UIButton(type: .custom)
        leftBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leftBut.setImage(UIImage(named:"TrendSetting"), for: .normal)
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        leftBut.addTarget(self, action: #selector(showTrendSetting(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc private func showTrendSetting(_ sender: UIButton) {
        let vc = CXMMDLTTrendSettingVC()
        vc.settingViewModel = self.trendSettingModel
        
        self.present(vc, animated: true, completion: nil)
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
        let filter = CXMAccountDetailsFilter()
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
