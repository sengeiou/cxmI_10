//
//  HomeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
fileprivate let homeSportsCellIdentifier = "homeSportsCellIdentifier"
fileprivate let homeActivityCellIdentifier = "homeActivityCellIdentifier"
fileprivate let homeScrollBarCellIdentifier = "homeScrollBarCellIdentifier"


class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - 点击事件
    //MARK: - 属性

    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    //MARK: - 网络请求
    
    
    //MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        
        let header = HomeHeaderView()
        table.tableHeaderView = header
        
        table.register(HomeScrollBarCell.self, forCellReuseIdentifier: homeScrollBarCellIdentifier)
        table.register(HomeActivityCell.self, forCellReuseIdentifier: homeActivityCellIdentifier)
        table.register(HomeSportLotteryCell.self, forCellReuseIdentifier: homeSportsCellIdentifier)
        
        return table
    }()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeScrollBarCellIdentifier, for: indexPath) as! HomeScrollBarCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeActivityCellIdentifier, for: indexPath) as! HomeActivityCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeSportsCellIdentifier, for: indexPath) as! HomeSportLotteryCell
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 20
        case 1:
            return 80
        case 2:
            
            let count = 10
            var verticalCount = count / HorizontalItemCount
            
            if count % HorizontalItemCount != 0 {
                verticalCount += 1
            }
            
            let height : CGFloat = 10 + 10 + FootballCellHeight * CGFloat(verticalCount) + FootballCellLineSpacing * CGFloat(verticalCount)
            
            return height
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
