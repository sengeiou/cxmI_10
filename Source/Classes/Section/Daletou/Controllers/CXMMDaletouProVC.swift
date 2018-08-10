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
        
        self.schemeModel = DLTTicketSchemeModel()
        
        var list = [DLTTicketSchemeInfo]()
        
        for _ in 0...2{
            var model = DLTTicketSchemeInfo()
            model.playType = "2"
            var reds = [DLTOrderItemInfo]()
            var blues = [DLTOrderItemInfo]()
            
            var danReds = [DLTOrderItemInfo]()
            var dragReds  = [DLTOrderItemInfo]()
            var danBlues  = [DLTOrderItemInfo]()
            var dragBlues  = [DLTOrderItemInfo]()
            
            for i in 0...5 {
                let red = DLTOrderItemInfo()
                red.cathectic = "\(i)"
                reds.append(red)
            }
            
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                blues.append(blue)
            }
            
            
            for i in 5...15 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                danReds.append(blue)
            }
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                dragReds.append(blue)
            }
            for i in 8...10 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                danBlues.append(blue)
            }
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                dragBlues.append(blue)
            }
            
            
            //model.redCathectics = reds
            //model.blueCathectics = blues
            
            model.redDanCathectics = danReds
            model.redTuoCathectics = dragReds
            
            model.blueDanCathectics = danBlues
            model.blueTuoCathectics = dragBlues
            
            list.append(model)
        }
        
        
        
        //self.schemeModel.prePrizeInfo = "xxxxxxxx"
        self.schemeModel.ticketSchemeDetailDTOs = list
        self.tableView.reloadData()
        
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
        
        _ = dltProvider.rx.request(.ticketScheme(orderSn: orderSn, programmeSn: proSn))
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
        return schemeModel != nil ? schemeModel.ticketSchemeDetailDTOs.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTProTableViewCell", for: indexPath) as! DLTProTableViewCell
        cell.configure(with: self.schemeModel.ticketSchemeDetailDTOs[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = schemeModel.ticketSchemeDetailDTOs[indexPath.row]
        
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
