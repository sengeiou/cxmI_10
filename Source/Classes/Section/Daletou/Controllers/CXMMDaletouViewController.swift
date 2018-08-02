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

    @IBOutlet weak var topMenu: UIButton!
    
    
    private var type : DaletouType = .标准选号 {
        didSet{
            titleView.setTitle(type.rawValue, for: .normal)
            self.tableView.reloadData()
        }
    }
    private var selectedRedSet : Set<DaletouDataModel> = Set<DaletouDataModel>()
    private var selectedBlueSet : Set<DaletouDataModel> = Set<DaletouDataModel>()
    private var selectedList : [DaletouDataModel] = [DaletouDataModel]()
    
    private var displayStyle : DLTDisplayStyle = .defStyle
    private var menu : CXMMDaletouMenu = CXMMDaletouMenu()
    private var titleView : UIButton!
    
   
    lazy private var danRedList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var dragRedList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var danBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    lazy private var dragBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.delegate = self
        bottomView.delegate = self
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


// MARK: - TOP Menu
extension CXMMDaletouViewController : YBPopupMenuDelegate{
    @IBAction func topMenuClick(_ sender: UIButton) {
        YBPopupMenu.showRely(on: sender, titles: ["走势图","玩法帮助","开奖结果","隐藏遗漏"],
                             icons: ["Trend","GameDescription","LotteryResult","Missing"],
                             menuWidth: 125, delegate: self)
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            if self.displayStyle == .defStyle {
                self.displayStyle = .omission
            }else if self.displayStyle == .omission {
                self.displayStyle = .defStyle
            }
            self.tableView.reloadData()
        default: break
        }
    }
}

// MARK: - 底部视图 代理
extension CXMMDaletouViewController : DaletouBottomViewDelegate {
    func didTipDelete() {
        showAlert()
    }
    
    func didTipConfirm() {
        
    }

    private func showAlert() {
        showCXMAlert(title: "温馨提示", message: "\n确定清空所选号码吗？",
                     action: "确定", cancel: "取消") { (action) in
            
        }
    }
}

// MARK: - PUSH
extension CXMMDaletouViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pushConfirm":
            let vc = segue.destination as! CXMMDaletouConfirmVC
            
            var arr = selectedRedSet.sorted{$0.number < $1.number}
            arr.append(contentsOf: selectedBlueSet.sorted{$0.number < $1.number})
            vc.dataList.insert(arr, at: 0)
            
        default: break
            
        }
    }
}

// MARK: - CELL DELEGATE
extension CXMMDaletouViewController : DaletouStandardRedCellDelegate,
                                        DaletouStandardBlueCellDelegate,
                                        DaletouDanRedCellDelegate,
                                        DaletouDanBlueCellDelegate,
                                        DaletouDragRedCellDelegate,
                                        DaletouDragBlueCellDelegate{
    
    func didSelect(cell: DaletouStandardRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertRedData(model: model)
    }
    
    func didSelect(cell: DaletouStandardBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertBlueData(model: model)
    }
    func didSelect(cell: DaletouDanRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertRedData(model: model)
        dragRedList[indexPath.row].selected = false
        dragRedList[indexPath.row].isselected.value = false
        
        
    }
    func didSelect(cell: DaletouDragRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertRedData(model: model)
        danRedList[indexPath.row].selected = false
        danRedList[indexPath.row].isselected.value = false
    }
    func didSelect(cell: DaletouDanBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertBlueData(model: model)
        dragBlueList[indexPath.row].selected = false
        self.tableView.reloadData()
    }
    func didSelect(cell: DaletouDragBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        insertBlueData(model: model)
        danBlueList[indexPath.row].selected = false
        self.tableView.reloadData()
    }
    
    
    private func insertRedData(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedRedSet.insert(model)
        case false:
            selectedRedSet.remove(model)
        }
    }
    private func insertBlueData(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedBlueSet.insert(model)
        case false:
            selectedBlueSet.remove(model)
        }
    }
}

extension CXMMDaletouViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                let history = CXMMDaletouHistoryAward()
                present(history)
            default: break
            }
        case .胆拖选号:
            break
        }
    }
}
// MARK: - 导航栏 title MENU
extension CXMMDaletouViewController : CXMMDaletouMenuDelegate {
    
    func didTipMenu(view: CXMMDaletouMenu, type: DaletouType) {
        
        self.type = type
    }
    
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        titleView.titleLabel?.font = Font17
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
extension CXMMDaletouViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .标准选号:
            return 3
        case .胆拖选号:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                return initTitleCell(tableView, indexPath)
            case 1:
                return initStandardRedCell(tableView, indexPath)
            case 2:
                return initStandardBlueCell(tableView, indexPath)
            default:
                return UITableViewCell()
            }
        case .胆拖选号:
            switch indexPath.row {
            case 0:
                return initDanRedCell(tableView, indexPath)
            case 1:
                return initDragRedCell(tableView, indexPath)
            case 2:
                return initDanBlueCell(tableView, indexPath)
            case 3:
                return initDragBlueCell(tableView, indexPath)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                return 40
            case 1:
                switch displayStyle {
                case .defStyle:
                    return DaletouStandardRedCell.cellHeight
                case .omission:
                    return DaletouStandardRedCell.omCellHeight
                }
            case 2:
                switch displayStyle {
                case .defStyle:
                    return DaletouStandardBlueCell.cellHeight
                case .omission:
                    return DaletouStandardBlueCell.omCellHeight
                }
            default:
                return 0
            }
        case .胆拖选号:
            switch indexPath.row {
            case 0:
                switch displayStyle {
                case .defStyle:
                    return DaletouDanRedCell.cellHeight
                case .omission:
                    return DaletouDanRedCell.omCellHeight
                }
            case 1:
                switch displayStyle {
                case .defStyle:
                    return DaletouDragRedCell.cellHeight
                case .omission:
                    return DaletouDragRedCell.omCellHeight
                }
            case 2:
                switch displayStyle {
                case .defStyle:
                    return DaletouDanBlueCell.cellHeight
                case .omission:
                    return DaletouDanBlueCell.omCellHeight
                }
            case 3:
                switch displayStyle {
                case .defStyle:
                    return DaletouDragBlueCell.cellHeight
                case .omission:
                    return DaletouDragBlueCell.omCellHeight
                }
            default:
                return 0
            }
        }
    }
    
    private func initTitleCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouTitleCell", for: indexPath) as! DaletouTitleCell
        
        return cell
    }
    
    private func initStandardRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardRedCell", for: indexPath) as! DaletouStandardRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        
        return cell
    }
    private func initStandardBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardBlueCell", for: indexPath) as! DaletouStandardBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        return cell
    }
    private func initDanRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanRedCell", for: indexPath) as! DaletouDanRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: danRedList)
        return cell
    }
    private func initDragRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragRedCell", for: indexPath) as! DaletouDragRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: dragRedList)
        return cell
    }
    private func initDanBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanBlueCell", for: indexPath) as! DaletouDanBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: danBlueList)
        return cell
    }
    private func initDragBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragBlueCell", for: indexPath) as! DaletouDragBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: dragBlueList)
        return cell
    }
    
    
}
