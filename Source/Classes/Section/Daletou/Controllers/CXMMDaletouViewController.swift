//
//  CXMMDaletouViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouBottomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CXMMDaletouViewController {
    private func setTableview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
}

extension CXMMDaletouViewController : UITableViewDelegate {
    
}

extension CXMMDaletouViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            return initTitleCell(tableView, indexPath)
        case 1:
            return initStandardRedCell(tableView, indexPath)
        case 2:
            return initStandardBlueCell(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 40
        case 1:
            return 240 + 54 + 15
        case 2:
            return 117
        default:
            return 40
        }
    }
    
    private func initTitleCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouTitleCell", for: indexPath) as! DaletouTitleCell
        
        return cell
    }
    
    private func initStandardRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardRedCell", for: indexPath) as! DaletouStandardRedCell
        
        return cell
    }
    private func initStandardBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardBlueCell", for: indexPath) as! DaletouStandardBlueCell
        
        return cell
    }
    
}
