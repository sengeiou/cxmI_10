//
//  CXMMPrizeListVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMPrizeListVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "开奖"
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - 初始化 子视图
    private func initSubview() {
        
    }
    
}

// MARK: - table Delegate
extension CXMMPrizeListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        let prizeHistory = story.instantiateViewController(withIdentifier: "PrizeDigitalHistoryVC") as! CXMMPrizeDigitalHistoryVC
        
        pushViewController(vc: prizeHistory)
    }
}
// MARK: - table DataSource
extension CXMMPrizeListVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return initDigitalCell(indexPath: indexPath)
    }
    
    private func initDigitalCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeDigitalCell", for: indexPath) as! SurprisePrizeDigitalCell
        
        return cell
    }
    private func initMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeMatchCell", for: indexPath) as! SurprisePrizeMatchCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


