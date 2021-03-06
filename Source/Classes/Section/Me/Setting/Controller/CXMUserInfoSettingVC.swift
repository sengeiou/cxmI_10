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

class CXMUserInfoSettingVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var userInfo : UserInfoDataModel!
    
    private var dataList: [SettingSectionModel]!
    
    private var photoSelect: YHPhotoSelect!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.view.addSubview(tableView)
        
        self.photoSelect = YHPhotoSelect(controller: self, delegate: self)
        
        self.photoSelect.isAllowEdit = true
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        
        if turnOn {
            self.dataList = getDataList()
        }else {
            self.dataList = getNewsDataList()
        }
        
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
        case .待认证:
            let authentication = CXMAuthenticationVC()
            authentication.delegate = self
            pushViewController(vc: authentication)
        case .已认证:
            break
        case .设置昵称:
            showUserNameSetting()
        case .设置密码:
            let pass = CXMSettingPasswordVC()
            pass.settingType = .设置
            pushViewController(vc: pass)
        case .修改密码:
            let pass = CXMSettingPasswordVC()
            pass.settingType = .修改
            pushViewController(vc: pass)
        default: break
        }
    }
    
    private func showUserNameSetting() {
        let alertController = UIAlertController(title: "给自己取一个喜欢的昵称", message: "昵称取好后不能再修改", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "请勿以手机号/真实姓名为昵称(2-15字符)"
            textField.font = Font12
        }
       
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            let text = alertController.textFields![0]
            
            
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        action.setValue(ColorEA5504, forKey: "titleTextColor")
        cancel.setValue(Color505050, forKey: "titleTextColor")
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        self.present(alertController)
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
        guard dataList != nil else { return 0 }
        let section = dataList[indexPath.section]
        let row = section.list[indexPath.row]
        
        if row.pushType == .设置头像 {
            return UserInfoIconCell.cellHeight
        }
        
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
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
    
    private func getNewsDataList() -> [SettingSectionModel]? {
        var dataList = [SettingSectionModel]()
        
        guard userInfo != nil else { return nil }
        let section0 = SettingSectionModel()
        
        let userIcon = SettingRowDataModel()
        userIcon.title = "头像"
        userIcon.pushType = .设置头像
        
        if let imageData = UserDefaults.standard.data(forKey: UserIconData) {
            if let image = UIImage(data: imageData) {
                userIcon.image = image
            }
        }
        
        section0.list.append(userIcon)
        
        let userName = SettingRowDataModel()
        userName.title = "昵称"
        userName.detail = userInfo.userName
        userName.pushType = .设置昵称
        section0.list.append(userName)
        
        let section1 = SettingSectionModel()
        section1.sectionTitle = "账户安全"
        
        let phone = SettingRowDataModel()
        phone.title = "手机认证"
        phone.detail = userInfo?.mobile
        phone.pushType = .none
        section1.list.append(phone)
        
//        let authentication = SettingRowDataModel()
//        authentication.title = "身份认证"
//        if userInfo.isReal {
//            authentication.detail = userInfo.rankPoint
//            authentication.pushType = .已认证
//        }else {
//            authentication.detail = "待认证"
//            authentication.pushType = .待认证
//        }
//        section1.list.append(authentication)
        
        let pass = SettingRowDataModel()
        pass.title = "登录密码"
        userInfo.hasPass = false
        pass.detailTextColor = ColorEA5504
        if userInfo.hasPass {
            pass.detail = "更改密码"
            pass.pushType = .修改密码
        }else {
            pass.detail = "请设置密码"
            pass.pushType = .设置密码
        }
        section1.list.append(pass)
        
        //dataList.append(section0)
        dataList.append(section1)
        
        return dataList
    }
    
    private func getDataList() -> [SettingSectionModel]? {
        var dataList = [SettingSectionModel]()
        
        guard userInfo != nil else { return nil }
        let section0 = SettingSectionModel()
        
        let userIcon = SettingRowDataModel()
        userIcon.title = "头像"
        userIcon.pushType = .设置头像
        
        if let imageData = UserDefaults.standard.data(forKey: UserIconData) {
            if let image = UIImage(data: imageData) {
                userIcon.image = image
            }
        }
        
        section0.list.append(userIcon)
        
        let userName = SettingRowDataModel()
        userName.title = "昵称"
        userName.detail = userInfo.userName
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
            authentication.detail = userInfo.realInfo
            authentication.pushType = .已认证
        }else {
            authentication.detail = "待认证"
            authentication.pushType = .待认证
            authentication.detailTextColor = ColorEA5504
        }
        section1.list.append(authentication)
        
        let pass = SettingRowDataModel()
        pass.title = "登录密码"
        pass.detailTextColor = ColorEA5504
        if userInfo.hasPass {
            pass.detail = "更改密码"
            pass.pushType = .修改密码
        }else {
            pass.detail = "请设置密码"
            pass.pushType = .设置密码
        }
        section1.list.append(pass)
        
        //dataList.append(section0)
        dataList.append(section1)
        
        return dataList
    }

}

// MARK: - PhotoSelect Deleate
extension CXMUserInfoSettingVC: YHDPhotoSelectDelegate {
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
        
        let data = resultImg.pngData()
        
        UserDefaults.standard.set(data, forKey: UserIconData)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserIconSetting), object: nil, userInfo: ["image" : resultImg] )
    }
    
    func yhdOptionalPhotoSelectDidCancelled(_ photoSelect: YHPhotoSelect!) {
        
    }
}

extension CXMUserInfoSettingVC : AuthenticationVCDelegate {
    func didAuthentication(vc: CXMAuthenticationVC) {
        userInfoRequest()
    }
    
    private func userInfoRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.userInfo)
            .asObservable()
            .mapObject(type: UserInfoDataModel.self)
            .subscribe(onNext: { (data) in
                guard weakSelf != nil else { return }
                weakSelf!.userInfo = data
                
                let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
                
                if turnOn {
                    self.dataList = self.getDataList()
                }else {
                    self.dataList = self.getNewsDataList()
                }
                
                weakSelf!.tableView.reloadData()
                
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(_, _):
                    break
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
}

