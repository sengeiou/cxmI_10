//
//  CXMMDLTHistoryTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDLTHistoryTrendVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubview()
    }

}
extension CXMMDLTHistoryTrendVC {
    private func setSubview() {
        self.tableView.separatorStyle = .none
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTHistoryTrendCell", for: indexPath) as! DLTHistoryTrendCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * defaultScale
    }
}
