//
//  DaletouConfirmViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMDaletouConfirmVC: BaseViewController {

    public var list = [DaletouDataList]() {
        didSet{
            //self.dataList.removeAll()
            bettingNum.onNext(0)
            var num = 0
            for model in list {
                switch model.type {
                case .标准选号:
                    var arr = model.redList
                    arr.append(contentsOf: model.blueList)
                case .胆拖选号:
                    var arr = model.danRedList
                    
                    let model1 = DaletouDataModel()
                    model1.num = "-"
                    model1.style = .red
                    arr.append(model1)
                    
                    arr.append(contentsOf: model.dragRedList)
                    if model.danBlueList.count > 0 {
                        arr.append(model1)
                    }
                    arr.append(contentsOf: model.danBlueList)
                    arr.append(model1)
                    arr.append(contentsOf: model.dragBlueList)
                }
                
                num += model.bettingNum
                if let money = try? self.money.value() {
                    model.money = money
                }
                if let muti = try? self.multiple.value() {
                    model.multiple = muti
                }
            }
            if let value = try? bettingNum.value() {
                bettingNum.onNext( value + num)
            }
        }
    }
    
    public var isAppendSubject = BehaviorSubject(value: false)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouConfirmBottom!
    
    //private var money = 2
    private var isAppend = false // 是否追加
    
    private var bettingNum = BehaviorSubject(value: 0)
    public var multiple = BehaviorSubject(value: 1)
    private var money = BehaviorSubject(value: 2)
    private var agreement = BehaviorSubject(value: true)
    
    private var pushIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模拟投注"
        self.bottomView.delegate = self
        self.tableView.reloadData()
        
//        settingData()
        initSubview()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingData()
    }
    private func settingData() {
        _ = Observable.combineLatest(bettingNum, multiple, money, agreement)
            .asObservable()
            .subscribe(onNext: { (num, multiple, money, agreement) in
                guard agreement else { // 需要同意协议，方可购买
                    self.bottomView.confirmBut.backgroundColor = ColorC7C7C7
                    self.bottomView.confirmBut.isUserInteractionEnabled = false
                    return
                }
                self.bottomView.confirmBut.backgroundColor = ColorE85504
                self.bottomView.confirmBut.isUserInteractionEnabled = true
                
                let att = NSMutableAttributedString(string: "\(num)注\(multiple)倍 共需: ")
                
                let money = NSAttributedString(string: "\(num * money * multiple).00",
                    attributes: [NSAttributedStringKey.foregroundColor: ColorE85504])
                att.append(money)
                self.bottomView.moneyLabel.attributedText = att
                self.bottomView.multipleBut.setTitle("倍数 \(multiple)倍", for: .normal)
            }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = multiple.asObserver().subscribe(onNext: { (multiple) in
            for model in self.list {
                model.multiple = multiple
            }
            self.tableView.reloadData()
        }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = money.asObserver().subscribe(onNext: { (money) in
            for model in self.list {
                model.money = money
            }
            self.tableView.reloadData()
        }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = isAppendSubject.asObserver().subscribe(onNext: { (isAppend) in
            self.bottomView.appendBut.isSelected = isAppend
            self.isAppend = isAppend
            switch isAppend {
            case true:
                for model in self.list {
                    model.money = 3
                }
                self.money.onNext(3)
            case false :
                for model in self.list {
                    model.money = 2
                }
                self.money.onNext(2)
            }
        }, onError: nil , onCompleted: nil , onDisposed: nil )
    }

    private func initSubview() {
        let foot = FootballOrderFooter()
        foot.delegate = self
        self.tableView.tableFooterView = foot
    }
    
    override func back(_ sender: UIButton) {
        showCXMAlert(title: "温馨提示", message: "返回将清空所选号码,确定返回？", action: "确定", cancel: "取消", confirm: { (action) in
            self.popViewController()
        }) { (action) in
            
        }
    }
}

// MARK: - 手动添加，，机选，，
extension CXMMDaletouConfirmVC : DLTRandom {
    @IBAction func addDaletou(_ sender: UIButton) {
        pushDaletouBetting(indexPath: nil, ispush: true)
    }
    @IBAction func machineOne(_ sender: UIButton) {
        let model = getOneRandom()
        self.list.append(model)
        self.tableView.reloadData()
    }
    @IBAction func machineFive(_ sender: UIButton) {
        let models = getFiveRandom()
        self.list.append(contentsOf: models)
        self.tableView.reloadData()
    }
    
}

// MARK: - 网络请求
extension CXMMDaletouConfirmVC {
    private func saveBetInfoRequest(model : DLTBetInfoRequestModel) {
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.setInfo(model: model))
            .asObservable()
            .mapObject(type: SaveBetInfoModel.self)
            .subscribe(onNext: { (data) in
                if data.payToken != "" {
                    weakSelf?.changeConfirmButton(canTip: true)
                    let vc = CXMPaymentViewController()
                    vc.lottoToken = data.payToken
                    self.pushViewController(vc: vc)
                }else {
                    let story = UIStoryboard(name: "Daletou", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "DaletouOrderVC") as! CXMMDaletouOrderVC
                    vc.orderId = data.orderId
                    self.pushViewController(vc: vc)
                }
            }, onError: { (error) in
                weakSelf?.changeConfirmButton(canTip: true)
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
            }, onCompleted: nil , onDisposed: nil )
    }
}

// MARK: - 底部 视图  代理
extension CXMMDaletouConfirmVC : DaletouConfirmBottomDelegate, FootballTimesFilterVCDelegate {
    func didTipAppend(isAppend : Bool) {
        self.isAppend = isAppend
        switch isAppend {
        case true:
            for model in list {
                model.money = 3
            }
            self.money.onNext(3)
        case false :
            for model in list {
                model.money = 2
            }
            self.money.onNext(2)
        }
    }
    // MARK: - 选取倍数
    func didTipMultiple() {
        let filter = CXMFootballTimesFilterVC()
        filter.delegate = self
        filter.times = "\(try! self.multiple.value())"
        self.present(filter)
    }
    // MARK: - 投注确认按钮
    func didTipConfirm() {
        
        changeConfirmButton(canTip: false)
        
        let model = DLTBetInfoRequestModel.getRequestModel(list: list, isAppend: self.isAppend)
        
        self.saveBetInfoRequest(model: model)
        
        print( model)
    }
    
    func timesConfirm(times: String) {
        self.multiple.onNext(Int(times)!)
        self.tableView.reloadData()
    }
    
    private func changeConfirmButton( canTip : Bool) {
        switch canTip {
        case true:
            self.bottomView.confirmBut.isUserInteractionEnabled = true
            self.bottomView.confirmBut.backgroundColor = ColorE85504
        case false:
            self.bottomView.confirmBut.isUserInteractionEnabled = false
            self.bottomView.confirmBut.backgroundColor = ColorC7C7C7
        }
    }
    
}
// MARK: - FooterView 代理
extension CXMMDaletouConfirmVC : FootballOrderFooterDelegate {
    func didTipSelectedAgreement(isAgerr: Bool) {
        self.agreement.onNext(isAgerr)
    }
    
    func didTipAgreement() {
        let agreement = CXMWebViewController()
        agreement.urlStr = getCurentBaseWebUrl() + webBuyAgreement
        pushViewController(vc: agreement)
    }
}
// MARK: - 选择大乐透
extension CXMMDaletouConfirmVC : CXMMDaletouViewControllerDelegate {
    func didSelected(list: DaletouDataList) {
        
        if self.pushIndex != nil {
            self.list.insert(list, at: self.pushIndex)
        }else {
            self.list.append(list)
        }
        
        self.tableView.reloadData()
    }
    
    private func pushDaletouBetting(indexPath: IndexPath?, ispush : Bool) {
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "DaletouViewController") as! CXMMDaletouViewController
        
        vc.delegate = self
        vc.isPush = ispush
        if let index = indexPath {
            vc.model = self.list[index.row]
            self.list.remove(at: index.row)
            self.pushIndex = index.row
        }
        pushViewController(vc: vc)
    }
}

extension CXMMDaletouConfirmVC : DaletouConfirmCellDelegate{
    func didTipDelete(model: DaletouDataList) {
        self.list.remove(model)
        self.tableView.reloadData()
        // 无数据返回上一页
        if self.list.count == 0 {
            self.popViewController()
        }
    }
}
extension CXMMDaletouConfirmVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDaletouBetting(indexPath: indexPath, ispush: true)
    }
}
extension CXMMDaletouConfirmVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouConfirmCell", for: indexPath) as! DaletouConfirmCell
        cell.configure(with: list[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let model = self.list[indexPath.row]
        
        var listCount = 0
        
        switch model.type {
        case .标准选号:
            listCount = model.redList.count + model.blueList.count
        case .胆拖选号:
            listCount = model.danRedList.count + 1 + model.dragRedList.count
            if model.danBlueList.count != 0 {
                listCount += 1
            }
            listCount += model.danBlueList.count
            listCount += 1
            listCount += model.dragBlueList.count
        }
        
        let count : Int = listCount / 10
        
        if count == 0 {
            return 90
        }else {
            let num : Int = listCount % 10
            if num == 0 {
                return CGFloat(70 + 21 * count)
            }else {
                return CGFloat(70 + 21 * (count + 1))
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        default:
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
