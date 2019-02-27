//
//  ESportsList.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class ESportsList: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "电竞单关"
        initSubview()
        loadNewData()
    }
}

// MARK: - 点击事件
extension ESportsList : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(storyboard: .ESports)
        let vc = story.instantiateViewController(withIdentifier: "ESportsLoLList") as! ESportsLoLList
        pushViewController(vc: vc)
    }
}

// MARK: -
extension ESportsList {
    private func initSubview() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = ColorE9E9E9
    }
}
// MARK: - DataSource
extension ESportsList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ESportsListCell", for: indexPath) as! ESportsListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

// MARK: - 网络请求
extension ESportsList {
    private func loadNewData() {
        
    }
    
    
}
