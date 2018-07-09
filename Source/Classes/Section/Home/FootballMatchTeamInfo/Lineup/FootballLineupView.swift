//
//  FootballLineupView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupView: UIView {

    public var lineupList : [[FootballLineupMemberInfo]]! {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    private func initSubview() {
        //self.alpha = 0
        //self.backgroundColor = Color44AE35
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    /// 懒加载
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        //table.backgroundColor = ColorF4F4F4
        //table.alpha = 0
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        
        table.register(FootballLineupViewCell.self, forCellReuseIdentifier: FootballLineupViewCell.identifier)
        table.register(FootballLineupViewOddCell.self, forCellReuseIdentifier: FootballLineupViewOddCell.identifier)
        
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FootballLineupView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FootballLineupView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.lineupList != nil else { return 0 }
        return self.lineupList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberList = self.lineupList[indexPath.row]
        
        if memberList.count % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FootballLineupViewCell.identifier, for: indexPath) as! FootballLineupViewCell
            cell.lineupList = memberList
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FootballLineupViewOddCell.identifier, for: indexPath) as! FootballLineupViewOddCell
            cell.lineupList = memberList
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
