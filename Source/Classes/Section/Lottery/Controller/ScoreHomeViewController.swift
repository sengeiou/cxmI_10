//
//  ScoreHomeViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/12/4.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip




class ScoreHomeViewController: BasePagerViewController, AlertPro {

    public var pushFrom : PushFrom = .defaul
    
    private var finishedLabel: UILabel!
    private var notFinishedLabel: UILabel!
    private var myMatchLabel: UILabel!
    
    private var matchFilter : UIButton! //比赛筛选
    private var dateFilter : UIButton!  //日期筛选
    private var filterDate : String = ""
    private var filterList: [FilterModel]!
    
    private var dateList : [LotteryDateModel]!
    
    private var isAlready : Bool = false
    
    private var selectedMatchType : String = "0"
    
    /// 未结束
    private var notScore = CXMScoreListViewController()
    
    /// 已结束
    private var finishScore = CXMScoreListViewController()
    
    /// 我的比赛
    private var collectScore = CXMScoreListViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "比赛"
        setRightBarButton()
        
        notScore.shouldLogin = { [weak self] in
            self?.login()
        }
        finishScore.shouldLogin = { [weak self] in
            self?.login()
        }
        collectScore.shouldLogin = { [weak self] in
            self?.login()
        }
        
        notScore.matchType = "0"
        finishScore.matchType = "1"
        collectScore.matchType = "2"
        
        notScore.pushFrom = self.pushFrom
        finishScore.pushFrom = self.pushFrom
        collectScore.pushFrom = self.pushFrom
        
        finishedLabel = initLabel()
        notFinishedLabel = initLabel()
        myMatchLabel = initLabel()
        
        notScore.changeNum = { notFinishNum, finishNum, collectNum   in
            self.notFinishedLabel.text = notFinishNum
            self.finishedLabel.text = finishNum
            self.myMatchLabel.text = collectNum
        }
        finishScore.changeNum = { notFinishNum, finishNum, collectNum   in
            self.notFinishedLabel.text = notFinishNum
            self.finishedLabel.text = finishNum
            self.myMatchLabel.text = collectNum
        }
        collectScore.changeNum = { notFinishNum, finishNum, collectNum   in
            self.notFinishedLabel.text = notFinishNum
            self.finishedLabel.text = finishNum
            self.myMatchLabel.text = collectNum
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dateList == nil || dateList.count == 0 {
            dateFilterRequest()
        }
        self.hidesBottomBarWhenPushed = true
    }
    
    private func initLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Color9F9F9F
        label.textAlignment = .center
        label.font = Font12
        //label.backgroundColor = Color9F9F9F
        //label.text = "0"
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        //label.sizeToFit()
        return label
    }

    
    private func login() {
        let login = CXMVCodeLoginViewController()
        login.currentVC = self
        login.loginDelegate = self
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [notScore, finishScore, collectScore]
    }
   
    //MARK: - 修改角标显示样式
    private func changeLabelBGColor(index : Int) {
        switch index {
        case 0:
            notFinishedLabel.textColor = ColorF6AD41
            finishedLabel.textColor = Color9F9F9F
            myMatchLabel.textColor = Color9F9F9F
        case 1:
            finishedLabel.textColor = ColorF6AD41
            notFinishedLabel.textColor = Color9F9F9F
            myMatchLabel.textColor = Color9F9F9F
        case 2:
            myMatchLabel.textColor = ColorF6AD41
            finishedLabel.textColor = Color9F9F9F
            notFinishedLabel.textColor = Color9F9F9F
        default: break
        }
    }

}

extension ScoreHomeViewController : LoginProtocol {
    func didLogin(isLogin: Bool) {
        collectScore.shouldReload = isLogin
    }
}

extension ScoreHomeViewController {
    private func setRightBarButton() {
        matchFilter = UIButton(type: .custom)
        matchFilter.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        matchFilter.setImage(UIImage(named:"filter"), for: .normal)
        matchFilter.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        matchFilter.addTarget(self, action: #selector(matchFilterClick(_:)), for: .touchUpInside)
        
        dateFilter = UIButton(type: .custom)
        dateFilter.frame = CGRect(x: 0, y: 0, width: 45, height: 40)
        dateFilter.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        dateFilter.setImage(UIImage(named: "date"), for: .normal)
        dateFilter.addTarget(self, action: #selector(dateFilterClick(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: matchFilter), UIBarButtonItem(customView: dateFilter)]
    }
    
    @objc private func matchFilterClick(_ sender: UIButton) {
        
        let match = CXMLotteryMoreFilterVC()
        match.delegate = self
        match.filterList = self.filterList
        match.isAlreadyBuy = self.isAlready
        self.present(match, animated: true, completion: nil)
    }
    
    @objc private func dateFilterClick(_ sender: UIButton) {
        
        let date = CXMLotteryDateFilterVC()
        date.delegate = self
        date.dateList = self.dateList
        self.present(date, animated: true, completion: nil)
    }
    
    
}

extension ScoreHomeViewController : LotteryMoreFilterVCDelegate {
    func filterConfirm(leagueId: String, isAlreadyBuy: Bool) {
        self.isAlready = isAlreadyBuy
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MatchFilterNotificationName), object: nil, userInfo: ["leagueId" : leagueId, "isAlreadyBuy": isAlreadyBuy, "type" : self.selectedMatchType])
    }
}
extension ScoreHomeViewController : LotteryDateFilterVCDelegate {
    func didSelectDateItem(filter: CXMLotteryDateFilterVC, dateModel: LotteryDateModel) {
        self.filterDate = dateModel.strDate
        self.isAlready = false
        
        filterRequest()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DateFilterNotificationName), object: nil, userInfo: ["date" : dateModel, "type" : self.selectedMatchType])
    }
}

// MARK: - 网络请求
extension ScoreHomeViewController {
    
    private func filterRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterList(dateStr: filterDate))
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
    
    private func dateFilterRequest() {
        weak var weakSelf = self
        _ = lotteryProvider.rx.request(.dateFilter)
            .asObservable()
            .mapArray(type: LotteryDateModel.self)
            .subscribe(onNext: { (data) in
                self.dateList = data
                
                weakSelf?.filterRequest()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break }
            }, onCompleted: nil , onDisposed: nil )
    }
}
