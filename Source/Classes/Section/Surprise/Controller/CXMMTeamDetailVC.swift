//
//  CXMMTeamDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMTeamDetailVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var teamIcon : UIImageView!
    @IBOutlet weak var teamName : UILabel!
    @IBOutlet weak var teamTitle : UILabel!
    @IBOutlet weak var teamFoundingTime : UILabel! //成立时间
    @IBOutlet weak var teamRegion : UILabel! // 国家地区
    @IBOutlet weak var teamCity : UILabel! // 所在城市
    @IBOutlet weak var teamStadium : UILabel! // 球场
    @IBOutlet weak var teamStadiumCapacity : UILabel! // 球场容量
    @IBOutlet weak var teamValue : UILabel! // 球队价值
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }

    private func setData() {
        
    }
    
    private func initSubview() {
        tableView.separatorStyle = .none
        
    }
}

extension CXMMTeamDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMTeamDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

