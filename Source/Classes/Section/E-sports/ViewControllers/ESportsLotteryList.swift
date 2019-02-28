//
//  ESportsLotteryList.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

enum ESportsType : String {
    case LOL = "英雄联盟"
}

class ESportsLotteryList: BaseViewController {

    public var type : ESportsType = .LOL
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var matchCount : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var selectDetail : UILabel!
    @IBOutlet weak var confirmButton : UIButton!
    
    // 删除
    @IBAction func delete(sender : UIButton) {
        
    }
    // 确认
    @IBAction func confirm(sender : UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = type.rawValue
        initSubview()
        loadNewData()
    }
    
}

// MARK: - 点击事件
extension ESportsLotteryList : UITableViewDelegate {
    
}

// MARK: - DataSource
extension ESportsLotteryList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ESportsLoLCell", for: indexPath) as! LoLCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

// MARK: - 初始化
extension ESportsLotteryList {
    private func initSubview() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = ColorE9E9E9
    }
}

// MARK: - 网络请求
extension ESportsLotteryList {
    private func loadNewData() {
        
    }
    
}
