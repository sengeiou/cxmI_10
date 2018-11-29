//
//  CommodityDetailsVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityDetailsVC: BaseViewController {

    public var goodsId : String!
    
    @IBOutlet weak var tableView : UITableView!
    
    private var goodsDetail : GoodsDetailModel!
    
    private var header : BannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商城"
        initSubview()
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
    }
    
    private func initSubview() {
        tableView.estimatedRowHeight = 80
        header = BannerView()
        header.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 320.0)
        var model = BannerModel()
        model.bannerImage = "https://static.caixiaomi.net/uploadImgs/20181127/098ceeeef00a4232938979fa2c1bcb59.png"
        model.bannerLink = "http://caixiaomi.net?cxmxc=scm&type=8&showBar=1&from=app&showtitle=1&id=1518"
        model.bannerName = "欧战明天凌晨即将上演"
        header.bannerList = [model,model,model]
        tableView.tableHeaderView = header
    }

}
// MARK: - 点击事件
extension CommodityDetailsVC : UITableViewDelegate {
    
}
// MARK: - TableView DataSource
extension CommodityDetailsVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initDetailCell(indexPath: indexPath)
        default:
            return initImageCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    private func initDetailCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityDetailCell", for: indexPath) as! CommodityDetailCell
        return cell
    }
    private func initImageCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityImageCell", for: indexPath) as! CommodityImageCell
        switch indexPath.row {
        case 0:
            cell.configure(with: "https://static.caixiaomi.net/uploadImgs/20181128/024047955fa546869d7163cf6b788697.png")
        default:
            cell.configure(with: "https://static.caixiaomi.net/uploadImgs/20181128/c1391439509547af8e27a95763d35a37.png")
        }
        return cell
    }
}

// MARK: - 网络请求
extension CommodityDetailsVC {
    private func loadNewData() {
        goodsDetailRequest()
    }
    
    private func goodsDetailRequest() {
        weak var weakSelf = self
        
        _ = shopProvider.rx.request(.goodsDetail(goodsId: goodsId)).asObservable()
            .mapObject(type: GoodsDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.goodsDetail = data
                weakSelf?.tableView.reloadData()
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
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
