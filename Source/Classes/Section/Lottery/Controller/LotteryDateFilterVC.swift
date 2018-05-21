//
//  LotteryDateFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let LotteryDateFilterCellId = "LotteryDateFilterCellId"

protocol LotteryDateFilterVCDelegate {
    func didSelectDateItem(filter : LotteryDateFilterVC, dateModel : LotteryDateModel ) -> Void
    
}

class LotteryDateFilterVC: BasePopViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : - 属性 public
    public var dateList : [LotteryDateModel]! {
        didSet{
            guard dateList != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    public var delegate : LotteryDateFilterVCDelegate!
    
    // MARK : - 属性 private
    private var dateTitle : UILabel!
    private var backBut: UIButton!
    private var topLine : UIView!
    private var bottomLine : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        initSubview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.3)
            make.bottom.equalTo(tableView.snp.top)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(0.3)
            make.left.right.equalTo(0)
        }
        dateTitle.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(tableView.snp.top)
        }
        backBut.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(36 * defaultScale)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-36 * defaultScale)
        }
    }
    
    private func initSubview() {
        self.viewHeight = 360 * defaultScale
        
        topLine = UIView()
        topLine.backgroundColor = ColorC8C8C8
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        dateTitle = UILabel()
        dateTitle.font = Font13
        dateTitle.textColor = Color787878
        dateTitle.textAlignment = .center
        dateTitle.text = "日期"
        
        backBut = UIButton(type: .custom)
        backBut.titleLabel?.font = Font13
        backBut.setTitle("返回", for: .normal)
        backBut.setTitleColor(ColorEA5504, for: .normal)
        backBut.addTarget(self, action: #selector(backButClicked(_:)), for: .touchUpInside)
        
        
        self.pushBgView.addSubview(dateTitle)
        self.pushBgView.addSubview(backBut)
        self.pushBgView.addSubview(tableView)
        self.pushBgView.addSubview(topLine)
        self.pushBgView.addSubview(bottomLine)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(LotteryDateFilterCell.self, forCellReuseIdentifier: LotteryDateFilterCellId)
        
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dateList != nil else { return 0 }
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryDateFilterCellId, for: indexPath) as! LotteryDateFilterCell
        cell.dateModel = dateList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36 * defaultScale
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for date in dateList {
            date.isSelected = false
        }
        guard delegate != nil else { return }
        dateList[indexPath.row].isSelected = true 
        delegate.didSelectDateItem(filter: self, dateModel: dateList[indexPath.row])
        self.dismiss(animated: true , completion: nil )
    }
    
    @objc private func backButClicked(_ sender: UIButton) {
        self.dismiss(animated: true , completion: nil )
    }
  
    @objc public override func backPopVC() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
