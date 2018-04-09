//
//  PanmentViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let PaymentCellId = "PaymentCellId"

class PanmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var confirmBut : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.bottom.equalTo(confirmBut.snp.top)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(44 * defaultScale)
            make.bottom.equalTo(-SafeAreaTopHeight)
        }
    }
    private func initSubview() {
        self.view.addSubview(tableView)
        initBottowView()
    }
    private func initBottowView() {
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确认支付", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.titleLabel?.font = Font15
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(confirmBut)
    }
    // MARK: 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(PaymentCell.self, forHeaderFooterViewReuseIdentifier: PaymentCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCellId, for: indexPath) as! PaymentCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.title.text = "订单金额"
                cell.detail.text = "¥ 30.00"
            case 1:
                cell.title.text = "余额抵扣"
                cell.detail.text = "¥ 30.00"
            case 2:
                cell.title.text = "优惠券抵扣"
                cell.detail.text = "¥ 30.00"
            case 3:
                cell.title.text = "还需支付"
                cell.detail.text = "¥ 30.00"
            default: break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cell.title.text = "订单金额"
                cell.detail.text = "¥ 30.00"
            case 1:
                cell.title.text = "订单金额"
                cell.detail.text = "¥ 30.00"
            default: break
            }
        default: break
            
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
    
    // MARK : - 点击时间
    @objc private func confirmClicked(_ sender: UIButton) {
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
