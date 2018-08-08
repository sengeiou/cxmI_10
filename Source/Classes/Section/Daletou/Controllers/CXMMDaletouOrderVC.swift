//
//  CXMMDaletouOrderVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouOrderVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableview()
        
    }

  

    

}
extension CXMMDaletouOrderVC {
    private func setTableview() {
        
    }
}
extension CXMMDaletouOrderVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DaletouProVC") as! CXMMDaletouProVC
            pushViewController(vc: vc)
        default:
            break
        }
    }
}
extension CXMMDaletouOrderVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return initNotPrizeTitleCell(indexPath: indexPath)
        case 1:
            return initPrizeOrderCell(indexPath: indexPath)
        case 2:
            return initProgrammeCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
        
        
//        switch indexPath.row {
//        case 0:
//
//        case 1:
//            return initPrizeTitleCell(indexPath: indexPath)
//        case 2:
//
//        case 3:
//            return initPrizeExplainCell(indexPath: indexPath)
//        case 4:
//
//        default:
//
//
//            return UITableViewCell()
//        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 200
        case 2:
            return 180
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    private func initNotPrizeTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTNotPrizeTitleCell", for: indexPath) as! DLTNotPrizeTitleCell
        
        return cell
    }
    private func initPrizeTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeTitleCell", for: indexPath) as! DLTPrizeTitleCell
        
        return cell
    }
    private func initPrizeOrderCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeOrderCell", for: indexPath) as! DLTPrizeOrderCell
        
        return cell
    }
    private func initProgrammeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTProgrammeCell", for: indexPath) as! DLTProgrammeCell
        
        return cell
    }
    private func initPrizeExplainCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeExplainCell", for: indexPath) as! DLTPrizeExplainCell
        
        return cell
    }
}
