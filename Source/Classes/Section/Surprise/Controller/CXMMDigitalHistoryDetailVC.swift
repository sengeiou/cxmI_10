//
//  CXMMDigitalHistoryDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDigitalHistoryDetailVC: BaseViewController {

    public var termNum : String = ""
    
    public var style : LottoPlayType = .大乐透
    
    @IBOutlet weak var tableView : UITableView!
    
    private var viewModel : DigitalHisViewModel = DigitalHisViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
        
    }

    private func initSubview() {
        tableView.separatorStyle = .none
        
    }
}

extension CXMMDigitalHistoryDetailVC {
    private func loadNewData() {
        lottoDetailRequest()
    }
    private func lottoDetailRequest() {
        weak var weakSelf = self
        _ = surpriseProvider.rx.request(.lottoPrizeDetail(termNum: termNum))
            .asObservable()
            .mapObject(type: PrizeLottoDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.viewModel.setBallData(redList: data.redPrizeNumList,
                                                blueList: data.bluePrizeNumList)
                
                weakSelf?.viewModel.lottoDetailData = data
                
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

extension CXMMDigitalHistoryDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDigitalHistoryDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.lottoDetailData != nil else { return 0 }
        guard viewModel.lottoDetailData.superLottoRewardDetailsList.isEmpty == false else { return 0 }
        switch section {
        case 0:
            return 1
        default:
            
            switch style {
            case .大乐透:
                return viewModel.lottoDetailData.superLottoRewardDetailsList.count + 2
            case .广东11选5:
                return viewModel.lottoDetailData.superLottoRewardDetailsList.count
            default : break
            }
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initBallCell(indexPath: indexPath)
        default:
            switch indexPath.row {
            case 0:
                return initLottoTitleCell(indexPath: indexPath)
            default:
                return initLottoCell(indexPath: indexPath)
            }
        }
    }
    
    private func initBallCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeDigitalHisDetailCell", for: indexPath) as! PrizeDigitalHisDetailCell
        cell.configure(with: viewModel)
        return cell
    }
    private func initLottoTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalHisLottoTitleCell", for: indexPath) as! DigitalHisLottoTitleCell
        
        cell.configure(with: viewModel.lottoDetailData.sellAmount,
                       prize: viewModel.lottoDetailData.prizes)
        return cell
    }
    private func initLottoCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalHisDetailLottoCell", for: indexPath) as! DigitalHisDetailLottoCell
        if indexPath.row == 1 {
            cell.configure(with: viewModel.lottoDetailData.superLottoRewardDetailsList[0],
                           isTitle: true)
            cell.topLine.isHidden = true
        }else {
            cell.configure(with: viewModel.lottoDetailData.superLottoRewardDetailsList[indexPath.row - 2],
                           isTitle: false)
            cell.topLine.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 80
        default:
            switch viewModel.style {
            case .大乐透:
                switch indexPath.row {
                case 0:
                    return 80
                default:
                    return 30
                }
            case .广东11选5:
                return 30
                
            default :
                return 20
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
