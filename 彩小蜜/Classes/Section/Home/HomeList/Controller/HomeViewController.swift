//
//  HomeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum ShowType {
    case allShow
    case onlyNews
}

fileprivate let homeSportsCellIdentifier = "homeSportsCellIdentifier"
fileprivate let homeActivityCellIdentifier = "homeActivityCellIdentifier"
fileprivate let homeScrollBarCellIdentifier = "homeScrollBarCellIdentifier"

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"



class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, HomeSportLotteryCellDelegate {
    
    

    //MARK: - 点击事件
    func didSelectItem(playType: String, index: Int) {
        let football = FootballMatchVC()
        
        switch playType {
        case "2":
            football.matchType = .胜平负
        case "1":
            football.matchType = .让球胜平负
        case "4":
            football.matchType = .总进球
        case "5":
            football.matchType = .半全场
        case "3":
            football.matchType = .比分
        case "6":
            football.matchType = .混合过关
        case "7":
            football.matchType = .二选一
        default: break
            
        }
        football.homeData = homeData.dlPlayClassifyDetailDTOs[index]
        pushViewController(vc: football)
    }
    
    //MARK: - 属性 public
    public var homeStyle : ShowType! = .onlyNews {
        didSet{
            homeListRequest()
            self.view.addSubview(tableView)
        }
    }
    
    //MARK: - 属性
    private var homeData : HomeDataModel!
    private var header : HomeHeaderView!
    private var newsList : [NewsInfoModel]!
    private var newsListModel: NewsListModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 购彩大厅"
        newsList = [NewsInfoModel]()
        hideBackBut()
        
        setRightBarItem()
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }
    
    //MARK: - 加载数据
    private func loadNewData() {
        homeListRequest()
        //newsListRequest(1)
    }
    private func loadNextData() {
        guard self.newsListModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        newsListRequest(1)
    }
    
    //MARK: - 网络请求
    private func homeListRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.homeList)
            .asObservable()
            .mapObject(type: HomeDataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.homeData = data
                //weakSelf?.tableView.reloadData()
                guard data.navBanners != nil else { return }
                weakSelf?.header.bannerList = data.navBanners
                weakSelf?.newsListRequest(1)
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
        
        
    }
    
    private func newsListRequest(_ pageNum : Int) {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.newsList(page: pageNum))
            .asObservable()
            .mapObject(type: NewsListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                self.newsListModel = data
                if pageNum == 1 {
                    weakSelf?.newsList.removeAll()
                }
                weakSelf?.newsList.append(contentsOf: data.list)
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    
    
    //MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        
        header = HomeHeaderView()
        table.tableHeaderView = header
        
        table.register(HomeScrollBarCell.self, forCellReuseIdentifier: homeScrollBarCellIdentifier)
        table.register(HomeActivityCell.self, forCellReuseIdentifier: homeActivityCellIdentifier)
        table.register(HomeSportLotteryCell.self, forCellReuseIdentifier: homeSportsCellIdentifier)
        
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        
        return table
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard homeData != nil, let activity = self.homeData.activity else { return }
            let web = HomeWebViewController()
            web.urlStr = activity.actUrl
            web.titleStr = activity.actTitle
            pushViewController(vc: web)
        case 3:
            let web = NewsDetailViewController()
            //web.urlStr = activity.actUrl
            //web.titleStr = "activity.actTitle"
            web.newsInfo = self.newsList[indexPath.row]
            pushViewController(vc: web)
        default: break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if homeStyle == .onlyNews {
            return 1
        }else {
            return 3 + 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if homeStyle == .onlyNews {
            guard newsList.isEmpty == false else { return 0 }
            return newsList.count
        }else {
            if section == 3 {
                guard newsList.isEmpty == false else { return 0 }
                return newsList.count
            }else {
                return 1
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeStyle == .onlyNews {
            let newsInfo = newsList[indexPath.row]
            
            if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                return initNewsOnePicCell(indexPath: indexPath)
            }else if newsInfo.listStyle == "3" {
                return initNewsThreePicCell(indexPath: indexPath)
            }else {
                return initNewsNoPicCell(indexPath: indexPath)
            }
            
        }else {
            switch indexPath.section {
            case 0:
                return initScrollBarCell(indexPath: indexPath)
            case 1:
                return initActivityCell(indexPath: indexPath)
            case 2:
                return initSportLotteryCell(indexPath: indexPath)
            default:
                let newsInfo = newsList[indexPath.row]
                
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                    return initNewsOnePicCell(indexPath: indexPath)
                }else if newsInfo.listStyle == "3" {
                    return initNewsThreePicCell(indexPath: indexPath)
                }else {
                    return initNewsNoPicCell(indexPath: indexPath)
                }
            }
        }
    }
    
    private func initSportLotteryCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeSportsCellIdentifier, for: indexPath) as! HomeSportLotteryCell
        if self.homeData != nil {
            cell.playList = self.homeData.dlPlayClassifyDetailDTOs
        }
        
        cell.delegate = self
        return cell
    }
    private func initActivityCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeActivityCellIdentifier, for: indexPath) as! HomeActivityCell
        
        if self.homeData != nil, let activity = self.homeData.activity {
            cell.activityModel = activity
        }
        
        return cell
    }
    
    private func initScrollBarCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeScrollBarCellIdentifier, for: indexPath) as! HomeScrollBarCell
        if self.homeData != nil, let list = self.homeData.winningMsgs {
            cell.winningList = list
        }
        
        return cell
    }
    
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCellId, for: indexPath) as! NewsNoPicCell
        cell.newsInfo = self.newsList[indexPath.row]
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCellId, for: indexPath) as! NewsThreePicCell
        cell.newsInfo = self.newsList[indexPath.row]
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCellId, for: indexPath) as! NewsOnePicCell
        cell.newsInfo = self.newsList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if homeStyle == .onlyNews {
            
            return 105 * defaultScale
        }else {
            switch indexPath.section {
            case 0:
                return 30
            case 1:
                return 80
            case 2:
                guard self.homeData != nil else { return 0 }
                let count = self.homeData.dlPlayClassifyDetailDTOs.count
                var verticalCount = count / HorizontalItemCount
                
                if count % HorizontalItemCount != 0 {
                    verticalCount += 1
                }
                
                let height : CGFloat = HomesectionTopSpacing * 2 + FootballCellHeight * CGFloat(verticalCount) + FootballCellLineSpacing * CGFloat(verticalCount) + HomeSectionViewHeight
                
                return height
            default:
                let newsInfo = newsList[indexPath.row]
                
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                    return 110 * defaultScale
                }
                else {
                    return 140 * defaultScale
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setRightBarItem() {
        let leftBut = UIButton(type: .custom)
        //leftBut.setTitle("返回", for: .normal)
        
        leftBut.titleLabel?.font = Font15
        
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        leftBut.setTitleColor(UIColor.black, for: .normal)
        
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        
        leftBut.addTarget(self, action: #selector(rightBut(sender:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: leftBut)
        
        
    }
    
    @objc func rightBut(sender: UIButton) {
        //let xxx = BasePopViewController()
        //self.present(xxx, animated: true, completion: nil)
        let football = FootballMatchVC()
        pushViewController(vc: football)
        //pushLoginVC(from: self)
    }
    
}
