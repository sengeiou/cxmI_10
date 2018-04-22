//
//  NewsDetailViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import WebKit

fileprivate let NewsDetailCellId = "NewsDetailCellId"



class NewsDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NewsDetailCellDelegate {
    func upDateCellHeight(height: CGFloat) {
        
        //tableView.rowHeight = 1000
        self.cellHeight = height
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    
    // MARK: - 属性 public
    
    // MARK: - 属性 private
    private var collectBut: UIButton!    // 收藏
    private var shareBut: UIButton!      // 分享
    private var cellHeight : CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightItem()
        initSubview()
    }
    
    // MARK: - 点击事件
    
    @objc private func collectButClicked(_ sender: UIButton) {
        
    }
    @objc private func shareButClicked(_ sender: UIButton) {
        let share = ShareViewController()
        present(share)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    private func initSubview() {
        
        self.view.addSubview(tableView)
    }
    
    private func setRightItem() {
        collectBut = UIButton(type: .custom)
        collectBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        collectBut.setImage(UIImage(named: "Buysecurity"), for: .normal)
        collectBut.addTarget(self, action: #selector(collectButClicked(_:)), for: .touchUpInside)
        
        shareBut = UIButton(type: .custom)
        shareBut.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        shareBut.setTitle("分享", for: .normal)
        shareBut.setTitleColor(Color9F9F9F, for: .normal)
        shareBut.addTarget(self, action: #selector(shareButClicked(_:)), for: .touchUpInside)
        
        let collectItem = UIBarButtonItem(customView: collectBut)
        let shareItem = UIBarButtonItem(customView: shareBut)
        
        self.navigationItem.rightBarButtonItems = [shareItem, collectItem]
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(NewsDetailCell.self, forCellReuseIdentifier: NewsDetailCellId)
       
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section ==  0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsDetailCellId, for: indexPath) as! NewsDetailCell
            cell.delegate = self
            
            return cell
        }else {
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
