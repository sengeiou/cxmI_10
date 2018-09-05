//
//  CXMMLotterySchoolVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMLotterySchoolVC: BaseViewController {

    public var style : ActivityCenterStyle = .progress
    
    @IBOutlet weak var tableView: UITableView!
    
    private var schoolListModel : SchoolListModel!
    
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

}

// MARK: - 网络请求
extension CXMMLotterySchoolVC {
    private func loadNewData() {
        activityRequest()
    }
    private func activityRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.schoolList())
            .asObservable()
            .mapObject(type: SchoolListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.schoolListModel = data
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

extension CXMMLotterySchoolVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushWebViewController(url: schoolListModel.noviceClassroomList[indexPath.row].bannerLink)
    }
}

extension CXMMLotterySchoolVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return schoolListModel != nil ? schoolListModel.noviceClassroomList.count : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCenterCell", for: indexPath) as! ActivityCenterCell
        cell.configure(with: schoolListModel.noviceClassroomList[indexPath.section])
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
