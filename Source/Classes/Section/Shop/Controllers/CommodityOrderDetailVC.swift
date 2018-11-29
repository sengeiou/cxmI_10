//
//  CommodityOrderDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityOrderDetailVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    
    private var nameTextField : UITextField!
    private var phoneTextField : UITextField!
    private var adressTextView : HHTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单详情"
        initSubview()
    }
    
    private func initSubview() {
        tableView.register(ComOrderHeaderFooter.self, forHeaderFooterViewReuseIdentifier: ComOrderHeaderFooter.identifier)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        adressTextView.resignFirstResponder()
    }
}

// MARK: -
extension CommodityOrderDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        adressTextView.resignFirstResponder()
    }
}
// MARK: - DataSource
extension CommodityOrderDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initOrderInfoCell(indexPath: indexPath)
        case 1:
            switch indexPath.row {
            case 2:
                return initOrderAdressCell(indexPath: indexPath)
            default :
                return initOrderInputCell(indexPath: indexPath)
            }
        case 2:
            return initOrderPriceCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ComOrderHeaderFooter.identifier) as! ComOrderHeaderFooter
        switch section {
        case 1:
            header.configure(title: "收货地址")
            return header
        case 2:
            header.configure(title: "结算明细")
            return header
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            switch indexPath.row {
            case 2:
                return 150
            default :
                return 50
            }
        default:
            return 60
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    private func initOrderInfoCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderInfoCell", for: indexPath) as! ComOrderInfoCell
        
        return cell
    }
    private func initOrderInputCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderInputCell", for: indexPath) as! ComOrderInputCell
        switch indexPath.row {
        case 0:
            cell.title.text = "收件人"
            cell.textField.placeholder = "请输入姓名"
            nameTextField = cell.textField
        default:
            cell.title.text = "联系电话"
            cell.textField.placeholder = "请输入联系电话"
            phoneTextField = cell.textField
        }
        return cell
    }
    private func initOrderAdressCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderAdressCell", for: indexPath) as! ComOrderAdressCell
        adressTextView = cell.textView
        return cell
    }
    private func initOrderPriceCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderPriceCell", for: indexPath) as! ComOrderPriceCell
        switch indexPath.row {
        case 0:
            cell.title.text = "商品数量"
        default:
            cell.title.text = "商品总价"
        }
        return cell
    }
}
