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
import AudioToolbox
import Moya

enum ShowType {
    case allShow
    case onlyNews
}

fileprivate let homeSportsLotteryCellIdentifier = "homeSportsLotteryCellIdentifier"
fileprivate let homeSportsCellIdentifier = "homeSportsCellIdentifier"
fileprivate let homeActivityCellIdentifier = "homeActivityCellIdentifier"
fileprivate let homeScrollBarCellIdentifier = "homeScrollBarCellIdentifier"

fileprivate let NewsNoPicCellId = "NewsNoPicCellId"
fileprivate let NewsOnePicCellId = "NewsOnePicCellId"
fileprivate let NewsThreePicCellId = "NewsThreePicCellId"


//应该继承:BaseViewController, 因为悬浮框的问题需要重新继承:SuspendedViewController 它继承了BaseViewController
class CXMHomeViewController: SuspendedViewController, UITableViewDelegate, UITableViewDataSource,BannerViewDelegate {

    
    //MARK: - 属性 public
    public var homeStyle : ShowType! = .onlyNews {
        didSet{
            loadNewData()
            self.tableView.reloadData()
        }
    }
    
    //MARK: - 属性
    private var homeData : HomeDataModel!
    private var header : BannerView!
    private var newsList : [NewsInfoModel]!
    private var newsListModel: NewsListModel!
    
    private var activityModel : [ActivityModel]!
    
    private var updateAppModel : HomeUpdateAppModel!
    
    private var isUpdateApp = false
    
    private var isSuspended = false
    

    

    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "圣和彩店"
        
        
        newsList = [NewsInfoModel]()
        hideBackBut()
        
        self.view.addSubview(tableView)
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        
        updateApp()
        activityRequest()
        
        suspendedRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didBecome),name: UIApplication.didBecomeActiveNotification,object: nil)

        getRealmData()
        
        // 定位信息
//        setLocation()
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn == false {
            self.homeStyle = .onlyNews
        }else {
            self.homeStyle = .allShow
            
            if homeData != nil {
                if homeData.discoveryHallClassifyDTOList.count != 0 {
                    for data in homeData.discoveryHallClassifyDTOList {
                        if data.type == "10" {
                            var systemSoundID : SystemSoundID = 0
                            let path = Bundle.main.path(forResource: "coin", ofType: "mp3")
                            AudioServicesCreateSystemSoundID(NSURL.fileURL(withPath: path!) as CFURL, &systemSoundID)
                            AudioServicesPlayAlertSound(SystemSoundID(systemSoundID))
                        }
                    }
                }
            }
        }
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
    
    //视图即将显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isHidenBar = false
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn == false {
            self.homeStyle = .onlyNews
        }else {
            self.homeStyle = .allShow
        }
        
        guard activityModel != nil else { return }
        
        if popNumber < self.activityModel.count{
            self.showActivityPop(index: popNumber)
        }
//        tableView.reloadData()
    }
    
    //视图即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("大厅")
        TongJi.log(.show, label: "大厅")
    }
    
    @objc func didBecome(){
        print("didi become")
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
    
    
    //MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorStyle = .none
        header = BannerView()
        header.delegate = self
        table.tableHeaderView = header
        
        table.register(HomeScrollBarCell.self, forCellReuseIdentifier: homeScrollBarCellIdentifier)
        table.register(HomeActivityCell.self, forCellReuseIdentifier: homeActivityCellIdentifier)
        table.register(HomeSportLotteryCell.self, forCellReuseIdentifier: homeSportsLotteryCellIdentifier)
        table.register(HomeSportCell.self, forCellReuseIdentifier: homeSportsCellIdentifier)
        
        table.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCellId)
        table.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCellId)
        table.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCellId)
        
        return table
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRightBarItem() {
        let leftBut = UIButton(type: .custom)
        leftBut.titleLabel?.font = Font15
        leftBut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        leftBut.setTitleColor(UIColor.black, for: .normal)
        leftBut.setImage(UIImage(named:"ret"), for: .normal)
        leftBut.addTarget(self, action: #selector(rightBut(sender:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: leftBut)
    }
    
    @objc func rightBut(sender: UIButton) {
        let football = CXMFootballMatchVC()
        pushViewController(vc: football)
    }
    lazy var locationButton : UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setImage(UIImage(named: "dw"), for: .normal)
        button.setTitle("中国", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(ColorNavItem, for: .normal)
        button.titleLabel?.font = Font14
        return button
    }()
}



// MARK: - 点击事件
extension CXMHomeViewController : HomeSportLotteryCellDelegate, HomeSportCellDelegate {
    // banner 点击
    func didTipBanner(banner: BannerModel) {
        pushRouterVC("banner: \(banner.bannerName)", urlStr: banner.bannerLink, from: self)
    }
    
    // 玩法点击
    func didSelectItem(playModel: HomePlayModel, index: Int) {
        
        guard playModel.status == "0" else {
            showHUD(message: playModel.statusReason)
            return
        }
        pushRouterVC(urlStr: playModel.redirectUrl, from: self)
    }
    // 发现点击
    func didSelectSportItem(playModel: HomeFindModel, index: Int) {
        guard playModel.status == "1" else {
            showHUD(message: playModel.statusReason)
            return
        }
        pushRouterVC(urlStr: playModel.redirectUrl, from: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if homeStyle == .onlyNews {
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch indexPath.section {
                case 1:
                    let web = CXMNewsDetailViewController()
                    web.articleId = self.newsList[indexPath.row].articleId
                    pushViewController(vc: web)
                default:
                    break
                }
            }else {
                let web = CXMNewsDetailViewController()
                web.articleId = self.newsList[indexPath.row].articleId
                pushViewController(vc: web)
            }
        }else {
            
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch indexPath.section {
                case 1:
                    guard homeData != nil, let activity = self.homeData.activity else { return }
                    pushRouterVC(activity.actTitle, urlStr: activity.actUrl, from: self)
                case 4:
                    let web = CXMNewsDetailViewController()
                    web.articleId = self.newsList[indexPath.row].articleId
                    pushViewController(vc: web)
                default: break
                }
            }else {
                switch indexPath.section {
                case 1:
                    guard homeData != nil, let activity = self.homeData.activity else { return }
                    pushRouterVC(activity.actTitle, urlStr: activity.actUrl, from: self)
                case 3:
                    let web = CXMNewsDetailViewController()
                    web.articleId = self.newsList[indexPath.row].articleId
                    pushViewController(vc: web)
                default: break
                }
            }
        }
    }
}

// MARK: - table DataSource
extension CXMHomeViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard homeStyle != nil else { return 0 }
        guard homeData != nil else { return 0 }
        if homeStyle == .onlyNews {
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                return 1 + 1
            }
            return 1
        }else {
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                return 3 + 1 + 1
            }
            return 3 + 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if homeStyle == .onlyNews {
            
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch section {
                case 0 :
                    return 1
                default :
                    guard newsList != nil, newsList.isEmpty == false else { return 0 }
                    return newsList.count
                }
            }else {
                guard newsList != nil, newsList.isEmpty == false else { return 0 }
                return newsList.count
            }
        }else {
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch section {
                case 4:
                    guard newsList != nil, newsList.isEmpty == false else { return 0 }
                    return newsList.count
                default :
                    return 1
                }
            }else {
                switch section {
                case 3:
                    guard newsList != nil, newsList.isEmpty == false else { return 0 }
                    return newsList.count
                default :
                    return 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeStyle == .onlyNews {
            
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch indexPath.section {
                case 0:
                    return initSportCell(indexPath: indexPath)
                default :
                    let newsInfo = newsList[indexPath.row]
                    
                    if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                        return initNewsOnePicCell(indexPath: indexPath)
                    }else if newsInfo.listStyle == "3" {
                        return initNewsThreePicCell(indexPath: indexPath)
                    }else {
                        return initNewsNoPicCell(indexPath: indexPath)
                    }
                }
            }else {
                let newsInfo = newsList[indexPath.row]
                
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
                    return initNewsOnePicCell(indexPath: indexPath)
                }else if newsInfo.listStyle == "3" {
                    return initNewsThreePicCell(indexPath: indexPath)
                }else {
                    return initNewsNoPicCell(indexPath: indexPath)
                }
//                switch indexPath.section {
//                case 0:
//                    return initSportCell(indexPath: indexPath)
//                default :
//                    let newsInfo = newsList[indexPath.row]
//
//                    if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
//                        return initNewsOnePicCell(indexPath: indexPath)
//                    }else if newsInfo.listStyle == "3" {
//                        return initNewsThreePicCell(indexPath: indexPath)
//                    }else {
//                        return initNewsNoPicCell(indexPath: indexPath)
//                    }
//                }
            }
            
            
        }else {
            
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch indexPath.section {
                case 0:
                    return initScrollBarCell(indexPath: indexPath)
                case 1:
                    return initActivityCell(indexPath: indexPath)
                case 2:
                    return initSportCell(indexPath: indexPath)
                case 3:
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
                
                
                
                
            }else {
                switch indexPath.section {
                case 0:
                    return initScrollBarCell(indexPath: indexPath)
                case 1:
                    return initActivityCell(indexPath: indexPath)
                case 2:
                    return initSportLotteryCell(indexPath: indexPath)
//                case 3:
//                    return initSportLotteryCell(indexPath: indexPath)
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
    }
    
    private func initSportLotteryCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeSportsLotteryCellIdentifier, for: indexPath) as! HomeSportLotteryCell
        if self.homeData != nil {
            cell.playList = self.homeData.lotteryClassifys
        }
        
        cell.delegate = self
        return cell
    }
    // 发现
    private func initSportCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeSportsCellIdentifier, for: indexPath) as! HomeSportCell
        if self.homeData != nil {
            cell.configure(with: self.homeData.discoveryHallClassifyDTOList)
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
            if homeData.discoveryHallClassifyDTOList.count != 0 {
                switch indexPath.section {
                case 0:
                    guard self.homeData != nil else { return 0 }
                    let count = self.homeData.discoveryHallClassifyDTOList.count
                    var verticalCount = count / HorizontalSportItemCount
                    
                    if count % HorizontalSportItemCount != 0 {
                        verticalCount += 1
                    }
                    
                    let height : CGFloat = HomesectionTopSportSpacing * 2 + FootballSportCellHeight * CGFloat(verticalCount) + FootballCellLineSportSpacing * CGFloat(verticalCount) + HomeSectionViewSportHeight
                    
                    return height
                default :
                    let newsInfo = newsList[indexPath.row]
                    if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                        return 110 * defaultScale
                    }
                    else {
                        return 150 * defaultScale
                    }
                }
            }else {
                let newsInfo = newsList[indexPath.row]
                if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
                    return 110 * defaultScale
                }
                else {
                    return 150 * defaultScale
                }
            }
        }else {
            
            if homeData.discoveryHallClassifyDTOList.count != 0 {
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
                    let count = self.homeData.discoveryHallClassifyDTOList.count
                    var verticalCount = count / HorizontalSportItemCount
                    
                    if count % HorizontalSportItemCount != 0 {
                        verticalCount += 1
                    }
                    
                    let height : CGFloat = HomesectionTopSportSpacing * 2 + FootballSportCellHeight * CGFloat(verticalCount) + FootballCellLineSportSpacing * CGFloat(verticalCount) + HomeSectionViewSportHeight
                    
                    return height
                case 3:
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
}
// MARK: - 网络请求
extension CXMHomeViewController {
    
    
    
    private func updateApp() {
        _ = userProvider.rx.request(.updateApp(channel: Channel, version: majorVersion!))
            .asObservable()
            .mapObject(type: HomeUpdateAppModel.self)
            .subscribe(onNext: { (data) in
                self.updateAppModel = data
                self.showUpdateAppPop()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 301060:
                       print("无最新版本")
                    default : break
                    }
                    if 300000...310000 ~= code {
//                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
    }

    
    
    private func loadNewData() {
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
    
    
    
}

// MARK: - 定位
extension CXMHomeViewController {
    
    
    private func setLocation() {
        setLocationNav()
        startLocation()
    }
    
    private func setLocationNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationButton)
    }
    
    private func startLocation() {
        LocationManager.shareManager.creatLocationManager().startLocation { (location, adress, error) in
            print("经度 \(location?.coordinate.longitude ?? 0.0)")
            print("纬度 \(location?.coordinate.latitude ?? 0.0)")
            print("地址\(adress?.locality ?? "")")
            print("error\(error ?? "没有错误")")
            
            guard location != nil else { return }
            
            var loca = Location(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
            
            let bd = loca.transformFromGPSToBD()
            
            if let locality = adress?.locality {
                self.locationButton.setTitle("\(locality)", for: .normal)
            }else {
                self.locationButton.setTitle("中国", for: .normal)
            }
            
            if let adress = adress {
                // 存储经纬度信息
                LocationManager.saveLocation(location: adress)
//                if let latitude = location?.coordinate.latitude,
//                    let longitude = location?.coordinate.longitude {
//
//                }
            }
            
            let xx = LocationManager.getLocation()
            
            print("\(bd.latitude),\(bd.longitude)")
        }
    }
}

// MARK: - 优惠券弹框
extension CXMHomeViewController : CouponPopVCDelegate {
    func didTipCouponPop() {
        pushPagerView(pagerType: .coupon)
    }
    
    private func showCouponPop() {
        guard self.activityModel != nil else { return }
        let coupon = CouponPopVC()
        coupon.activityModel = self.activityModel
        let img = UIImage(named: "优惠券")
        
        let scaleWH: CGFloat = img!.size.height / img!.size.width
        
        coupon.configure(with: screenWidth - 50, height: (screenWidth - 50) * scaleWH)
        coupon.imageView.image = img
        coupon.delegate = self
        
        DispatchQueue.main.async {
            self.present(coupon)
        }
    }
}


// MARK: - 更新弹框
extension CXMHomeViewController : UpdateAppPopVcDelegate {
    func deleteClicked() {
        guard self.activityModel != nil else { return }
        isUpdateApp = false
        if popNumber < self.activityModel.count{
            self.showActivityPop(index: popNumber)
        }
    }
    
    func didTipUpdateApp(link: String) {
        guard updateAppModel != nil else { return }
        pushRouterVC(urlStr: updateAppModel.url, from: self)
    }
    
    private func showUpdateAppPop() {
        isUpdateApp = true
        guard updateAppModel != nil else { return }
        let updateApp = UpdateAppPopVc()
        updateApp.imageView.image = UIImage(named: "update")
        
        //是否强制升级:0-非强制 1-强制
        if updateAppModel.type == "0"{
            updateApp.deleteBut.isHidden = false
        }else{
            updateApp.deleteBut.isHidden = true
        }
        
        updateApp.configure(version: updateAppModel.version)
        

        if updateAppModel.updateLogList != nil{
            updateApp.configureList(list:updateAppModel.updateLogList)
        }
        
        updateApp.delegate = self
        
        DispatchQueue.main.async {
            self.present(updateApp)
        }
    }
}


// MARK: - 活动弹框
extension CXMHomeViewController : HomeActivityViewDelegate {

    func didTipActivity(link: String) {
        guard activityModel != nil else { return }
        if activityModel[popNumber].name == "2"{
            pushPagerView(pagerType: .coupon)
        }else{
            pushRouterVC(urlStr: activityModel[popNumber].bannerLink, from: self)
        }
    }
    
    func deleteHide() {
        if popNumber < self.activityModel.count{
            self.showActivityPop(index: popNumber)
        }
    }

    func showActivityPop(index: Int){
        guard self.activityModel.count != 0 else { return }
        let activity = HomeActivityView.init(frame: UIScreen.main.bounds)
        
        activity.activityModel = self.activityModel[index]
        activity.createView()
        
        var url = URL.init(string: "")
        if activity.activityModel.name != "2"{
            url = URL(string : activity.activityModel.bannerImage)
        }
        
        activity.imageView.kf.setImage(with: url, placeholder: nil, options: nil , progressBlock: nil) { (image, error, type , url) in
            if activity.activityModel.name == "2"{
                let img = Image(named: "优惠券")
                let scaleWH: CGFloat = img!.size.height / img!.size.width
                activity.configure(with: popNumber, width: screenWidth - 50, height: (screenWidth - 50) * scaleWH)
                activity.imageView.image = img
                activity.delegate = self
                return
            }else{
                let img = image
                activity.configure(with: popNumber, width: img!.size.width, height: img!.size.height)
                activity.delegate = self
            }
        }
        activity.show()
    }

        
//        guard let url = URL(string : activityModel[0].bannerImage) else { return }
//        let activity = ActivityPopVC()
//        activity.activityModel = self.activityModel
//        activity.imageView.kf.setImage(with: url, placeholder: nil, options: nil , progressBlock: nil) { (image, error, type , url) in
//            guard let img = image else { return }
//
//            activity.configure(with: img.size.width, height: img.size.height)
//            activity.delegate = self
//
//            DispatchQueue.main.async {
//                self.present(activity)
//            }
//        }
    
    private func activityRequest() {
        _ = activityProvider.rx.request(.activityNew).asObservable()
            .mapArray(type: ActivityModel.self)
            .subscribe(onNext: { (data) in
                print(data)
                self.activityModel = data
                
                if self.isUpdateApp == false{
                    self.showActivityPop(index: 0)
                }

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
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
    }
    

    
//    private func suspendedRequest() {
//        _ = activityProvider.rx.request(.suspended).asObservable()
//            .mapObject(type: ActivityModel.self)
//            .subscribe(onNext: { (data) in
//                self.suspendedModel = data
//                self.showSuspended()
//            }, onError: { (error) in
//                guard let err = error as? HXError else { return }
//                switch err {
//                case .UnexpectedResult(let code, let msg):
//                    switch code {
//                    case 600:
//                        break
//                    default : break
//                    }
//                    if 300000...310000 ~= code {
//                        self.showHUD(message: msg!)
//                    }
//                default: break
//                }
//            }, onCompleted: nil , onDisposed: nil)
//    }
    
    private func suspendedRequest() {
        _ = activityProvider.rx.request(.suspended).asObservable()
            .mapObject(type: ActivityModel.self)
            .subscribe(onNext: { (data) in
                homeSuspendedView.suspendedModel = data
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
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
    }
    
}


