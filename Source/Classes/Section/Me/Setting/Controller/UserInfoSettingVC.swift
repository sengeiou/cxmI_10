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
    case 修改密码
    case 设置头像
    case 设置昵称
    case 待认证
    case 已认证
    case none
}

fileprivate let UserInfoSettingCellId = "UserInfoSettingCellId"
fileprivate let UserInfoSettingHeaderViewId = "UserInfoSettingHeaderViewId"
fileprivate let UserInfoIconCellId = "UserInfoIconCellId"

class UserInfoSettingVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    public var userInfo : UserInfoDataModel!
    
    private var dataList: [SettingSectionModel]!
    
    private var photoSelect: YHPhotoSelect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 个人信息"
        self.view.addSubview(tableView)
        
        self.dataList = getDataList()
        
        self.photoSelect = YHPhotoSelect(controller: self, delegate: self)
        
        self.photoSelect.isAllowEdit = true
        
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
        
        pushSettingVC(row.pushType)
    }
    
    private func pushSettingVC(_ model : UserInfoSettingPushType) {
        switch model {
        case .设置头像:
            self.showPhotoSelect()
            
        case .设置密码:
            let pass = SettingPasswordVC()
            pass.settingType = .设置
            pushViewController(vc: pass)
        case .修改密码:
            let pass = SettingPasswordVC()
            pass.settingType = .修改
            pushViewController(vc: pass)
        default: break
        }
    }
    
    private func showPhotoSelect() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let libraryAct = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            self.photoSelect.start(YHEPhotoSelectFromLibrary)
        }
        libraryAct.setValue(ColorA0A0A0, forKey: "titleTextColor")
        
        let cameraAct = UIAlertAction(title: "拍照", style: .default) { (action) in
            self.photoSelect.start(YHEPhotoSelectTakePhoto)
        }
        cameraAct.setValue(ColorA0A0A0, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        cancel.setValue(ColorEA5504, forKey: "titleTextColor")
        
        alertController.addAction(cameraAct)
        alertController.addAction(libraryAct)
        alertController.addAction(cancel)
        
        self.present(alertController)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(UserInfoSettingCell.self, forCellReuseIdentifier: UserInfoSettingCellId)
        table.register(UserInfoIconCell.self, forCellReuseIdentifier: UserInfoIconCellId)
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
        
        let section = dataList[indexPath.section]
        let row = section.list[indexPath.row]
        
        if row.pushType == .设置头像 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoIconCellId, for: indexPath) as! UserInfoIconCell

            cell.model = row
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoSettingCellId, for: indexPath) as! UserInfoSettingCell

            cell.model = row
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 44
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
        let section0 = SettingSectionModel()
        
        let userIcon = SettingRowDataModel()
        userIcon.title = "头像"
        userIcon.pushType = .设置头像
        section0.list.append(userIcon)
        
        let userName = SettingRowDataModel()
        userName.title = "昵称"
        userName.pushType = .设置昵称
        section0.list.append(userName)
        
        let section1 = SettingSectionModel()
        section1.sectionTitle = "账户安全"
        
        let phone = SettingRowDataModel()
        phone.title = "手机认证"
        phone.detail = userInfo?.mobile
        phone.pushType = .none
        section1.list.append(phone)
        
        let authentication = SettingRowDataModel()
        authentication.title = "身份认证"
        if userInfo.isReal {
            authentication.detail = userInfo.rankPoint
            authentication.pushType = .已认证
        }else {
            authentication.detail = "待认证"
            authentication.pushType = .待认证
        }
        section1.list.append(authentication)
        
        let pass = SettingRowDataModel()
        pass.title = "登录密码"
        userInfo.hasPass = false
        if userInfo.hasPass {
            pass.detail = "更改密码"
            pass.pushType = .修改密码
        }else {
            pass.detail = "请设置密码"
            pass.pushType = .设置密码
        }
        section1.list.append(pass)
        
        dataList.append(section0)
        dataList.append(section1)
        
        return dataList
    }

}

// MARK: - PhotoSelect Deleate
extension UserInfoSettingVC: YHDPhotoSelectDelegate {
    func imageFrom(image : UIImage, in rect: CGRect) -> UIImage {
        let sourceImageRef : CGImage = image.cgImage!
        
        let newImageRef = sourceImageRef.cropping(to: rect)
        
        return UIImage(cgImage: newImageRef!)
    }
    
    func yhdOptionalPhotoSelect(_ photoSelect: YHPhotoSelect!, didFinishedWithImageArray imageArray: [Any]!) {
        let img : UIImage = imageArray.last as! UIImage
        
        var resultImg = img
        
        if img.size.width != img.size.height {
            if img.size.width > img.size.height {
                let left : CGFloat = (img.size.width - img.size.height) / 2
                resultImg = self.imageFrom(image: img, in: CGRect(x: left, y: 0, width: img.size.height, height: img.size.height))
            }else if img.size.width < img.size.width {
                let top : CGFloat = (img.size.height - img.size.width) / 2
                resultImg = self.imageFrom(image: img, in: CGRect(x: 0, y: top, width: img.size.width, height: img.size.width))
            }
        }
        
        let section = dataList[0]
        let row = section.list[0]
        row.image = resultImg
        
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func yhdOptionalPhotoSelectDidCancelled(_ photoSelect: YHPhotoSelect!) {
        
    }
}


