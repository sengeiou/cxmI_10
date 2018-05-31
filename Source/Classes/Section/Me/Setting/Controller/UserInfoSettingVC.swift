//
//  UserInfoSettingVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum UserInfoSettingPushType {
    case 设置密码
    
}

fileprivate let UserInfoSettingCellId = "UserInfoSettingCellId"
fileprivate let UserInfoSettingHeaderViewId = "UserInfoSettingHeaderViewId"

class UserInfoSettingVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    public var userInfo : UserInfoDataModel!
    
    private var dataList: [SettingSectionModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        
        self.dataList = getDataList()
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    // MARK: - 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataList[indexPath.section]
        let row = section.list[indexPath.row]
        
        guard row.pushType != nil else { return }
        pushSettingVC(row.pushType)
    }
    
    private func pushSettingVC(_ model : UserInfoSettingPushType) {
        switch model {
        case .设置密码:
            let pass = SettingPasswordVC()
            pushViewController(vc: pass)
        
        }
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(UserInfoSettingCell.self, forCellReuseIdentifier: UserInfoSettingCellId)
        table.register(UserInfoSettingHeaderView.self, forHeaderFooterViewReuseIdentifier: UserInfoSettingHeaderViewId)
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.dataList != nil else { return 0 }
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.dataList != nil else { return 0 }
        return self.dataList[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoSettingCellId, for: indexPath) as! UserInfoSettingCell
        
        let section = dataList[indexPath.section]
        let row = section.list[indexPath.row]
        
        cell.model = row

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        return 4
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserInfoSettingHeaderViewId) as? UserInfoSettingHeaderView
        
        header?.title.text = self.dataList[section].sectionTitle
        
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    private func getDataList() -> [SettingSectionModel]? {
        var dataList = [SettingSectionModel]()
        
        guard userInfo != nil else { return nil }
        var section1 = SettingSectionModel()
        section1.sectionTitle = "账户安全"
        
        var phone = SettingRowDataModel()
        phone.title = "手机认证"
        phone.detail = userInfo?.mobile
        section1.list.append(phone)
        
        var pass = SettingRowDataModel()
        pass.title = "登录密码"
        pass.detail = "设置密码"
        section1.list.append(pass)
        
        dataList.append(section1)
        
        return dataList
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
