//
//  CXMMDaletouProVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouProVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubview()
    }

    private func setSubview() {
        
    }

}

extension CXMMDaletouProVC : UITableViewDelegate {
    
}
extension CXMMDaletouProVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTProTableViewCell", for: indexPath) as! DLTProTableViewCell
        return cell
    }
    
}
