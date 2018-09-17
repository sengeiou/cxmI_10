//
//  CXMMPrizeMatchHistoryVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum PrizeMatchHistoryStyle : String {
    case football = "竞彩足球开奖"
    case basketBall = "竞彩篮球开奖"
    case beijingBall = "北京单场开奖"
}

class CXMMPrizeMatchHistoryVC: BaseViewController {

    public var lotteryId : String = ""
    public var style : PrizeMatchHistoryStyle = .football
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topTitleLabel : UILabel!
    private var selecteDate : String!
    
    private var matchHisModel : MatchHisListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = style.rawValue
        initSubview()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        
        let time = dateFormater.string(from: Date())
        
        selecteDate = time
        
        setEmpty(title: "暂无数据", tableView)
        
        setRightNavigationItem()
        
        
        switch lotteryId {
        case "1": // 足球
            style = .football
        case "3":
            style = .basketBall
        case "6":
            style = .beijingBall
        default: break
        }
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
    }

    private func setData() {
        
        let att = NSMutableAttributedString(string: matchHisModel.dateStr)
        
        let count = NSAttributedString(string: "    \(matchHisModel.prizeMatchStr)")
        
        att.append(count)
        
        topTitleLabel.attributedText = att
    }
    
    private func initSubview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF4F4F4
    }
    private func setRightNavigationItem() {
        let right = UIButton(type: .custom)
        right.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        right.setImage(UIImage(named: "rili"), for: .normal)
        right.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        right.addTarget(self, action: #selector(rightItemClick(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right)
    }
    
    @objc private func rightItemClick(_ sender : UIButton) {
        let filter = CXMMPrizeMatchHistoryFilterVC()
        filter.delegate = self
        filter.selectedDate = self.selecteDate
        present(filter)
    }
    
}
// MARK: - 网络请求
extension CXMMPrizeMatchHistoryVC {
    private func loadNewData() {
        matchHisRequest()
    }
    private func matchHisRequest() {
        weak var weakSelf = self
        _ = surpriseProvider.rx.request(.matchPrizeList(date: selecteDate, lotteryId: lotteryId))
            .asObservable()
            .mapObject(type: MatchHisListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.matchHisModel = data
                weakSelf?.setData()
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

extension CXMMPrizeMatchHistoryVC : CXMMPrizeMatchHistoryFilterVCDelegate {
    func didSelected(date: String) {
        self.selecteDate = date
        //self.loadNewData()
        tableView.beginRefreshing()
    }
}

extension CXMMPrizeMatchHistoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMPrizeMatchHistoryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard matchHisModel != nil else { return 0 }
        return matchHisModel != nil ? matchHisModel.list.count : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch style {
        case .football:
            return initFootballCell(indexPath: indexPath)
        case .basketBall:
            return initBasketBallCell(indexPath: indexPath)
        case .beijingBall:
            return initFootballCell(indexPath: indexPath)
        }
    }
    
    private func initFootballCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeFootHistoryCell", for: indexPath) as! PrizeFootHistoryCell
        cell.configure(with: matchHisModel.list[indexPath.section])
        return cell
    }
    private func initBasketBallCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeBasketHistoryCell", for: indexPath) as! PrizeBasketHistoryCell
        cell.configure(with: matchHisModel.list[indexPath.section])
        return cell
    }
    private func initBeijingCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeBeijingHistoryCell", for: indexPath) as! PrizeBeijingHistoryCell
        cell.configure(with: matchHisModel.list[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
