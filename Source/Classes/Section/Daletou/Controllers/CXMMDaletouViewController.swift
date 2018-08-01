//
//  CXMMDaletouViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum DaletouType : String {
    case 标准选号 = "彩小秘 · 标准选号"
    case 胆拖选号 = "彩小秘 · 胆拖选号"
}

class CXMMDaletouViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouBottomView!

    private var type : DaletouType = .标准选号 {
        didSet{
            titleView.setTitle(type.rawValue, for: .normal)
        }
    }
    private var menu : CXMMDaletouMenu = CXMMDaletouMenu()
    private var titleView : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.delegate = self
        setNavigationTitleView()
        setTableview()
        setSubview()
    }

    private func setSubview() {
        self.view.addSubview(menu)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - MENU
extension CXMMDaletouViewController : CXMMDaletouMenuDelegate {
    
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        
        titleView.setTitle(type.rawValue, for: .normal)
        titleView.setTitleColor(Color505050, for: .normal)
        titleView.addTarget(self, action: #selector(titleViewClicked(_:)), for: .touchUpInside)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc private func titleViewClicked(_ sender: UIButton) {
        showMatchMenu()
    }
    
    private func showMatchMenu() {
        menu.configure(with: type)
        menu.show()
    }
    
    func didTipMenu(view: CXMMDaletouMenu, type: DaletouType) {
        
        self.type = type
    }
}

extension CXMMDaletouViewController {
    private func setTableview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
}

extension CXMMDaletouViewController : UITableViewDelegate {
    
}

extension CXMMDaletouViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            return initTitleCell(tableView, indexPath)
        case 1:
            return initStandardRedCell(tableView, indexPath)
        case 2:
            return initStandardBlueCell(tableView, indexPath)
        case 3:
            return initDanRedCell(tableView, indexPath)
        case 4:
            return initDragRedCell(tableView, indexPath)
        case 5:
            return initDanBlueCell(tableView, indexPath)
        case 6:
            return initDragBlueCell(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 40
        case 1:
            return 240 + 54 + 15
        case 2:
            return 117
        case 3:
            return 350
        case 4:
            return 300
        case 5:
            return 200
        case 6:
            return 200
        default:
            return 40
        }
    }
    
    private func initTitleCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouTitleCell", for: indexPath) as! DaletouTitleCell
        
        return cell
    }
    
    private func initStandardRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardRedCell", for: indexPath) as! DaletouStandardRedCell
        
        return cell
    }
    private func initStandardBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardBlueCell", for: indexPath) as! DaletouStandardBlueCell
        
        return cell
    }
    private func initDanRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanRedCell", for: indexPath) as! DaletouDanRedCell
        
        return cell
    }
    private func initDragRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragRedCell", for: indexPath) as! DaletouDragRedCell
        
        return cell
    }
    private func initDanBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanBlueCell", for: indexPath) as! DaletouDanBlueCell
        
        return cell
    }
    private func initDragBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragBlueCell", for: indexPath) as! DaletouDragBlueCell
        
        return cell
    }
    
    
}
