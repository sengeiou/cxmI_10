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

protocol CXMMDaletouViewControllerDelegate {
    func didSelected(list : DaletouDataList) -> Void
}

class CXMMDaletouViewController: BaseViewController {

    public var delegate : CXMMDaletouViewControllerDelegate!
   
    public var model : DaletouDataList? {
        didSet{
            guard let mod = model else { return }
            switch mod.type {
            case .标准选号:
                self.selectedRedSet.removeAll()
                self.selectedBlueSet.removeAll()
                for data in self.redList {
                    data.selected = false
                }
                for data in self.blueList {
                    data.selected = false
                }
                
                for data in mod.redList {
                    for data1 in self.redList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedRedSet.insert(data1)
                            break
                        }
                    }
                }
                for data in mod.blueList {
                    for data1 in self.blueList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedBlueSet.insert(data1)
                            break
                        }
                    }
                }
                
            case .胆拖选号:
                self.selectedDanRedSet.removeAll()
                self.selectedDragRedSet.removeAll()
                self.selectedDanBlueSet.removeAll()
                self.selectedDragBlueSet.removeAll()
                for data in mod.danRedList {
                    for data1 in self.danRedList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedDanRedSet.insert(data1)
                            break
                        }
                    }
                }
                for data in mod.dragRedList {
                    for data1 in self.dragRedList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedDragRedSet.insert(data1)
                            break
                        }
                    }
                }
                for data in mod.danBlueList {
                    for data1 in self.danBlueList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedDanBlueSet.insert(data1)
                            break
                        }
                    }
                }
                for data in mod.dragBlueList {
                    for data1 in self.dragBlueList {
                        if data.num == data1.num {
                            data1.selected = data.selected
                            self.selectedDragBlueSet.insert(data1)
                            break
                        }
                    }
                }
            }
        }
    }
    
    
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
                motion(edit: true)
            case .胆拖选号:
                settingNum.value = getBettingNum()
                motion(edit: false)
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
    
    private var omissionModel : DaletouOmissionModel!
   
    lazy private var redList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var blueList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    
    lazy private var danRedList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .danRed)
    }()
    lazy private var dragRedList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .dragRed)
    }()
    lazy private var danBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .danBlue)
    }()
    lazy private var dragBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .dragBlue)
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.delegate = self
        bottomView.delegate = self
        setNavigationTitleView()
        setTableview()
        setSubview()
        
        setData()
        print(danBettingNum(a: 2, b: 4, c: 1, d: 2))
        setDefaultData()
        loadNewData()
    }

    
    private func setDefaultData() {
        guard let mod = self.model else { return }
        self.type = mod.type
    }
    private func setData() {
        
        _ = settingNum.asObservable().subscribe(onNext: { (num) in
            if num > 0 {
                let att = NSMutableAttributedString(string: "共")
                let numAtt = NSAttributedString(string: "\(num)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let defa = NSAttributedString(string: "注 合计")
                let money = NSAttributedString(string: "\(num * 2)", attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                let yuan = NSAttributedString(string: "元")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                att.append(yuan)
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

// MARK: - public
extension CXMMDaletouViewController : DLTRandom {
    @IBAction func randomOne(_ sender: UIButton) {
        let model = getOneRandom()
        self.model = model
        self.tableView.reloadData()
    }
    public func configure(with data : [DaletouDataModel], type : DaletouType) {
        
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
        
            guard delegate != nil else { return }
            
            switch type {
            case .标准选号:
                let model = DaletouDataList()
                model.redList = getStandardReds()
                model.blueList = getStandardBlues()
                model.type = type
                model.getBettingNum()
                delegate.didSelected(list: model)
            case .胆拖选号:
                let model = DaletouDataList()
                model.danRedList = getDanReds()
                model.dragRedList = getDragReds()
                model.danBlueList = getDanBlues()
                model.dragBlueList = getDragBlues()
                model.type = type
                model.getBettingNum()
                delegate.didSelected(list: model)
            }
            self.popViewController()
            return
        }
        
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        
        let vc = story.instantiateViewController(withIdentifier: "CXMMDaletouConfirmVC") as! CXMMDaletouConfirmVC
        
        switch type {
        case .标准选号:
            let model = DaletouDataList()
            model.redList = getStandardReds()
            model.blueList = getStandardBlues()
            model.type = type
            model.getBettingNum()
            vc.list.append(model)
        case .胆拖选号:
            let model = DaletouDataList()
            model.danRedList = getDanReds()
            model.dragRedList = getDragReds()
            model.danBlueList = getDanBlues()
            model.dragBlueList = getDragBlues()
            model.type = type
            model.getBettingNum()
            vc.list.append(model)
        }
        
        pushViewController(vc: vc)
    }

    private func getStandardReds () -> [DaletouDataModel] {
        let arr = selectedRedSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getStandardBlues()-> [DaletouDataModel] {
        let arr = selectedBlueSet.sorted{$0.number < $1.number}
        return arr
    }
    
    private func getDanReds() -> [DaletouDataModel] {
        let arr = selectedDanRedSet.sorted{ $0.number < $1.number}
        return arr
    }
    private func getDragReds() -> [DaletouDataModel] {
        let arr = selectedDragRedSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getDanBlues() -> [DaletouDataModel] {
        let arr = selectedDanBlueSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getDragBlues() -> [DaletouDataModel] {
        let arr = selectedDragBlueSet.sorted{$0.number < $1.number}
        return arr
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
                self.danRedList = DaletouDataModel.getData(ballStyle: .danRed)
                self.dragRedList = DaletouDataModel.getData(ballStyle: .dragRed)
                self.danBlueList = DaletouDataModel.getData(ballStyle: .danBlue)
                self.dragBlueList = DaletouDataModel.getData(ballStyle: .dragBlue)
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

// MARK: - 摇一摇
extension CXMMDaletouViewController {
    private func motion(edit: Bool) {
        UIApplication.shared.applicationSupportsShakeToEdit = edit
        self.becomeFirstResponder()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        let model = getOneRandom()
        self.model = model
        self.tableView.reloadData()
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
    
}

// MARK: - 网络请求
extension CXMMDaletouViewController {
    private func loadNewData() {
        ticketInfoRequest()
    }
    
    private func ticketInfoRequest() {
        weak var weakSelf = self
        _ = dltProvider.rx.request(.tickenInfo)
            .asObservable()
            .mapObject(type: DaletouOmissionModel.self)
            .subscribe(onNext: { (data) in
                self.omissionModel = data
                
                for i in 0..<self.redList.count {
                    self.redList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.blueList.count {
                    self.blueList[i].omissionNum = self.omissionModel.postList[i]
                }
                for i in 0..<self.danRedList.count {
                    self.danRedList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.dragRedList.count {
                    self.dragRedList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.danBlueList.count {
                    self.danBlueList[i].omissionNum = self.omissionModel.postList[i]
                }
                for i in 0..<self.dragBlueList.count {
                    self.dragBlueList[i].omissionNum = self.omissionModel.postList[i]
                }
                
                self.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
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
        if self.omissionModel != nil {
            cell.configure(model: self.omissionModel)
        }
        return cell
    }
    
    private func initStandardRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardRedCell", for: indexPath) as! DaletouStandardRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: redList)
        if self.omissionModel != nil {
            cell.configure(model: self.omissionModel, display: self.displayStyle)
        }
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
