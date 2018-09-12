//
//  SurpriseViewController.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import UIKit

enum SurpriseLeagueStyle {
    case 英超
    case 德甲
    case 意甲
    case 西甲
    case 法甲
}

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
    
    private var leagueStyle : SurpriseLeagueStyle = .英超
    
    @IBOutlet weak var tableView: UITableView!
   
    
    private var surpriseModel : SurpriseModel!
    private var viewModel : ShooterHeaderViewModel = ShooterHeaderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 发现"
        hideBackBut()
        
        initSubview()
        //loadNewData()
        
        initData()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
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
        _ = viewModel.selectedItem.asObserver()
            .subscribe(onNext: { (index) in
                switch index {
                case 0:
                    self.leagueStyle = .英超
                case 1:
                    self.leagueStyle = .德甲
                case 2:
                    self.leagueStyle = .意甲
                case 3:
                    self.leagueStyle = .西甲
                case 4:
                    self.leagueStyle = .法甲
                default : break
                }
               
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
                }
                
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
    
    private func initSubview() {
        
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        
        
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
        prizeListRequest()
    }
    private func loadNextData() {
        guard self.surpriseModel != nil else { return }
       
        
        prizeListRequest()
    }
    private func prizeListRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.surpriseList())
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
    // 热门赛事
    func didSelectItem(info: LeagueInfoModel, indexPath: IndexPath) {
        let story = UIStoryboard(name: "Surprise", bundle: nil)
        
        let detail = story.instantiateViewController(withIdentifier: "LeagueMatchDetailVC") as! CXMMLeagueMatchDetailVC
        
        detail.leagueInfo = info
        
        pushViewController(vc: detail)
    }
    // 
    func didSelectItem(info: SurpriseItemInfo, indexPath: IndexPath) {
        guard info.redirectUrl != "" else { return }
        guard info.status != "" else { return }
        switch info.status {
        case "0":
            pushRouterVC(urlStr: info.redirectUrl, from: self)
        case "1":
            showHUD(message: info.statusReason)
        default:
            break
        }
    }
}

extension CXMMSurpriseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - TABLEVIEW DataSource
extension CXMMSurpriseViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.surpriseModel != nil else { return 0 }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.surpriseModel != nil else { return 0 }
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            guard surpriseModel != nil else { return 0 }
            guard surpriseModel.topScorerDTOList.count == 5 else { return 0 }
            switch leagueStyle {
            case .英超:
                return surpriseModel.topScorerDTOList[0].leagueShooterInfoList.count + 1
            case .德甲:
                return surpriseModel.topScorerDTOList[0].leagueShooterInfoList.count + 1
            case .意甲:
                return surpriseModel.topScorerDTOList[0].leagueShooterInfoList.count + 1
            case .西甲:
                return surpriseModel.topScorerDTOList[0].leagueShooterInfoList.count + 1
            case .法甲:
                return surpriseModel.topScorerDTOList[0].leagueShooterInfoList.count + 1
            }
        default:
            return  0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return initCategoryCell(indexPath: indexPath)
        case 1:
            return initLeagueCell(indexPath: indexPath)
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
        cell.style = .category
        cell.configure(with: self.surpriseModel.discoveryHallClassifyList)
        return cell
    }
    private func initLeagueCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseCategoryCell", for: indexPath) as! SurpriseCategoryCell
        cell.delegate = self
        cell.style = .hotLeague
        cell.configure(with: self.surpriseModel.hotLeagueList, style : .hotLeague)
        
        return cell
    }
    private func initShooterCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseShooterCell", for: indexPath) as! SurpriseShooterCell
        
        if indexPath.row != 0 {
            cell.topLine.isHidden = true
            
            switch leagueStyle {
            case .英超:
                cell.configure(with: surpriseModel.topScorerDTOList[0].leagueShooterInfoList[indexPath.row - 1])
            case .德甲:
                cell.configure(with: surpriseModel.topScorerDTOList[1].leagueShooterInfoList[indexPath.row - 1])
            case .意甲:
                cell.configure(with: surpriseModel.topScorerDTOList[2].leagueShooterInfoList[indexPath.row - 1])
            case .西甲:
                cell.configure(with: surpriseModel.topScorerDTOList[3].leagueShooterInfoList[indexPath.row - 1])
            case .法甲:
                cell.configure(with: surpriseModel.topScorerDTOList[4].leagueShooterInfoList[indexPath.row - 1])
            }
        }else {
            cell.topLine.isHidden = false
            
            var model = LeagueShooterInfo()
            model.sort = "排名"
            model.playerName = "球员"
            model.playerTeam = "球队"
            model.inNum = "总进球数"
            cell.configure(with: model)
        }
        
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
        
        switch indexPath.section {
        case 0:
            guard surpriseModel.discoveryHallClassifyList.count != 0 else { return 0 }
            let count = lineNumber(totalNum: surpriseModel.discoveryHallClassifyList.count, horizonNum: 4)
            
            if count == 0 {
                return 115
            }else {
                return CGFloat(count * 115)
            }
        case 1:
            
            guard surpriseModel.hotLeagueList.count != 0 else { return 0 }
            let count = lineNumber(totalNum: surpriseModel.hotLeagueList.count, horizonNum: 4)
            
            if count == 0 {
                return 115
            }else {
                return CGFloat(count * 115)
            }
        default:
            return 35 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        case 2:
            return 44
        default:
            return 34
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
