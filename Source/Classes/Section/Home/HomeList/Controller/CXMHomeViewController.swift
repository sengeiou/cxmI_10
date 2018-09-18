//
//  HomeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RealmSwift
import HandyJSON

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



class CXMHomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, HomeSportLotteryCellDelegate, HomeHeaderViewDelegate {
    
    // MARK: - banner 点击
    func didTipBanner(banner: BannerModel) {
        pushRouterVC("banner: \(banner.bannerName)", urlStr: banner.bannerLink, from: self)
    }
    
    //MARK: - 点击事件
    func didSelectItem(playModel: HomePlayModel, index: Int) {
        pushRouterVC(urlStr: playModel.redirectUrl, from: self)
        
//        guard playModel.redirectUrl != nil , playModel.redirectUrl != "" else { return }
//        guard playModel.status != "" else { return }
//        switch playModel.status {
//        case "0":
//            //let url =  "http://192.168.31.205:8080?cxmxc=scm&type=1"
//            pushRouterVC(urlStr: playModel.redirectUrl, from: self)
//        case "1":
//            showHUD(message: playModel.statusReason)
//        default:
//            break
//        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if homeStyle == .onlyNews {
            let web = CXMNewsDetailViewController()
            web.articleId = self.newsList[indexPath.row].articleId
            pushViewController(vc: web)
        }else {
            switch indexPath.section {
            case 1:
                guard homeData != nil, let activity = self.homeData.activity else { return }
                pushRouterVC(activity.actTitle, urlStr: activity.actUrl, from: self)
            case 3:
                let web = CXMNewsDetailViewController()
                web.articleId = self.newsList[indexPath.row].articleId
                pushViewController(vc: web)
                
                // 测试web 传入Token
//                let web = WebViewController()
//
//                web.urlStr = "http://192.168.1.150:8080/#/user/activity"
//                pushViewController(vc: web)
            default: break
            }
        }
    }
    
    //MARK: - 属性 public
    public var homeStyle : ShowType! = .onlyNews {
        didSet{
            loadNewData()
            self.tableView.reloadData()
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
        self.navigationItem.title = "彩小秘 · 大厅"
        newsList = [NewsInfoModel]()
        hideBackBut()
        
        self.view.addSubview(tableView)
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
        
        getRealmData()
        
    }
    
    private func getRealmData() {
        guard let realm = try? Realm() else { return }
        
        guard let dataModel : HomeRealmData = realm.objects(HomeRealmData.self).last else { return }
        let dataStr = String(data: dataModel.data, encoding: .utf8)
        
        guard let data = JSONDeserializer<HomeListModel>.deserializeFrom(json: dataStr) else { return }
        
        homeData = data.dlHallDTO
        guard homeData.navBanners != nil else { return }
        header.bannerList = homeData.navBanners
        newsListModel = data.dlArticlePage
        
        newsList.append(contentsOf: self.newsListModel.list)
        
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
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn == false {
            self.homeStyle = .onlyNews
        }else {
            self.homeStyle = .allShow
        }
        
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("大厅")
        TongJi.log(.show, label: "大厅")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("大厅")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func configNotification(_ notification : Notification) {
        guard let userinf = notification.userInfo else { return }
        guard let turnOn = userinf["showStyle"] as? Bool else { return }
        if turnOn && self.homeStyle != .allShow{
            self.homeStyle = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.homeStyle != .onlyNews {
            self.homeStyle = .onlyNews
        }
    }
    //MARK: - 加载数据
    private func loadNewData() {
        //configRequest()
        homeListAndNewsRequest(pageNum: 1)
    }
    private func loadNextData() {
        guard self.newsListModel != nil else { return }
        guard self.newsListModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        //newsListRequest(1)
        homeListAndNewsRequest(pageNum: self.newsListModel.nextPage)
    }
    
    //MARK: - 网络请求
    
    private func homeListAndNewsRequest(pageNum: Int) {
        weak var weakSelf = self
        
        if newsList == nil {
            newsList = [NewsInfoModel]()
        }
        
        var isTransaction : String
        if homeStyle == .allShow {
            isTransaction = "2"
        }else {
            isTransaction = "1"
        }
        
        _ = homeProvider.rx.request(.hallMix(page: pageNum, isTransaction: isTransaction))
            .asObservable()
            .mapObject(type: HomeListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                if pageNum == 1 {
                    weakSelf?.homeData = data.dlHallDTO
                    guard weakSelf?.homeData.navBanners != nil else { return }
                    weakSelf?.header.bannerList = weakSelf?.homeData.navBanners
                }
                
                weakSelf?.newsListModel = data.dlArticlePage
                if pageNum == 1 {
                    weakSelf?.newsList.removeAll()
                }
                weakSelf?.newsList.append(contentsOf: self.newsListModel.list)
                DispatchQueue.main.async {
                    weakSelf?.tableView.reloadData()
                }
                
                DispatchQueue.global().async {
                    let xxx = data.toJSONString()
                    let dataStr = xxx?.data(using: .utf8)
                    
                    guard let realm = try? Realm() else { return }
                    let dataRealm = HomeRealmData()
                    dataRealm.data = dataStr!
                    
//                    let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
//
//                    if turnOn {
//                        dataRealm.homeStyle = 1
//                    }else {
//                        dataRealm.homeStyle = 0
//                    }
                    
                    try! realm.write {
                        realm.add(dataRealm, update: true)
                    }
                }
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }

    //MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorStyle = .none
        header = HomeHeaderView()
        header.delegate = self
        table.tableHeaderView = header
        
        table.register(HomeScrollBarCell.self, forCellReuseIdentifier: homeScrollBarCellIdentifier)
        table.register(HomeActivityCell.self, forCellReuseIdentifier: homeActivityCellIdentifier)
        table.register(HomeSportLotteryCell.self, forCellReuseIdentifier: homeSportsCellIdentifier)
        
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        
        return table
    }()
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard homeStyle != nil else { return 0 }
        if homeStyle == .onlyNews {
            return 1
        }else {
            return 3 + 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if homeStyle == .onlyNews {
            guard newsList != nil, newsList.isEmpty == false else { return 0 }
            return newsList.count
        }else {
            if section == 3 {
                guard newsList != nil, newsList.isEmpty == false else { return 0 }
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
            cell.playList = self.homeData.lotteryClassifys
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
            let newsInfo = newsList[indexPath.row]
            if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                return 110 * defaultScale
            }
            else {
                return 150 * defaultScale
            }
            //return 105 * defaultScale
        }else {
            switch indexPath.section {
            case 0:
                return 35
            case 1:
                if self.homeData != nil, self.homeData.activity == nil {
                    return 0
                }else {
                    return 90 * defaultScale
                }
            case 2:
                guard self.homeData != nil else { return 0 }
                let count = self.homeData.lotteryClassifys.count
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
                    return 150 * defaultScale
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if homeStyle == .onlyNews {
            return 5
        }else {
            if section == 1 {
                guard self.homeData != nil else { return 0}
                if self.homeData.activity == nil {
                    return 0
                }else {
                    return 5
                }
            }
            return 5
        }
        
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
        let football = CXMFootballMatchVC()
        pushViewController(vc: football)
        //pushLoginVC(from: self)
    }
    
}
