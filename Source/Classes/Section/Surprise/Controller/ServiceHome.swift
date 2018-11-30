//
//  ServiceHome.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/30.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ServiceHome: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    
    private var serviceModel : ServiceHomeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "服务"
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
        
    }
}
// MARK: - DataSource
extension ServiceHome : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceHomeCell", for: indexPath) as! ServiceHomeCell
        
        return cell
    }
}
// MARK: - 网络请求
extension ServiceHome {
    private func serviceRequest() {
        
    }
}
