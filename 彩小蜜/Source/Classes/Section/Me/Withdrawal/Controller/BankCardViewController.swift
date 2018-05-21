//
//  BankCardViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BankCardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, BankCardFooterViewDelegate, BankCardCellDelegate {
    
    
    //MARK: - 点击事件
    func addNewBankCard() {
        let add = AddNewBankCardVC()
        pushViewController(vc: add)
    }
    
    //MARK: - BankCardCellDelegate
    func settingDefaultCard(_ bankInfo: BankCardInfo) {
        guard bankInfo.status == "0" else { return } // 只有非默认卡(0)才可更改设置
        guard let bankId = bankInfo.userBankId else { return }
        bankCardDefaultRequest(cardId: bankId)
    }
    func deleteCard(bankInfo: BankCardInfo) {
        weak var weakSelf = self
        
        if bankInfo.status == "1" {
            let str = """
                        这张卡为默认收款卡，
                          您确认要删除吗？
                      """
            showCXMAlert(title: nil , message: str, action: "删除", cancel: "返回") { (action) in
                weakSelf?.deleteBankCardRequest(status: bankInfo.status, cardId: bankInfo.userBankId)
            }
        }else {
            showCXMAlert(title: nil , message: "请确认删除这张银行卡", action: "删除", cancel: "返回") { (action) in
                weakSelf?.deleteBankCardRequest(status: bankInfo.status, cardId: bankInfo.userBankId)
            }
        }

    }
    
    // tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - 属性
    
    private var bankCardList: [BankCardInfo]!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 管理银行卡"
        initSubview()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        bankListRequest()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    //MARK: - 网络请求
    private func bankListRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.bankList)
        .asObservable()
        .mapArray(type: BankCardInfo.self)
        .subscribe(onNext: { (data) in
            self.dismissProgressHud()
            print(data)
            self.bankCardList = data
            self.tableview.reloadData()
        }, onError: { (error) in
            self.dismissProgressHud()
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
    // 设置默认银行卡
    private func bankCardDefaultRequest(cardId: String) {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.setBankDefault(cardId: cardId))
        .asObservable()
        .mapBaseObject(type: DataModel.self)
        .subscribe(onNext: { (data) in
            self.dismissProgressHud()
            guard weakSelf != nil else { return }
            weakSelf?.showHUD(message: data.msg)
            weakSelf?.bankListRequest()
        }, onError: { (error) in
            self.dismissProgressHud()
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
    // 删除银行卡
    private func deleteBankCardRequest(status: String, cardId: String) {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.deleteBank(status: status, cardId: cardId))
        .asObservable()
        .mapObject(type: BankCardInfo.self)
        .subscribe(onNext: { (data) in
            self.dismissProgressHud()
            if data.userBankId == nil {
                weakSelf?.showHUD(message: data.showMsg)
                weakSelf?.bankListRequest()
            }else {
                guard data.lastCardNo4 != nil else {
                    weakSelf?.showCXMAlert(title: "删除成功！", message: "", action: "知道了", cancel: nil, confirm: { (action) in
                        weakSelf?.bankListRequest()
                    })
                    return }
                
                let attStr = NSMutableAttributedString(string: "默认收款卡已设置为", attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0])
                
                let bankCardNo = NSAttributedString(string: "尾号为\(data.lastCardNo4!)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                let 的 = NSAttributedString(string: "的", attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0])
                let cardName = NSAttributedString(string: data.bankName, attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                attStr.append(bankCardNo)
                attStr.append(的)
                attStr.append(cardName)
                
                weakSelf?.showCXMAlert(title: "删除成功！", message: attStr, action: "知道了", cancel: nil, confirm: { (action) in
                    weakSelf?.bankListRequest()
                })
            }
            
            
        }, onError: { (error) in
            self.dismissProgressHud()
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
    
    //MARK: - UI
    private func initSubview() {
        self.view.addSubview(tableview)
    }
    //MARK: - 懒加载
    lazy private var tableview : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(BankCardCell.self, forCellReuseIdentifier: bankCardIdentifier)
        
        let footer = BankCardFooterView()
        footer.delegate = self
        table.tableFooterView = footer
        
        return table
    }()
    // tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.bankCardList != nil else { return 0 }
        return self.bankCardList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bankCardIdentifier, for: indexPath) as! BankCardCell
        cell.delegate = self
        cell.bankInfo = self.bankCardList[indexPath.row]
        return cell 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BankCardCell.height()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
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
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
