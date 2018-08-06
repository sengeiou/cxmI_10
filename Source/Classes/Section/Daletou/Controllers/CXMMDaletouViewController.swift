//
//  CXMMDaletouViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

enum DaletouType : String {
    case 标准选号 = "彩小秘 · 标准选号"
    case 胆拖选号 = "彩小秘 · 胆拖选号"
}

class CXMMDaletouViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouBottomView!

    @IBOutlet weak var topMenu: UIButton!
    
    public var isPush = false
    
    private var type : DaletouType = .标准选号 {
        didSet{
            titleView.setTitle(type.rawValue, for: .normal)
            
            switch type {
            case .标准选号:
                settingNum.value = getStandardBetNum()
            case .胆拖选号:
                settingNum.value = getBettingNum()
            }
            
            self.tableView.reloadData()
        }
    }
    
    

    private var settingNum = Variable(0)
    
    private var selectedRedSet = Set<DaletouDataModel>() {
        didSet{
            settingNum.value = getStandardBetNum()
        }
    }
    private var selectedBlueSet = Set<DaletouDataModel>() {
        didSet{
            settingNum.value = getStandardBetNum()
        }
    }
    
    private var selectedDanRedSet = Set<DaletouDataModel>() {
        didSet{
            settingNum.value = getBettingNum()
        }
    }
    private var selectedDragRedSet = Set<DaletouDataModel>()
    {
        didSet{
            settingNum.value = getBettingNum()
        }
    }
    private var selectedDanBlueSet = Set<DaletouDataModel>()
    {
        didSet{
            settingNum.value = getBettingNum()
        }
    }
    private var selectedDragBlueSet = Set<DaletouDataModel>()
    {
        didSet{
            settingNum.value = getBettingNum()
        }
    }
    
    private var selectedList : [DaletouDataModel] = [DaletouDataModel]()
    
    private var displayStyle : DLTDisplayStyle = .defStyle
    private var menu : CXMMDaletouMenu = CXMMDaletouMenu()
    private var titleView : UIButton!
    
   
    lazy private var redList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var blueList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    
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
        
        setData()
        print(danBettingNum(a: 2, b: 4, c: 1, d: 2))
        
    }

    private func setData() {
        
        _ = settingNum.asObservable().subscribe(onNext: { (num) in
            if num > 0 {
                let att = NSMutableAttributedString(string: "共")
                let numAtt = NSAttributedString(string: "\(num)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let defa = NSAttributedString(string: "注 合计")
                let money = NSAttributedString(string: "\(num * 2)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                self.bottomView.titleLabel.attributedText = att
                self.bottomView.confirmBut.backgroundColor = ColorE85504
                self.bottomView.confirmBut.isUserInteractionEnabled = true
            }else {
                let att = NSMutableAttributedString(string: "请至少选择")
                
                var red = 5
                if self.type == .胆拖选号 {
                    red = 6
                }
                
                let numAtt = NSAttributedString(string: "\(red)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let defa = NSAttributedString(string: "个红球")
                let money = NSAttributedString(string: "2", attributes: [NSAttributedStringKey.foregroundColor: Color0081CC])
                let defa1 = NSAttributedString(string: "个篮球")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                att.append(defa1)
                self.bottomView.titleLabel.attributedText = att
                self.bottomView.confirmBut.backgroundColor = ColorC7C7C7
                self.bottomView.confirmBut.isUserInteractionEnabled = false
            }
        }, onError: nil , onCompleted: nil , onDisposed: nil)
    }
    
    private func setSubview() {
        self.view.addSubview(menu)
    }
    
    
  
}


extension CXMMDaletouViewController : Algorithm {
    private func getStandardBetNum() -> Int {
        guard selectedRedSet.count >= 5, selectedBlueSet.count >= 2 else { return 0 }
        return standardBettingNum(m: selectedRedSet.count, n: selectedBlueSet.count)
    }
    private func getBettingNum() -> Int {
        
        guard match(danRedNum: selectedDanRedSet.count) else {
            return 0
        }
        guard match(dragRedNum: selectedDragRedSet.count) else {
            return 0
        }
        guard match(danBlueNum: selectedDanBlueSet.count) else {
            return 0
        }
        guard match(dragBlueNum: selectedDragBlueSet.count) else {
            return 0
        }
        guard selectedDanRedSet.count + selectedDragRedSet.count >= 6 else {
            return 0
        }
        return danBettingNum(a: selectedDanRedSet.count,
                             b: selectedDragRedSet.count,
                             c: selectedDanBlueSet.count,
                             d: selectedDragBlueSet.count)
    }
    

    private func match(danRedNum : Int) -> Bool {
        if danRedNum >= 1, danRedNum <= 4 {
            return true
        }else {
            return false
        }
    }
    
    private func match(dragRedNum : Int) -> Bool {
        return dragRedNum >= 2 ? true : false
    }
    
    private func match(danBlueNum: Int) -> Bool {
        return danBlueNum <= 1 ? true : false
    }
    private func match(dragBlueNum: Int) -> Bool {
        return dragBlueNum >= 2 ? true : false
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
        guard isPush == false else {
            self.popViewController()
            return
        }
        
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        
        let vc = story.instantiateViewController(withIdentifier: "CXMMDaletouConfirmVC") as! CXMMDaletouConfirmVC
        
        switch type {
        case .标准选号:
            vc.dataList = getStandardBalls()
            vc.bettingNumber = getStandardBetNum()
        case .胆拖选号:
            vc.dataList = getDanBalls()
            vc.bettingNumber = getBettingNum()
        }
        
        pushViewController(vc: vc)
    }

    private func getStandardBalls () -> [[DaletouDataModel]] {
        var list = [[DaletouDataModel]]()
        var arr = selectedRedSet.sorted{$0.number < $1.number}
        arr.append(contentsOf: selectedBlueSet.sorted{$0.number < $1.number})
        list.append(arr)
        return list
    }
    
    private func getDanBalls() -> [[DaletouDataModel]] {
        var list = [[DaletouDataModel]]()
        
        var arr = selectedDanRedSet.sorted{ $0.number < $1.number}
        let model1 = DaletouDataModel()
        model1.num = "-"
        model1.style = .red
        arr.append(model1)
        
        arr.append(contentsOf: selectedDragRedSet.sorted{$0.number < $1.number})
        if selectedDanBlueSet.count > 0 {
            arr.append(model1)
        }
        arr.append(contentsOf: selectedDanBlueSet.sorted{$0.number < $1.number})
        arr.append(model1)
        arr.append(contentsOf: selectedDragBlueSet.sorted{$0.number < $1.number})
        
        list.append(arr)
        return list
    }
    
    private func showAlert() {
        showCXMAlert(title: "温馨提示", message: "\n确定清空所选号码吗？",
                     action: "确定", cancel: "取消") { (action) in
            switch self.type {
            case .标准选号:
                self.redList = DaletouDataModel.getData(ballStyle: .red)
                self.blueList = DaletouDataModel.getData(ballStyle: .blue)
                self.selectedRedSet.removeAll()
                self.selectedBlueSet.removeAll()
                self.tableView.reloadData()
            case .胆拖选号:
                self.danRedList = DaletouDataModel.getData(ballStyle: .red)
                self.dragRedList = DaletouDataModel.getData(ballStyle: .red)
                self.danBlueList = DaletouDataModel.getData(ballStyle: .blue)
                self.dragBlueList = DaletouDataModel.getData(ballStyle: .blue)
                self.selectedDanRedSet.removeAll()
                self.selectedDragRedSet.removeAll()
                self.selectedDanBlueSet.removeAll()
                self.selectedDragBlueSet.removeAll()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - PUSH
extension CXMMDaletouViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "pushConfirm":
//            let vc = segue.destination as! CXMMDaletouConfirmVC
//            
//            var arr = selectedRedSet.sorted{$0.number < $1.number}
//            arr.append(contentsOf: selectedBlueSet.sorted{$0.number < $1.number})
//            vc.dataList.insert(arr, at: 0)
//            
//        default: break
//            
//        }
    }
}

// MARK: - CELL DELEGATE
extension CXMMDaletouViewController : DaletouStandardRedCellDelegate,
                                        DaletouStandardBlueCellDelegate,
                                        DaletouDanRedCellDelegate,
                                        DaletouDanBlueCellDelegate,
                                        DaletouDragRedCellDelegate,
                                        DaletouDragBlueCellDelegate{
    // 什么是胆拖？
    func didTipHelp() {
        
    }
    
    
    func didSelect(cell: DaletouStandardRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        model.selected = !model.selected
        insertRedData(model: model)
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func didSelect(cell: DaletouStandardBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        model.selected = !model.selected
        insertBlueData(model: model)
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDanRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDragRedSet.remove(dragRedList[indexPath.row])
        
        if selectedDanRedSet.count >= 0, selectedDanRedSet.count <= 3, model.selected == false {
            model.selected = !model.selected
        }else {
            model.selected = false
        }
        insertDanRed(model: model)
        dragRedList[indexPath.row].selected = false
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDragRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        model.selected = !model.selected
        insertDragRed(model: model)
        danRedList[indexPath.row].selected = false
        selectedDanRedSet.remove(danRedList[indexPath.row])
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDanBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDragBlueSet.remove(dragBlueList[indexPath.row])

        if selectedDanBlueSet.count <= 0, model.selected == false {
            model.selected = !model.selected
        }else {
            model.selected = false
        }
        
        insertDanBlue(model: model)
        dragBlueList[indexPath.row].selected = false
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDragBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDanBlueSet.remove(danBlueList[indexPath.row])
        model.selected = !model.selected
        insertDragBlue(model: model)
        danBlueList[indexPath.row].selected = false
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
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
    private func insertDanRed(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDanRedSet.insert(model)
           
        case false:
            selectedDanRedSet.remove(model)
            
        }
    }
    private func insertDragRed (model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDragRedSet.insert(model)
           
        case false:
            selectedDragRedSet.remove(model)
            
        }
    }
    private func insertDanBlue(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDanBlueSet.insert(model)
            
        case false:
            selectedDanBlueSet.remove(model)
           
        }
    }
    private func insertDragBlue(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDragBlueSet.insert(model)
            
        case false:
            selectedDragBlueSet.remove(model)
            
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
        cell.configure(with: redList)
        return cell
    }
    private func initStandardBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardBlueCell", for: indexPath) as! DaletouStandardBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: blueList)
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
