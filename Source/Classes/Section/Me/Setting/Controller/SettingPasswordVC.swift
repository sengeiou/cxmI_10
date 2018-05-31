//
//  SettingPasswordVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum SettingType : String {
    case 设置 = "彩小秘 · 设置登录密码"
    case 修改 = "彩小秘 · 修改登录密码"
}

fileprivate let SettingPasswordCellId = "SettingPasswordCellId"

class SettingPasswordVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, ValidatePro{

    public var settingType : SettingType!
    
   
    private var oldTF : UITextField!
    private var newTF : UITextField!
    private var confirmTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.title = settingType.rawValue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }

    // MARK: - 点击事件
    @objc private func confirmClicked(_ sender: UIButton) {
        if settingType == .设置 {
            guard validate(.password, str: self.newTF.text) else {
                showHUD(message: "请输入6-20位数字和字母组合的密码")
                return }
            guard self.newTF.text == self.confirmTF.text else {
                showHUD(message: "两次输入的密码不一致")
                return }
            
            
        }else {
            guard validate(.password, str: self.oldTF.text) else {
                showHUD(message: "请输入6-20位数字和字母组合的密码")
                return }
            guard validate(.password, str: self.newTF.text) else {
                showHUD(message: "请输入6-20位数字和字母组合的密码")
                return }
            guard self.newTF.text == self.confirmTF.text else {
                showHUD(message: "两次输入的密码不一致")
                return }
            
            
        }
    }
    
    // MARK: - 网络请求
    
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(SettingPasswordCell.self, forCellReuseIdentifier: SettingPasswordCellId)
        
        let footer = SettingPasswordFooter()
        footer.confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        if settingType == .设置 {
            footer.confirmBut.setTitle("确认设置", for: .normal)
        }else {
            footer.confirmBut.setTitle("确认修改", for: .normal)
        }
        
        table.tableFooterView = footer
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if settingType == .设置 {
            return 2
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingPasswordCellId, for: indexPath) as! SettingPasswordCell
        
        if settingType == .设置 {
            switch indexPath.row {
            case 0:
                self.newTF = cell.textField
                cell.title.text = "新密码"
                cell.textField.placeholder = "6-20位数字和字母组成"
            case 1:
                self.confirmTF = cell.textField
                cell.title.text = "确认密码"
                cell.textField.placeholder = "请再次输入登录密码"
            default : break
            }
        }else {
            switch indexPath.row {
            case 0:
                self.oldTF = cell.textField
                cell.title.text = "原密码"
                cell.textField.placeholder = "输入原密码"
            case 1:
                self.newTF = cell.textField
                cell.title.text = "新密码"
                cell.textField.placeholder = "输入新密码"
            case 2:
                self.confirmTF = cell.textField
                cell.title.text = "确认密码"
                cell.textField.placeholder = "请再次输入登录密码"
            default : break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 4
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
