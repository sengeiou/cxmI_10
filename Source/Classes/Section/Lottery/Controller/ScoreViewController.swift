//
//  ScoreViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/4.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let numLabelWidth : CGFloat = 15
fileprivate let numLabelRightSpacing: CGFloat = 10

class ScoreViewController: WMPageController, AlertPro {

    private var titleDatas : [String] = ["未结束","已结束","我的比赛"]
    private var finishedLabel: UILabel!
    private var notFinishedLabel: UILabel!
    private var myMatchLabel: UILabel!
    
    private var matchFilter : UIButton! //比赛筛选
    private var dateFilter : UIButton!  //日期筛选
    
    private var selectedDateModel : LotteryDateModel!
    private var filterList: [FilterModel]!
    
    private var dateList : [LotteryDateModel]!
    private var isAlready : Bool = false
    
    override func viewDidLoad() {
        finishedLabel = initLabel()
        notFinishedLabel = initLabel()
        myMatchLabel = initLabel()
        
        self.dateList = LotteryDateModel().getDates()
        self.selectedDateModel = self.dateList.last
        
        self.menuViewStyle = .line
        self.titleColorNormal = Color505050
        self.titleColorSelected = ColorEA5504
        self.titleSizeNormal = 15
        self.titleSizeSelected = 15
        
        self.menuItemWidth = UIScreen.main.bounds.size.width / 3
        
        //self.itemMargin = 1
        
        self.progressWidth = 60
        self.progressViewIsNaughty = true
        
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 比分"
        setRightBarButton()
        
        filterRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initLabel() -> UILabel {
        let label = UILabel()
        label.textColor = ColorFFFFFF
        label.textAlignment = .center
        label.font = Font12
        label.backgroundColor = Color9F9F9F
        label.text = "0"
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }

    private func setRightBarButton() {
        matchFilter = UIButton(type: .custom)
        matchFilter.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        matchFilter.setTitle("筛选", for: .normal)
        matchFilter.setTitleColor(Color787878, for: .normal)
        matchFilter.addTarget(self, action: #selector(matchFilterClick(_:)), for: .touchUpInside)
        
        dateFilter = UIButton(type: .custom)
        dateFilter.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        dateFilter.setImage(UIImage(named: "date"), for: .normal)
        dateFilter.addTarget(self, action: #selector(dateFilterClick(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: matchFilter), UIBarButtonItem(customView: dateFilter)]
    }
    
    @objc private func matchFilterClick(_ sender: UIButton) {
        
        let match = LotteryMoreFilterVC()
        match.delegate = self
        match.filterList = self.filterList
        match.isAlreadyBuy = self.isAlready
        self.present(match, animated: true, completion: nil)
    }
    
    @objc private func dateFilterClick(_ sender: UIButton) {
        
        let date = LotteryDateFilterVC()
        date.delegate = self
        date.dateList = self.dateList
        self.present(date, animated: true, completion: nil)
    }
    
    private func changeLabelBGColor(index : Int) {
        switch index {
        case 0:
            notFinishedLabel.backgroundColor = ColorF6AD41
            finishedLabel.backgroundColor = Color9F9F9F
            myMatchLabel.backgroundColor = Color9F9F9F
        case 1:
            finishedLabel.backgroundColor = ColorF6AD41
            notFinishedLabel.backgroundColor = Color9F9F9F
            myMatchLabel.backgroundColor = Color9F9F9F
        case 2:
            myMatchLabel.backgroundColor = ColorF6AD41
            finishedLabel.backgroundColor = Color9F9F9F
            notFinishedLabel.backgroundColor = Color9F9F9F
        default: break
        }
    }
    
}

extension ScoreViewController : LotteryMoreFilterVCDelegate {
    func filterConfirm(leagueId: String, isAlreadyBuy: Bool) {
        self.isAlready = isAlreadyBuy
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MatchFilterNotificationName), object: nil, userInfo: ["leagueId" : leagueId, "isAlreadyBuy": isAlreadyBuy])
    }
}
extension ScoreViewController : LotteryDateFilterVCDelegate {
    func didSelectDateItem(filter: LotteryDateFilterVC, dateModel: LotteryDateModel) {
        self.selectedDateModel = dateModel
        self.isAlready = false
        filterRequest()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DateFilterNotificationName), object: nil, userInfo: ["date" : dateModel])
    }
}

extension ScoreViewController {
    
    private func filterRequest() {
        guard self.selectedDateModel != nil, self.selectedDateModel.date != nil else { return }
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterList(dateStr: self.selectedDateModel.date))
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                //self.tableView.endrefresh()
                weakSelf?.filterList = data
                
            }, onError: { (error) in
                //self.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
//                        weakSelf?.removeUserData()
//                        weakSelf?.pushLoginVC(from: self)
                        
                        break
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
}

extension ScoreViewController {
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        
        return self.titleDatas.count
    }
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return self.titleDatas[index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        let scoreList = ScoreListViewController()
        scoreList.dateFilter = self.selectedDateModel.date
        switch index {
        case 0:
            scoreList.matchType = "0"
        case 1:
            scoreList.matchType = "1"
        case 2:
            scoreList.matchType = "2"
        default: break
        }
        scoreList.changeNum = { num in
            switch index {
            case 0:
                self.notFinishedLabel.text = num
            case 1:
                self.finishedLabel.text = num
            case 2:
                self.myMatchLabel.text = num
            default: break
            }
        }
        return scoreList
    }
    
    override func menuView(_ menu: WMMenuView!, didSelectedIndex index: Int, currentIndex: Int) {
        super.menuView(menu, didSelectedIndex: index, currentIndex: currentIndex)
        changeLabelBGColor(index: index)
    }
    
    override func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        guard let index = info["index"] as? Int else { return }
        
        changeLabelBGColor(index: index)
    }
    
    override func menuView(_ menu: WMMenuView!, initialMenuItem: WMMenuItem!, at index: Int) -> WMMenuItem! {
        
        if index != 0 {
            let view = UIView(frame: CGRect(x: -1, y: 7.5, width: 1, height: 35))
            view.backgroundColor = ColorC8C8C8
            
            initialMenuItem.addSubview(view)
            
        }
        
        switch index {
        case 0:
            initialMenuItem.addSubview(notFinishedLabel)
            notFinishedLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(initialMenuItem.snp.centerY)
                make.right.equalTo(-numLabelRightSpacing)
                make.width.height.equalTo(numLabelWidth)
            }
        case 1:
            initialMenuItem.addSubview(finishedLabel)
            finishedLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(initialMenuItem.snp.centerY)
                make.right.equalTo(-numLabelRightSpacing)
                make.width.height.equalTo(numLabelWidth)
            }
        case 2:
            initialMenuItem.addSubview(myMatchLabel)
            myMatchLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(initialMenuItem.snp.centerY)
                make.right.equalTo(-numLabelRightSpacing)
                make.width.height.equalTo(numLabelWidth)
            }
        default: break
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
