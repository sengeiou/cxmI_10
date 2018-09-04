//
//  CXMMPrizeDigitalHistoryVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



class CXMMPrizeDigitalHistoryVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var pageModel : BasePageModel<PrizeLottoInfo>!
    
    private var style : LottoPlayType = .大乐透
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "大乐透历史开奖"
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.footerRefresh {
            self.loadNextData()
        }
        tableView.beginRefreshing()
    }


}

// MARK: - 网络请求
extension CXMMPrizeDigitalHistoryVC {
    private func loadNewData() {
        digitalHistoryRequest(pageNum: 1)
    }
    private func loadNextData() {
        guard self.pageModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        digitalHistoryRequest(pageNum: pageModel.nextPage)
    }
    private func digitalHistoryRequest(pageNum : Int) {
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.lottoPrizeList(page: pageNum))
            .asObservable()
            .mapObject(type: BasePageModel<PrizeLottoInfo>.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.pageModel = data
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}

// MARK: - table Delegate
extension CXMMPrizeDigitalHistoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let story = UIStoryboard(name: "Surprise", bundle: nil )
//        let prizeHistory = story.instantiateViewController(withIdentifier: "PrizeDigitalHistoryVC") as! CXMMPrizeDigitalHistoryVC
//        
//        pushViewController(vc: prizeHistory)
    }
}
// MARK: - table DataSource
extension CXMMPrizeDigitalHistoryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.pageModel != nil else { return 0 }
        guard let list = self.pageModel.list else { return 0 }
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return initDigitalCell(indexPath: indexPath)
    }
    
    private func initDigitalCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeDigitalHistoryCell", for: indexPath) as! PrizeDigitalHistoryCell
        
        
        switch indexPath.row {
        case 0:
            cell.stateIcon.isHidden = false
            cell.configure(with: pageModel.list[indexPath.row], style: .prizeList)
        default:
            cell.stateIcon.isHidden = true
            cell.configure(with: pageModel.list[indexPath.row], style: .prizeDetail)
        }
        
        return cell
    }
    private func initMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeMatchCell", for: indexPath) as! SurprisePrizeMatchCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
