//
//  MeAboutViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let AboutCellId = "AboutCellId"

class MeAboutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    // MARK: - 点击事件
  
    
    // MARK: - 属性
   
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 关于我们"
        self.view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        //table.separatorStyle = .none
        
        table.separatorInset = UIEdgeInsets(top: 0, left: SeparatorLeftSpacing, bottom: 0, right: SeparatorLeftSpacing)
        
        let header = AboutHeader()
        let footer = AboutFooter()
        
        table.tableHeaderView = header
        table.tableFooterView = footer
        
        
        table.register(AboutCell.self, forCellReuseIdentifier: AboutCellId)
        
        return table
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.row {
        case 0:
            let complaint = MeComplaintVC()
            pushViewController(vc: complaint)
        case 1:
            let web = MeWebViewController()
            web.urlStr = webInsurance
            web.titleStr = "彩小秘 · 安全保障"
            pushViewController(vc: web)
        default: break
        
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutCellId, for: indexPath) as! AboutCell
        if indexPath.row == 0{
            cell.titleLB.text = "投诉建议"
        }else {
            cell.titleLB.text = "安全保障"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * defaultScale
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
