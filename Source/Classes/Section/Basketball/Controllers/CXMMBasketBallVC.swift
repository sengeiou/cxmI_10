//
//  CXMMBasketballVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum BasketballPlayType : String {
    case 胜负
    case 大小分
    case 胜负差
    case 让分胜负
    case 混合投注
}

class CXMMBasketballVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var deleteBut : UIButton!
    @IBOutlet weak var selectNum : UILabel!
    @IBOutlet weak var confirmBut: UIButton!
    
    private var type : BasketballPlayType = .混合投注
    
    private var menu : CXMMBasketballMenu = CXMMBasketballMenu()
    public var titleView : UIButton!
    public var titleIcon : UIImageView!
    
    // MARK : - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubview()
    }

    private func initSubview() {
        setNavigationTitleView()
        tableView.separatorStyle = .none
    }

}
// MARK: - 网络请求
extension CXMMBasketballVC {
    private func loadNewData() {
        
    }
    private func basketballRequest() {
        
    }
}

// MARK: - 删除、确认，点击事件
extension CXMMBasketballVC {
    @IBAction func didTipConfirmButton(_ sender : UIButton) {
        
    }
    
    @IBAction func didTipDeleteButton(_ sender : UIButton) {
        
    }
}

// MARK: - tableview delegate
extension CXMMBasketballVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - tableview DataSource
extension CXMMBasketballVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        //return initHunheCell(indexPath: indexPath)
    }
    
    // MARK: - Cell
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }
    
}

extension CXMMBasketballVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
// MARK: - title view
extension CXMMBasketballVC {
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        titleView.titleLabel?.font = Font17
        titleView.setTitle(type.rawValue, for: .normal)
        titleView.setTitleColor(Color505050, for: .normal)
        
        titleView.addTarget(self, action: #selector(titleViewClicked(_:)), for: .touchUpInside)
        
        self.navigationItem.titleView = titleView
        titleIcon = UIImageView(image: UIImage(named: "Down"))
        
        titleView.addSubview(titleIcon)
        
        titleIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.right.equalTo(14)
            make.centerY.equalTo(titleView.snp.centerY)
        }
    }
    
    @objc private func titleViewClicked(_ sender: UIButton) {
        showMatchMenu()
        titleIcon.image = UIImage(named: "Upon")
    }
    
    private func showMatchMenu() {
        menu.configure(with: type)
        menu.show()
    }
    func didTipMenu(view: CXMMFootballMatchMenu, type: BasketballPlayType) {
        
        titleIcon.image = UIImage(named: "Down")
        
        // TODO: "处理，选择menu 项的逻辑"
        
        self.tableView.reloadData()
        
        self.type = type
        
        
    }
    func didCancel() {
        titleIcon.image = UIImage(named: "Down")
    }
}
