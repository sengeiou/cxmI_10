//
//  CouponFilterViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//  选取优惠券

import UIKit

fileprivate let CouponFilterCellId = "CouponFilterCellId"

protocol CouponFilterViewControllerDelegate {
    func didSelected(bonus bonusId : String) -> Void
}

class CouponFilterViewController: BasePopViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var bonusList: [BonusInfoModel]!
    
    public var delegate : CouponFilterViewControllerDelegate!
    
    private var bonusId : String!
    
    private var topLine : UIView!
    private var bottomLine : UIView!
    private var titlelb : UILabel!
    private var confirmBut: UIButton!
    private var selectedIndex : IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
        
        setEmpty(title: "暂无可用优惠券", tableView)
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(50 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(0.3)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(bottomLine.snp.top)
            make.left.right.equalTo(0)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(-(44 * defaultScale + SafeAreaBottomHeight))
            make.left.right.equalTo(0)
            make.height.equalTo(topLine)
        }
        titlelb.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(topLine.snp.top)
            make.left.right.equalTo(0)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(44 * defaultScale)
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
        
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确定", for: .normal)
        confirmBut.setTitleColor(ColorEA5504, for: .normal)
        confirmBut.backgroundColor = ColorFFFFFF
        confirmBut.titleLabel?.font = Font13
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.pushBgView.addSubview(topLine)
        self.pushBgView.addSubview(bottomLine)
        self.pushBgView.addSubview(titlelb)
        self.pushBgView.addSubview(tableView)
        self.pushBgView.addSubview(confirmBut)
        
        
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
        guard bonusList != nil, bonusList.isEmpty == false else { return 0 }
        return bonusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponFilterCellId, for: indexPath) as! CouponFilterCell
        
        let bonusInfo = bonusList[indexPath.row]
        cell.bonusInfo = bonusInfo
        
        if bonusInfo.isSelected == true {
            self.bonusId = bonusInfo.userBonusId
            //bonusInfo.isSelected = true
            self.tableView.selectRow(at: indexPath, animated: true , scrollPosition: .none)
            //self.selectedIndex = indexPath
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 * defaultScale
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
        let bonus = bonusList[indexPath.row]
        self.bonusId = bonus.userBonusId
//
//        bonus.isSelected = !bonus.isSelected
//        
//        if bonus.isSelected {
//            self.bonusId = bonus.userBonusId
//            for bonuss in bonusList {
//                if bonuss.userBonusId != bonus.userBonusId {
//                     bonuss.isSelected = false
//                }
//            }
//        }else {
//            self.bonusId = "-1"
//        }
        
        //tableView.reloadData()
    }
    
    // MARK: - 点击事件
  
    @objc public override func backPopVC() {
        
    }
    
    @objc private func confirmClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil )
        guard delegate != nil, self.bonusId != nil else { return }
        delegate.didSelected(bonus: self.bonusId)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
