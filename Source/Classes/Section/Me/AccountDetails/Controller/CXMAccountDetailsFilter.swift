//
//  AccountDetailsFilter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum FilterTime: String {
    case 当天    = "1"
    case 最近一周 = "2"
    case 最近一月 = "3"
    case 最近三月 = "4"
    case 全部    = "0"
}

fileprivate let cellHeight: CGFloat = 50

protocol AccountDetailsFilterDelegate {
    func didSelect(time : FilterTime, title : String) -> Void
}

class CXMAccountDetailsFilter: BasePopViewController {

    public var delegate : AccountDetailsFilterDelegate!
    
    // MARK : - 属性 public

    public var filterList : [AccountDetailFilterModel]! {
        didSet{
            guard filterList != nil else { return }
            self.viewHeight = cellHeight * CGFloat(filterList.count)
            self.tableView.reloadData()
        }
    }
    
    // MARK : - 属性 private
    private var dateTitle : UILabel!
    private var backBut: UIButton!
    private var topLine : UIView!
    private var bottomLine : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        topLine.snp.makeConstraints { (make) in
//            make.left.right.equalTo(0)
//            make.height.equalTo(0.3)
//            make.bottom.equalTo(tableView.snp.top)
//        }
//        bottomLine.snp.makeConstraints { (make) in
//            make.top.equalTo(tableView.snp.bottom)
//            make.height.equalTo(0.3)
//            make.left.right.equalTo(0)
//        }
//        dateTitle.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(0)
//            make.bottom.equalTo(tableView.snp.top)
//        }
//        backBut.snp.makeConstraints { (make) in
//            make.top.equalTo(tableView.snp.bottom)
//            make.left.right.bottom.equalTo(0)
//        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    private func initSubview() {
        
        
//        topLine = UIView()
//        topLine.backgroundColor = ColorC8C8C8
//        bottomLine = UIView()
//        bottomLine.backgroundColor = ColorC8C8C8
//
//        dateTitle = UILabel()
//        dateTitle.font = Font13
//        dateTitle.textColor = Color787878
//        dateTitle.textAlignment = .center
//        dateTitle.text = "日期"
//
//        backBut = UIButton(type: .custom)
//        backBut.titleLabel?.font = Font13
//        backBut.setTitle("返回", for: .normal)
//        backBut.setTitleColor(ColorEA5504, for: .normal)
//        backBut.addTarget(self, action: #selector(backButClicked(_:)), for: .touchUpInside)
        
//        
//        self.pushBgView.addSubview(dateTitle)
//        self.pushBgView.addSubview(backBut)
//        
//        self.pushBgView.addSubview(topLine)
//        self.pushBgView.addSubview(bottomLine)
        
        self.pushBgView.addSubview(tableView)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.register(AccountDetailFilterCell.self, forCellReuseIdentifier: AccountDetailFilterCell.cellId)
        
        return table
    }()
    //MARK: - tableView dataSource
    
    
    
    
   
    
}

extension CXMAccountDetailsFilter : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for date in filterList {
            date.isSelected = false
        }
        guard delegate != nil else { return }
        let filterModel = filterList[indexPath.row]
        filterList[indexPath.row].isSelected = true
        delegate.didSelect(time: filterModel.filterTime, title: filterModel.date)
        self.dismiss(animated: true , completion: nil )
    }
}

extension CXMAccountDetailsFilter : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard filterList != nil else { return 0 }
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailFilterCell.cellId, for: indexPath) as! AccountDetailFilterCell
        cell.filterModel = filterList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
}
