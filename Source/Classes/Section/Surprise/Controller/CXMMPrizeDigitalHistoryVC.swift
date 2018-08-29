//
//  CXMMPrizeDigitalHistoryVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMPrizeDigitalHistoryVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}

// MARK: - table Delegate
extension CXMMPrizeDigitalHistoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let story = UIStoryboard(name: "Surprise", bundle: nil )
//        let prizeHistory = story.instantiateViewController(withIdentifier: "PrizeDigitalHistoryVC") as! CXMMPrizeDigitalHistoryVC
//        
//        pushViewController(vc: prizeHistory)
    }
}
// MARK: - table DataSource
extension CXMMPrizeDigitalHistoryVC : UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeDigitalHistoryCell", for: indexPath) as! PrizeDigitalHistoryCell
        
        return cell
    }
    private func initMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeMatchCell", for: indexPath) as! SurprisePrizeMatchCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
