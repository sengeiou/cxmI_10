//
//  SellerListVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class SellerListVC: BaseViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var cooperationBut : UIButton!
    
    private var sellerListModel : SellerListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "合作店铺"
        sellerListRequest()
        initSubview()
    }
    private func initSubview() {
        cooperationBut.isHidden = true
    }
}

// MARK: - Delegate 点击事件
extension SellerListVC : UITableViewDelegate {
    // 什么是合作店铺
    @IBAction func SellerExplainClicked(_ sender: UIButton) {
        if let url = sellerListModel.protocalUrl {
            pushRouterVC(urlStr: url, from: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sellerListModel.list[indexPath.row]
    
        let story = UIStoryboard(storyboard: .Seller)
        let detail = story.instantiateViewController(withIdentifier: "SellerDetailVC") as! SellerDetailVC
        detail.storeId = model.storeId
        pushViewController(vc: detail)
    }
}
// MARK - DataSource
extension SellerListVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sellerListModel != nil else { return 0 }
        return sellerListModel.list != nil ? sellerListModel.list.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListCell", for: indexPath) as! SellerListCell
        cell.configure(with: sellerListModel.list[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90 * defaultScale
    }
}
// MARK: - 网络请求
extension SellerListVC {
    private func sellerListRequest() {
        weak var weakSelf = self
        _ = sellerProvider.rx.request(.sellerList).asObservable()
            .mapObject(type: SellerListModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.sellerListModel = data
                weakSelf?.tableView.reloadData()
                if data.protocalUrl != nil {
                    weakSelf?.cooperationBut.isHidden = false
                }
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
