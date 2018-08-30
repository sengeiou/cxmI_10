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
}

class CXMMPrizeMatchHistoryVC: BaseViewController {

    public var style : PrizeMatchHistoryStyle = .football
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = style.rawValue
        initSubview()
        
        setRightNavigationItem()
    }

    private func initSubview() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF4F4F4
    }
    private func setRightNavigationItem() {
        let right = UIButton(type: .custom)
        right.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right)
    }
    
}

extension CXMMPrizeMatchHistoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMPrizeMatchHistoryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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
        }
    }
    
    private func initFootballCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeFootHistoryCell", for: indexPath) as! PrizeFootHistoryCell
        
        return cell
    }
    private func initBasketBallCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeBasketHistoryCell", for: indexPath) as! PrizeBasketHistoryCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
