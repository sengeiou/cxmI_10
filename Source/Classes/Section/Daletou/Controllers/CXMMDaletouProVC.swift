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
        self.tableView.separatorStyle = .none
    }
    private func setData() {
        self.proNumber.text = self.schemeModel.programmeSn
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
        
        _ = dltProvider.rx.request(.ticketScheme(orderSn: "2018080110000000010440", programmeSn: "2018080110000000010440"))
            .asObservable()
            .mapObject(type: DLTTicketSchemeModel.self)
            .subscribe(onNext: { (data) in
                self.schemeModel = data
                weakSelf?.setData()
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
        guard schemeModel != nil else { return 0 }
        
        return schemeModel.lottoTicketSchemeDetailDTOs != nil ? schemeModel.lottoTicketSchemeDetailDTOs.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTProTableViewCell", for: indexPath) as! DLTProTableViewCell
        cell.configure(with: self.schemeModel.lottoTicketSchemeDetailDTOs[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = schemeModel.lottoTicketSchemeDetailDTOs[indexPath.row]
        
        var listCount = 0
        
        switch model.playType {
        case "0", "1":
            listCount = model.redCathectics.count + model.blueCathectics.count
        case "2":
            listCount = model.redDanCathectics.count + 1 + model.redTuoCathectics.count
            if model.blueDanCathectics.count != 0 {
                listCount += 1
            }
            listCount += model.blueDanCathectics.count
            listCount += model.blueTuoCathectics.count
        default : break
        }
        
        let count : Int = listCount / 7
        
        if count == 0 {
            return 65
        }else {
            let num : Int = listCount % 7
            if num == 0 {
                return CGFloat(30 + 40 * count)
            }else {
                return CGFloat(30 + 40 * (count + 1))
            }
        }
    }
    
    
}
