//
//  FootballMatchVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum FootballMatchType: String {
    case 胜平负 = "彩小秘 · 胜平负"
    case 让球胜平负 = "彩小秘 · 让球胜平负"
    
}

fileprivate let FootballSectionHeaderId = "FootballSectionHeaderId"

class FootballMatchVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballBottomViewDelegate, FootballSectionHeaderDelegate {
    func spread(sender: UIButton, section: Int) {
        let header = list[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - FOOTBALLBOTTOM delegate
    func delete() {
        
    }
    func confirm() {
        
    }
    
    // MARK: - 属性
    private var matchType: FootballMatchType = .胜平负
    private var list : [FootballMatchModel]!
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = matchType.rawValue
        
        initSubview()
        list = [FootballMatchModel]()
        
        for _ in 0...3 {
            let one = FootballMatchModel()
            list.append(one)
        }
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight)
            make.height.equalTo(44 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(44 * defaultScale + SafeAreaBottomHeight)
            make.bottom.equalTo(-0)
        }
    }
    // MARK: - 初始化子视图
    private func initSubview() {
        self.view.addSubview(tableView)
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
    }
    // MARK: - 网络请求
    // MARK: - 懒加载
    lazy private var topView: FootballTopView = {
        let topView = FootballTopView()
        return topView
    }()
    
    lazy private var bottomView: FootballBottomView = {
        let bottomView = FootballBottomView()
        bottomView.delegate = self
        return bottomView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(MeCell.self, forCellReuseIdentifier: "ss")
        table.register(FootballSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballSectionHeaderId)
        return table
    }()
    
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = list[section]
        
        if header.isSpreading == true {
            return 3
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ss", for: indexPath) as! MeCell
        cell.title.text = "ssss"
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballSectionHeaderId) as! FootballSectionHeader
        header.tag = section
        header.delegate = self
        
        if section == 0 {
            header.headerType = .hotMatch
        }else {
            header.headerType = .match
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
