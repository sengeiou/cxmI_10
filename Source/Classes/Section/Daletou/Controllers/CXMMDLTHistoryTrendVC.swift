//
//  CXMMDLTHistoryTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMDLTHistoryTrendVC: BaseViewController, IndicatorInfoProvider {

    public var settingViewModel : DLTTrendSettingModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DLTHistoryTrendBottom!
    
    private var numList : [DLTLottoNumInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer = false
        setSubview()
        loadNewData()
        settingData()
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
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "开奖号码"
    }
}

// MARK: - 网络请求
extension CXMMDLTHistoryTrendVC {
    private func loadNewData() {
        chartDataRequest(compute: settingViewModel.compute,
                         count: settingViewModel.count,
                         drop: settingViewModel.drop,
                         sort: settingViewModel.sort)
    }
    private func chartDataRequest(compute: Bool, count: String, drop: Bool, sort: Bool) {
        
        weak var weakSelf = self
        self.showProgressHUD()
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : "1"))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.dismissProgressHud()
                weakSelf?.numList = data.lottoNums
                
                if var time = data.stopTime {
                    if time.contains("|") {
                        time = time.replacingOccurrences(of: "|", with: "期 截止时间 ")
                        weakSelf?.bottomView.titleLabel.text = time
                    }
                }
                
                
                weakSelf?.tableView.reloadData()
                if data.lottoNums.count > 0 {
                    weakSelf?.tableView.scrollToRow(at: IndexPath(row: data.lottoNums.count - 1, section: 0), at: .none, animated: true)
                }
                    
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
}

extension CXMMDLTHistoryTrendVC {
    private func setSubview() {
        self.tableView.separatorStyle = .none
        
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDLTHistoryTrendVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numList != nil ? numList.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTHistoryTrendCell", for: indexPath) as! DLTHistoryTrendCell
        cell.configure(with: self.numList[indexPath.row] )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * defaultScale
    }
}
