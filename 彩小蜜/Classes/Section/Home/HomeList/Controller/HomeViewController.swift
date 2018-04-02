//
//  HomeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
fileprivate let homeSportsCellIdentifier = "homeSportsCellIdentifier"
fileprivate let homeActivityCellIdentifier = "homeActivityCellIdentifier"
fileprivate let homeScrollBarCellIdentifier = "homeScrollBarCellIdentifier"


class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, HomeSportLotteryCellDelegate {

    //MARK: - 点击事件
    func didSelectItem() {
        let football = FootballMatchVC()
        pushViewController(vc: football)
    }
    //MARK: - 属性
    private var homeData : HomeDataModel!
    private var header : HomeHeaderView!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 购彩大厅"
        hideBackBut()
        self.view.addSubview(tableView)
        setRightBarItem()
        homeListRequest()
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
    //MARK: - 网络请求
    private func homeListRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.homeList)
            .asObservable()
            .mapObject(type: HomeDataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.homeData = data
                weakSelf?.tableView.reloadData()
                guard data.navBanners != nil else { return }
                weakSelf?.header.bannerList = data.navBanners
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
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
        default: break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeScrollBarCellIdentifier, for: indexPath) as! HomeScrollBarCell
            if self.homeData != nil, let list = self.homeData.winningMsgs {
                cell.winningList = list
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeActivityCellIdentifier, for: indexPath) as! HomeActivityCell
            
            if self.homeData != nil, let activity = self.homeData.activity {
                cell.activityModel = activity
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeSportsCellIdentifier, for: indexPath) as! HomeSportLotteryCell
            if self.homeData != nil {
                cell.playList = self.homeData.dlPlayClassifyDetailDTOs
            }
            
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
            return 0
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
