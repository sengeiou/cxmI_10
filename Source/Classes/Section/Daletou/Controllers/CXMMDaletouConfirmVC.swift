//
//  DaletouConfirmViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMDaletouConfirmVC: BaseViewController {

    public var dataList : [[DaletouDataModel]] = [[DaletouDataModel]]()
    
    public var bettingNumber = 0 {
        didSet{
            let num = try! bettingNum.value()
            bettingNum.onNext( num + bettingNumber)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    public var bettingNum = BehaviorSubject(value: 0)
    private var multiple = BehaviorSubject(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 投注确认"
        self.tableView.reloadData()
        
        settingData()
    }

    private func settingData() {
        _ = Observable.combineLatest(bettingNum, multiple)
            .asObservable()
            .subscribe(onNext: { (num, multiple) in
                print("\(num)     \(multiple)")
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }

}

extension CXMMDaletouConfirmVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDaletouConfirmVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouConfirmCell", for: indexPath) as! DaletouConfirmCell
        cell.configure(with: dataList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let list = dataList[indexPath.row]
        
        let count : Int = list.count / 12
        
        if count == 0 {
            return 90
        }else {
            let num : Int = list.count % 12
            if num == 0 {
                return CGFloat(70 + 21 * count)
            }else {
                return CGFloat(70 + 21 * (count + 1))
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        default:
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
