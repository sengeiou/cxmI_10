//
//  CXMMActivityCenterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum ActivityCenterStyle : String {
    case progress = "进行中"
    case over = "已结束"
}

class CXMMActivityCenterVC: BaseViewController, IndicatorInfoProvider {
    
    public var style : ActivityCenterStyle = .progress

    @IBOutlet weak var tableView: UITableView!
    
    private var activityModel : ActivityListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubview()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        
        tableView.beginRefreshing()
        
    }

    private func initSubview() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF4F4F4
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: style.rawValue)
    }
    

    
}

// MARK: - 网络请求
extension CXMMActivityCenterVC {
    private func loadNewData() {
        activityRequest()
    }
    private func activityRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.activityCenter())
            .asObservable()
            .mapObject(type: ActivityListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.activityModel = data
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

extension CXMMActivityCenterVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CXMMActivityCenterVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch style {
        case .progress:
            return activityModel != nil ? activityModel.onlineList.count : 0
        case .over:
            return activityModel != nil ? activityModel.offlineList.count : 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCenterCell", for: indexPath) as! ActivityCenterCell
        
        switch style {
        case .progress:
            cell.configure(with: activityModel.onlineList[indexPath.section], style: .progress)
        case .over:
            cell.configure(with: activityModel.offlineList[indexPath.section], style: .over)
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180 * defaultScale
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}






