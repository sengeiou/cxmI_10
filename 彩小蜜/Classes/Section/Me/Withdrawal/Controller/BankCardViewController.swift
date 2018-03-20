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
        bankCardDefaultRequest(cardId: bankInfo.userBankId)
    }
    func deleteCard() {
        
    }
    
    // tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - 属性
    
    private var bankCardList: [BankCardInfo]!
    //MARK: - 懒加载
    lazy private var tableview : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        table.register(BankCardCell.self, forCellReuseIdentifier: bankCardIdentifier)
        
        let footer = BankCardFooterView()
        footer.delegate = self
        table.tableFooterView = footer
        
        return table
    }()
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
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
        _ = userProvider.rx.request(.bankList)
        .asObservable()
        .mapArray(type: BankCardInfo.self)
        .subscribe(onNext: { (data) in
            print(data)
            self.bankCardList = data
            self.tableview.reloadData()
        }, onError: { (error) in
            guard let err = error as? HXError else { return }
            switch err {
            case .UnexpectedResult(let code, let msg):
                print(code!)
                self.showHUD(message: msg!)
            default: break
            }
        }, onCompleted: nil, onDisposed: nil)
    }
    // 设置默认银行卡
    private func bankCardDefaultRequest(cardId: String) {
        weak var weakSelf = self
        _ = userProvider.rx.request(.setBankDefault(cardId: cardId))
        .asObservable()
        .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                guard weakSelf != nil else { return }
                weakSelf?.showHUD(message: data.msg)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    
    
    //MARK: - UI
    private func initSubview() {
        
    }
    // tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.bankCardList != nil else { return 0 }
        return self.bankCardList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bankCardIdentifier, for: indexPath) as! BankCardCell
        cell.delegate = self
        cell.bankInfo = self.bankCardList[indexPath.section]
        return cell 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BankCardCell.height()
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
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
