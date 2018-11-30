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
    @IBOutlet weak var goodsPrice : UILabel!
    @IBOutlet weak var hisPrice : UILabel!
    @IBOutlet weak var submitBut : UIButton!
    
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
    private func setupData() {
        guard goodsDetail != nil else { return }
        
        goodsPrice.text = "¥" + goodsDetail.presentPrice
        hisPrice.text = "¥" + goodsDetail.historyPrice
        
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
    @IBAction func submitClicked(_ sender: UIButton) {
        goodsAddRequest()
    }
}
// MARK: - TableView DataSource
extension CommodityDetailsVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard goodsDetail != nil else { return 0 }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return goodsDetail.detailPicList != nil ? goodsDetail.detailPicList.count : 0
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initInfoCell(indexPath: indexPath)
        case 1:
            return initDetailCell(indexPath: indexPath)
        default:
            return initImageCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            let count = lineNumber(totalNum: goodsDetail.baseAttributeList.count, horizonNum: 2)
            if count == 0 {
                return 30 + 20 + 30
            }else {
                return CGFloat(count * 30) + 20 + 30
            }
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
    private func initInfoCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityInfoCell", for: indexPath) as! CommodityInfoCell
        cell.configure(with: goodsDetail)
        return cell
    }
    private func initDetailCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityDetailCell", for: indexPath) as! CommodityDetailCell
        cell.configure(with: goodsDetail.baseAttributeList)
        return cell
    }
    private func initImageCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityImageCell", for: indexPath) as! CommodityImageCell
        
        cell.configure(with: goodsDetail!.detailPicList[indexPath.row])
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
                weakSelf?.tableView.endrefresh()
                weakSelf?.goodsDetail = data
                weakSelf?.tableView.reloadData()
                weakSelf?.setupData()
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
    
    private func goodsAddRequest() {
        weak var weakSelf = self
        _ = shopProvider.rx.request(.goodsAdd(goodsId: goodsId)).asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                
                let story = UIStoryboard(storyboard: .Shop)
                let order = story.instantiateViewController(withIdentifier: "CommodityOrderDetailVC") as! CommodityOrderDetailVC
                order.orderId = data.data
                weakSelf?.pushViewController(vc: order)
                
            }, onError: { (error) in
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
