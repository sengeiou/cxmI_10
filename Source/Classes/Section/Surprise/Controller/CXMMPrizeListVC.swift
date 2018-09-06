//
//  CXMMPrizeListVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMPrizeListVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var prizeList : [PrizeListModel]!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "开奖"
        initSubview()
        loadNewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - 初始化 子视图
    private func initSubview() {
        
    }
    
}

extension CXMMPrizeListVC {
    private func loadNewData() {
        prizeListRequest()
    }
    private func prizeListRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.prizeList())
            .asObservable()
            .mapArray(type: PrizeListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.prizeList = data
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
extension CXMMPrizeListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        
        let model = prizeList[indexPath.row]
        
        switch model.classifyStatus {
        case "0":
            let prizeHistory = story.instantiateViewController(withIdentifier: "PrizeDigitalHistoryVC") as! CXMMPrizeDigitalHistoryVC
            
            pushViewController(vc: prizeHistory)
        case "1":
            let history = story.instantiateViewController(withIdentifier: "PrizeMatchHistoryVC") as! CXMMPrizeMatchHistoryVC
            history.lotteryId = model.lotteryId
            switch model.ballColor {
            case "1":
                history.style = .football
            case "0":
                history.style = .basketBall
            default: break
            }
            
            pushViewController(vc: history)
        default : break
        }
        
    }
}
// MARK: - table DataSource
extension CXMMPrizeListVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prizeList != nil ? prizeList.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model = prizeList[indexPath.row]
        
        switch model.classifyStatus {
        case "0":
            return initDigitalCell(indexPath: indexPath)
        case "1":
            return initMatchCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
    }
    
    private func initDigitalCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeDigitalCell", for: indexPath) as! SurprisePrizeDigitalCell
        cell.configure(with: prizeList[indexPath.row], style : .prizeList)
        return cell
    }
    private func initMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurprisePrizeMatchCell", for: indexPath) as! SurprisePrizeMatchCell
        cell.configure(with: prizeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = prizeList[indexPath.row]
        switch model.classifyStatus {
        case "0":
            return 108
        case "1":
            return 100
        default:
            return 0
        }
    }
}


