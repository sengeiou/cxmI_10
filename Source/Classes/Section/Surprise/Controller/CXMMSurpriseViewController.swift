//
//  SurpriseViewController.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import UIKit


class CXMMSurpriseViewController: BaseViewController{

    public var showType: ShowType! = .onlyNews{
        didSet{
            guard showType != nil else { return }
            if showType == .onlyNews {
                
            }else {
                
                
            }
            //self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
   
    private var surpriseModel : SurpriseModel!
    private var viewModel : ShooterHeaderViewModel = ShooterHeaderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
        hideBackBut()
        self.isHidenBar = false
        initSubview()
        //loadNewData()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.footerRefresh {
            self.loadNextData()
        }
        tableView.beginRefreshing()
        
        initData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        //turnOn = false
        if turnOn && self.showType != .allShow{
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.showType != .onlyNews {
            showType = .onlyNews
        }
    }
    
    private func initData() {
        
    }
    
    private func initSubview() {
//        tableView.register(NewsNoPicCell.self, forCellReuseIdentifier: NewsNoPicCell.identifier)
//        tableView.register(NewsOnePicCell.self, forCellReuseIdentifier: NewsOnePicCell.identifier)
//        tableView.register(NewsThreePicCell.self, forCellReuseIdentifier: NewsThreePicCell.identifier)
        
        tableView.register(SurpriseHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: SurpriseHeaderView.identifier)
        tableView.register(SurpriseShooterHeader.self,
                           forHeaderFooterViewReuseIdentifier: SurpriseShooterHeader.identifier)
    }
    
    @objc private func configNotification(_ notification : Notification) {
        guard let userinf = notification.userInfo else { return }
        guard let turnOn = userinf["showStyle"] as? Bool else { return }
        if turnOn && self.showType != .allShow{
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.showType != .onlyNews {
            showType = .onlyNews
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// 网络请求
extension CXMMSurpriseViewController {
    private func loadNewData() {
        prizeListRequest(pageNum: 1)
    }
    private func loadNextData() {
        guard self.surpriseModel != nil else { return }
        guard self.surpriseModel.dlArticlePage != nil else { return }
        guard self.surpriseModel.dlArticlePage.isLastPage == false else {
            self.tableView.noMoreData()
            return
        }
        
        prizeListRequest(pageNum: self.surpriseModel.dlArticlePage.nextPage)
    }
    private func prizeListRequest(pageNum : Int) {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.surpriseList(pageNum: pageNum))
            .asObservable()
            .mapObject(type: SurpriseModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                
                weakSelf?.surpriseModel = data
                
                weakSelf?.tableView.reloadData()
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}

// MARK: - SurpriseCategoryCell  Delegate
extension CXMMSurpriseViewController : SurpriseCategoryCellDelegate {
    func didSelectItem(info: SurpriseItemInfo, indexPath: IndexPath) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "PrizeListVC") as! CXMMPrizeListVC
        
        pushViewController(vc: vc   )
    }
}

extension CXMMSurpriseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension CXMMSurpriseViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard self.surpriseModel != nil else { return 0 }
            return 1
        case 1:
            return 1
        case 2:
            return 6
        default:
            guard self.surpriseModel != nil else { return 0 }
            guard self.surpriseModel.dlArticlePage != nil else { return 0 }
            guard let list = self.surpriseModel.dlArticlePage.list else { return 0 }
            return list.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let newsInfo = newsList[indexPath.row]
//
//        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" {
//            return initNewsOnePicCell(indexPath: indexPath)
//        }else if newsInfo.listStyle == "3" {
//            return initNewsThreePicCell(indexPath: indexPath)
//        }else {
//            return initNewsNoPicCell(indexPath: indexPath)
//        }
        
        switch indexPath.section {
        case 0:
            return initCategoryCell(indexPath: indexPath)
        case 1:
            return initCategoryCell(indexPath: indexPath)
        case 2:
            return initShooterCell(indexPath: indexPath)
        default:
            return initNewsOnePicCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SurpriseHeaderView.identifier) as! SurpriseHeaderView
            return header
        case 2:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SurpriseShooterHeader.identifier) as! SurpriseShooterHeader
            header.viewModel = self.viewModel
            return header
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    private func initCategoryCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseCategoryCell", for: indexPath) as! SurpriseCategoryCell
        cell.delegate = self
        //cell.configure(with: self.surpriseModel.discoveryHallClassifyList)
        return cell
    }
    private func initShooterCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseShooterCell", for: indexPath) as! SurpriseShooterCell
        return cell
    }
    private func initNewsNoPicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsNoPicCell.identifier, for: indexPath) as! NewsNoPicCell
        
        return cell
    }
    
    private func initNewsThreePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsThreePicCell.identifier, for: indexPath) as! NewsThreePicCell
        
        return cell
    }
    
    private func initNewsOnePicCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsOnePicCell.identifier, for: indexPath) as! NewsOnePicCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
//        let newsInfo = newsList[indexPath.row]
//        if newsInfo.listStyle == "1" || newsInfo.listStyle == "4" || newsInfo.listStyle == "0" {
//            return 110 * defaultScale
//        }
//        else {
//            return 150 * defaultScale
//        }
        switch indexPath.section {
        case 0:
            return 300
            
        default:
            return 110 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 34
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
