//
//  CXMMPrizeDigitalHistoryVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



class CXMMPrizeDigitalHistoryVC: BaseViewController {

    public var lotteryId : String! {
        didSet{
            guard lotteryId != nil else { return }
            self.style = LottoPlayType.getType(lotteryId: lotteryId)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var lottoListModel : PrizeLottoListModel!
    
    private var style : LottoPlayType = .大乐透
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = style.rawValue
        setEmpty(title: "暂无数据", tableView)
        initSubView()
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.footerRefresh {
            self.loadNextData()
        }
        tableView.beginRefreshing()
    }

    private func initSubView() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }

}

// MARK: - 网络请求
extension CXMMPrizeDigitalHistoryVC {
    private func loadNewData() {
        digitalHistoryRequest(pageNum: 1)
    }
    private func loadNextData() {
        guard self.lottoListModel.szcPrizePageInfo.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        digitalHistoryRequest(pageNum: lottoListModel.szcPrizePageInfo.nextPage)
    }
    private func digitalHistoryRequest(pageNum : Int) {
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.lottoPrizeList(page: pageNum, lotteryId: lotteryId))
            .asObservable()
            .mapObject(type: PrizeLottoListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.lottoListModel = data
                
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
        
        let model = self.lottoListModel.szcPrizePageInfo.list[indexPath.row]
        
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        let prizeHistory = story.instantiateViewController(withIdentifier: "DigitalHistoryDetailVC") as! CXMMDigitalHistoryDetailVC
        prizeHistory.lotteryId = lotteryId
        prizeHistory.termNum = model.termNum
        pushViewController(vc: prizeHistory)
    }
}
// MARK: - table DataSource
extension CXMMPrizeDigitalHistoryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.lottoListModel != nil else { return 0 }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.lottoListModel != nil else { return 0 }
        guard let list = self.lottoListModel.szcPrizePageInfo.list else { return 0 }
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
            cell.configure(with: lottoListModel.szcPrizePageInfo.list[indexPath.row], style: .prizeList)
        default:
            cell.stateIcon.isHidden = true
            cell.configure(with: lottoListModel.szcPrizePageInfo.list[indexPath.row], style: .prizeDetail)
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
