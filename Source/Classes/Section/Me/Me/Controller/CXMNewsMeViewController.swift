//
//  NewsMeViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let meCellIdentifier = "meCellIdentifier"

class CXMNewsMeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate, MeFooterViewDelegate {
    func didTipLogin() {
        
    }
    
    func didTipUserIcon() {
        showPhotoSelect()
    }
    
    func rechargeClicked() {
        
    }
    
    func withdrawalClicked() {
        
    }
    
    func alertClicked() {
        
    }
    
    
    
    
    public var showType: ShowType!
    //MARK: - 属性
    private var headerView: NewsHeaderView!
    private var footerView: MeFooterView!
    private var userInfo  : UserInfoDataModel!
    
    private var photoSelect: YHPhotoSelect!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        self.navigationItem.title = "我的"
        self.view.addSubview(tableView)
        
        self.photoSelect = YHPhotoSelect(controller: self, delegate: self)
        
        self.photoSelect.isAllowEdit = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoRequest()
        self.isHidenBar = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 点击事件
    
    // footer delegate
    func signOutClicked() {
        print("退出登录")
        weak var weakSelf = self
        showCXMAlert(title: nil, message: "您正在退出登录", action: "继续退出", cancel: "返回") { (action) in
            weakSelf?.logoutRequest()
        }
        pushLoginVC(from: self)
        
    }
    
    
    
    
    //MARK: - tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = CXMMyCollectionVC()
        pushViewController(vc: collection)
        
    }
    //MARK: - 网络请求
    private func userInfoRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.userInfo)
            .asObservable()
            .mapObject(type: UserInfoDataModel.self)
            .subscribe(onNext: { (data) in
                guard weakSelf != nil else { return }
                weakSelf!.userInfo = data
                weakSelf!.headerView.userInfo = data
                weakSelf!.tableView.layoutIfNeeded()
                weakSelf!.tableView.reloadData()
                print(data)
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    // 退出登录
    private func logoutRequest() {
        weak var weakSelf = self
        _ = loginProvider.rx.request(.logout)
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.removeUserData()
                weakSelf?.pushRootViewController(2)
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(MeCell.self, forCellReuseIdentifier: meCellIdentifier)
        
        headerView = NewsHeaderView()
        //headerView.delegate = self
        
        footerView = MeFooterView()
        footerView.delegate = self
        
        table.tableHeaderView = headerView
        table.tableFooterView = footerView
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: meCellIdentifier, for: indexPath) as! MeCell
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.icon.image = UIImage(named: "nformationsecurity")
                cell.title.text = "我的收藏"
//            case 1:
//                cell.icon.image = UIImage(named: "our")
//                cell.title.text = "关于我们"
            default :
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - PhotoSelect Deleate
extension CXMNewsMeViewController: YHDPhotoSelectDelegate {
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
        
        self.headerView.setIcon(image: resultImg)
        
        let data = UIImagePNGRepresentation(resultImg)
        
        UserDefaults.standard.set(data, forKey: UserIconData)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserIconSetting), object: nil, userInfo: ["image" : resultImg] )
    }
    
    func yhdOptionalPhotoSelectDidCancelled(_ photoSelect: YHPhotoSelect!) {
        
    }
}
