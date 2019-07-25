//
//  ServiceHome.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/30.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ServiceHome: SuspendedViewController {

    @IBOutlet weak var tableView : UITableView!
    
    private var serviceModel : ServiceHomeModel!
    
    private var serviceList : [ServiceHomeModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "发现"
        hideBackBut()
        tableView.headerRefresh {
            self.serviceRequest()
        }
        tableView.beginRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }

}
// MARK: - 点击事件
extension ServiceHome : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = serviceList[indexPath.row]
        pushRouterVC(urlStr: model.url, from: self)
    }
}
// MARK: - DataSource
extension ServiceHome : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList != nil ? serviceList.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceHomeCell", for: indexPath) as! ServiceHomeCell
        cell.configure(with: serviceList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * defaultScale
    }
}
// MARK: - 网络请求
extension ServiceHome {
    private func serviceRequest() {
        weak var weakSelf = self
        _ = surpriseProvider.rx.request(.serviceList).asObservable()
            .mapArray(type: ServiceHomeModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.serviceList = data
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
