//
//  CXMMDLTHotColdVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum HotColdStyle : String {
    case red = "红球冷热"
    case blue = "蓝球冷热"
}

class CXMMDLTHotColdVC: BaseViewController, IndicatorInfoProvider {

    public var style : HotColdStyle = .red
    
    public var redList : [DaletouDataModel]!
    public var blueList : [DaletouDataModel]!
    
    public var viewModel : DLTTrendBottomModel!
    
    public var settingViewModel : DLTTrendSettingModel!
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: DLTTrendBottom!
    
    private var list : [DLTHotOrCold]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addPanGestureRecognizer = false
        setSubview()
        loadNewData()
        setData()
        
        self.bottomView.viewModel = self.viewModel
        settingData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bottomView.configure(red: self.redList, blue: self.blueList)
        
    }
    
    private func settingData() {
        _ = settingViewModel.change.asObserver()
            .subscribe(onNext: { (change)  in
                if change {
                    self.chartDataRequest(compute: self.settingViewModel.compute,
                                          count: self.settingViewModel.count,
                                          drop: self.settingViewModel.drop,
                                          sort: self.settingViewModel.sort)
                }
            }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = viewModel.confirm.asObserver()
            .subscribe(onNext: { (list) in
                
                let model = DLTBetInfoRequestModel.getRequestModel(list: [list], isAppend: false)
                
                self.saveBetInfoRequest(model: model)
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: style.rawValue)
    }
}

extension CXMMDLTHotColdVC {
    private func setSubview() {
        self.tableView.separatorStyle = .none
        
    }
    private func setData() {
        
    }
}

// MARK: - 网络请求
extension CXMMDLTHotColdVC {
    private func loadNewData() {
        chartDataRequest(compute: settingViewModel.compute,
                         count: settingViewModel.count,
                         drop: settingViewModel.drop,
                         sort: settingViewModel.sort)
    }
    private func chartDataRequest(compute: Bool, count: String, drop: Bool, sort: Bool) {
        
        weak var weakSelf = self
        
        var tab = ""
        
        switch style {
        case .red:
            tab = "4"
        case .blue:
            tab = "5"
        }
        self.showProgressHUD()
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : tab))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.dismissProgressHud()
                switch self.style {
                case .red:
                    weakSelf?.list = data.preHeatColds
                case .blue:
                    weakSelf?.list = data.postHeatColds
                }
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                weakSelf?.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
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
    private func saveBetInfoRequest(model : DLTBetInfoRequestModel) {
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.setInfo(model: model))
            .asObservable()
            .mapObject(type: SaveBetInfoModel.self)
            .subscribe(onNext: { (data) in
//                print(data)
//                let vc = CXMPaymentViewController()
//                vc.lottoToken = data.data
//
//                self.pushViewController(vc: vc)
                
                if data.payToken != "" {
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

extension CXMMDLTHotColdVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDLTHotColdVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTHotColdCell", for: indexPath) as! DLTHotColdCell
        cell.configure(with: list[indexPath.row], style : self.style)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
