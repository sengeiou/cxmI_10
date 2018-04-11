//
//  CouponFilterViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//  选取优惠券

import UIKit

fileprivate let CouponFilterCellId = "CouponFilterCellId"

class CouponFilterViewController: BasePopViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var topLine : UIView!
    private var bottomLine : UIView!
    private var titlelb : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(50 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(bottomLine.snp.top)
            make.left.right.equalTo(0)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(-44 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        titlelb.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(topLine.snp.top)
            make.left.right.equalTo(0)
        }
        
    }
    // MARK: - 初始化
    private func initSubview() {
        self.viewHeight = 350 * defaultScale
        
        topLine = UIView()
        topLine.backgroundColor = ColorC8C8C8
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        titlelb = UILabel()
        titlelb.font = Font24
        titlelb.textColor = Color9F9F9F
        titlelb.textAlignment = .center
        titlelb.text = "可用优惠券"
        
        self.pushBgView.addSubview(topLine)
        self.pushBgView.addSubview(bottomLine)
        self.pushBgView.addSubview(titlelb)
        self.pushBgView.addSubview(tableView)
        
        
        
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(CouponFilterCell.self, forCellReuseIdentifier: CouponFilterCellId)
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponFilterCellId, for: indexPath) as! CouponFilterCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
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
        
    }
    

    

}
