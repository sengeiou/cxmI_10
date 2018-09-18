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
    case 胜分差
    case 让分胜负
    case 混合投注
}

class CXMMBasketballVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var deleteBut : UIButton!
    @IBOutlet weak var selectNum : UILabel!
    @IBOutlet weak var confirmBut: UIButton!
    
    private var type : BasketballPlayType = .胜分差
    
    private var menu : CXMMBasketballMenu = CXMMBasketballMenu()
    public var titleView : UIButton!
    public var titleIcon : UIImageView!
    
    private var matchList : [BasketballMatchModel] = [BasketballMatchModel]()
    
    // MARK : - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubview()
    }

    private func initSubview() {
        menu.delegate = self
        setNavigationTitleView()
        self.view.addSubview(menu)
        tableView.separatorStyle = .none
        
        tableView.register(BasketBallHotSectionHeader.self,
                           forHeaderFooterViewReuseIdentifier: BasketBallHotSectionHeader.identifier)
        tableView.register(BasketBallSectionHeader.self,
                           forHeaderFooterViewReuseIdentifier: BasketBallSectionHeader.identifier)
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
// MARK: - header 点击事件
extension CXMMBasketballVC: BasketBallHotSectionHeaderDelegate,
                            BasketBallSectionHeaderDelegate {
    
    func spreadHot(sender: UIButton, section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func spread(sender: UIButton, section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
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
        
        
        switch type {
        case .混合投注:
            return initHunheCell(indexPath: indexPath)
        case .胜负:
            return initShengfuCell(indexPath: indexPath)
        case .让分胜负:
            return initRangFenCell(indexPath: indexPath)
        case .大小分:
            return initDaXiaoFenCell(indexPath: indexPath)
        case .胜分差:
            return initShengFenChaCell(indexPath: indexPath)
            
        }
        
        
    }
    
    // MARK: - Cell
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballHunheCell", for: indexPath) as! BasketballHunheCell
        cell.sfHomeTeam.titleLabel?.numberOfLines = 2
        
        let att = NSMutableAttributedString(string: "客胜")
        let sco = NSAttributedString(string: "\n1.22", attributes: [NSAttributedStringKey.foregroundColor: ColorF4F4F4])
        
        att.append(sco)
        
        cell.sfHomeTeam.setAttributedTitle(att, for: .normal)
        return cell
    }
    // 胜负
    private func initShengfuCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballShengfuCell", for: indexPath) as! BasketballShengfuCell
        
        cell.visiOdds.titleLabel?.numberOfLines = 2
        let att = NSMutableAttributedString(string: "客胜")
        let sco = NSAttributedString(string: "\n1.22", attributes: [NSAttributedStringKey.foregroundColor: ColorF4F4F4])
        
        att.append(sco)
        
        cell.visiOdds.setAttributedTitle(att, for: .normal)
        
        return cell
    }
    // 让分胜负
    private func initRangFenCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballRangCell", for: indexPath) as! BasketballRangCell
    
        
        return cell
    }
    // 大小分
    private func initDaXiaoFenCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballDaxiaofenCell", for: indexPath) as! BasketballDaxiaofenCell
        
        return cell
    }
    // 胜分差
    private func initShengFenChaCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketballShengfuChaCell", for: indexPath) as! BasketballShengfuChaCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BasketBallHotSectionHeader.identifier) as! BasketBallHotSectionHeader
            header.tag = section
            header.delegate = self
            
            return header
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BasketBallSectionHeader.identifier) as! BasketBallSectionHeader
            header.tag = section
            header.delegate = self
            
            return header
        }

    }
}

extension CXMMBasketballVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch type {
        case .混合投注:
            return 220
        case .胜负:
            return 130
        case .让分胜负:
            return 130
        case .大小分:
            return 130
        case .胜分差:
            return 90
        
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
// MARK: - title view
extension CXMMBasketballVC : CXMMBasketballMenuDelegate{
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
    
    func didTipMenu(view: CXMMBasketballMenu, type: BasketballPlayType) {
        titleIcon.image = UIImage(named: "Down")
        
        // TODO: "处理，选择menu 项的逻辑"
        
        self.tableView.reloadData()
        
        self.type = type
    }
    
    func didCancel() {
        titleIcon.image = UIImage(named: "Down")
    }
}
