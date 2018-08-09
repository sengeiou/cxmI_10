//
//  CXMMDaletouProVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouProVC: BaseViewController {

    public var orderSn : String!
    public var proSn : String!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proNumber: UILabel!
    
    private var schemeModel : DLTTicketSchemeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewData()
        setSubview()
    }

    private func setSubview() {
        
    }

}
// MARK: - 网络请求
extension CXMMDaletouProVC {
    private func loadNewData() {
        ticketSchemeRequest()
    }
    private func ticketSchemeRequest() {
        guard orderSn != nil, proSn != nil else { return }
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.ticketScheme(orderSn: orderSn, programmeSn: proSn))
            .asObservable()
            .mapObject(type: DLTTicketSchemeModel.self)
            .subscribe(onNext: { (data) in
                self.schemeModel = data
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
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

extension CXMMDaletouProVC : UITableViewDelegate {
    
}
extension CXMMDaletouProVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTProTableViewCell", for: indexPath) as! DLTProTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
