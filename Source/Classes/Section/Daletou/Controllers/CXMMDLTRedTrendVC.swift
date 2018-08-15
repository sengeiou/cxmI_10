//
//  CXMMDLTRedTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class CXMMDLTRedTrendVC: BaseViewController, IndicatorInfoProvider{

    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var leftCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: DLTTrendBottom!
    var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    public var style : HotColdStyle = .red
    
    public var redList : [DaletouDataModel]!
    public var blueList : [DaletouDataModel]!
    
    public var viewModel : DLTTrendBottomModel!
    
    public var settingViewModel : DLTTrendSettingModel!
    
    private var list : [DLTHotOrCold]!
    
    private var dropData : DLTTrendInfo!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //addPanGestureRecognizer = false
        self.bottomView.viewModel = self.viewModel
        initSubview()
        loadNewData()
        settingData()
        self.topCollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bottomView.configure(red: self.redList, blue: self.blueList)
        
    }
    
    private func settingData() {
        _ = settingViewModel.change.asObserver()
            .subscribe(onNext: { (change)  in
                if change {
                    self.chartDataRequest(compute: self.settingViewModel.compute,
                                     count: self.settingViewModel.count,
                                     drop: self.settingViewModel.drop,
                                     sort: self.settingViewModel.sort)
                }
            }, onError: nil , onCompleted: nil , onDisposed: nil )
        
        _ = viewModel.confirm.asObserver()
            .subscribe(onNext: { (list) in
               
                self.changeConfirmButton(canTip: false)
                let model = DLTBetInfoRequestModel.getRequestModel(list: [list], isAppend: false)
                
                self.saveBetInfoRequest(model: model)
            }, onError: nil , onCompleted: nil , onDisposed: nil )
    }
    
    private func initSubview() {
    
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        self.scrollView.backgroundColor = UIColor(hexColor: "ffffff", alpha: 0.1)
        
        self.collectionView.isScrollEnabled = false
        self.topCollectionView.isScrollEnabled = false
        self.leftCollectionView.isScrollEnabled = false
        self.view.addSubview(scrollView)
        
        
        switch style {
        case .red:
            self.collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(topCollectionView.snp.bottom)
                make.bottom.equalTo(self.bottomView.snp.top)
                make.left.equalTo(self.leftCollectionView.snp.right)
                make.width.equalTo(DLTRedBlueTrendItem.width * 35)
            }
        case .blue:
            
            self.collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(topCollectionView.snp.bottom)
                make.bottom.equalTo(self.bottomView.snp.top)
                make.left.equalTo(self.leftCollectionView.snp.right)
                make.width.equalTo(DLTRedBlueTrendItem.width * 12 )
            }
        
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(self.collectionView)
            make.right.equalTo(0)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "红球走势"
    }
  

}

// MARK: - 网络请求
extension CXMMDLTRedTrendVC {
    private func loadNewData() {
        chartDataRequest(compute: true, count: "100", drop: true, sort: true)
    }
    private func chartDataRequest(compute: Bool, count: String, drop: Bool, sort: Bool) {
        
        weak var weakSelf = self
        
        var tab = ""
        
        switch style {
        case .red:
            tab = "2"
        case .blue:
            tab = "3"
        }
        self.showProgressHUD()
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : tab))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                
                
                switch self.style {
                case .red:
                    weakSelf?.dropData = data.preLottoDrop
                    if compute {
                        weakSelf?.dropData.drop.append(contentsOf: self.getCompueList(with: data.preLottoDrop))
                    }
                    weakSelf?.scrollView.contentSize = CGSize(width: 35 * DLTRedBlueTrendItem.width + 1,
                                                              height: DLTRedBlueTrendItem.height * CGFloat((weakSelf?.dropData.drop.count)!))
                
                case .blue:
                    weakSelf?.dropData = data.postLottoDrop
                    if compute {
                        weakSelf?.dropData.drop.append(contentsOf: self.getCompueList(with: data.postLottoDrop))
                    }
                    weakSelf?.scrollView.contentSize = CGSize(width: 12 * DLTRedBlueTrendItem.width + 1,
                                                              height: DLTRedBlueTrendItem.height * CGFloat((weakSelf?.dropData.drop.count)!))
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    weakSelf?.collectionView.reloadData()
                    weakSelf?.leftCollectionView.reloadData()
                    weakSelf?.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    weakSelf?.dismissProgressHud()
                })
                
            }, onError: { (error) in
                weakSelf?.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
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
    
    private func saveBetInfoRequest(model : DLTBetInfoRequestModel) {
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.setInfo(model: model))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.changeConfirmButton(canTip: true)
                
                let vc = CXMPaymentViewController()
                vc.lottoToken = data.data
                
                self.pushViewController(vc: vc)
            }, onError: { (error) in
                weakSelf?.changeConfirmButton(canTip: true)
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
    
    private func getCompueList(with model : DLTTrendInfo) -> [DLTLottoNumInfo] {
        var list = [DLTLottoNumInfo]()
        var mo1 = DLTLottoNumInfo()
        mo1.termNum = "出现次数"
        mo1.termStyle = .出现次数
        mo1.numList = model.countNum
        var mo2 = DLTLottoNumInfo()
        mo2.termNum = "平均遗漏"
        mo2.termStyle = .平均遗漏
        mo2.numList = model.averageData
        var mo3 = DLTLottoNumInfo()
        mo3.termNum = "最大遗漏"
        mo3.termStyle = .最大遗漏
        mo3.numList = model.maxData
        var mo4 = DLTLottoNumInfo()
        mo4.termNum = "最大连出"
        mo4.termStyle = .最大连出
        mo4.numList = model.maxContinue
        
        list.append(mo1)
        list.append(mo2)
        list.append(mo3)
        list.append(mo4)
        return list
    }
    
    private func changeConfirmButton( canTip : Bool) {
        switch canTip {
        case true:
            self.bottomView.confirmBut.isUserInteractionEnabled = true
            self.bottomView.confirmBut.backgroundColor = ColorE85504
            self.bottomView.redCollectionView.isUserInteractionEnabled = true
            self.bottomView.blueCollectionView.isUserInteractionEnabled = true
        case false:
            self.bottomView.confirmBut.isUserInteractionEnabled = false
            self.bottomView.confirmBut.backgroundColor = ColorC7C7C7
            self.bottomView.redCollectionView.isUserInteractionEnabled = false
            self.bottomView.blueCollectionView.isUserInteractionEnabled = false
        }
    }
}

extension CXMMDLTRedTrendVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            
            if scrollView.contentOffset.x > 0 {
                self.topCollectionView.contentOffset.x = scrollView.contentOffset.x
            }else {
                self.topCollectionView.contentOffset.x = 0
            }
            if scrollView.contentOffset.y > 0 {
                self.leftCollectionView.contentOffset.y = scrollView.contentOffset.y
            }else{
                self.leftCollectionView.contentOffset.y = 0
            }
            
            self.collectionView.contentOffset = scrollView.contentOffset
        }
    }
}

extension CXMMDLTRedTrendVC : UITableViewDelegate {
    
}

extension CXMMDLTRedTrendVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return dropData != nil ? dropData.drop.count : 0
        }else if collectionView == self.topCollectionView {
            return 1
        }else if collectionView == self.leftCollectionView{
            return 1
        }
        else {
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topCollectionView {
            switch style {
            case .red:
                return 35
            case .blue:
                return 12
            }
        }else if collectionView == leftCollectionView {
            return dropData != nil ? dropData.drop.count : 0
        }
        else {
            guard dropData != nil else { return 0 }
            switch style {
            case .red:
                return 35
            case .blue:
                return 12
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTRedBlueTopItem", for: indexPath) as! DLTRedBlueTopItem
            cell.configure(with: "\(indexPath.row + 1)")
            return cell
        }
        else if collectionView == self.leftCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTRedBlueTrendStageItem", for: indexPath) as! DLTRedBlueTrendStageItem
            
            let model = dropData.drop[indexPath.row]
            var color : UIColor
            
            switch model.termStyle {
            case .默认:
                if indexPath.row % 2 == 0 {
                    color = ColorFFFFFF
                }else {
                    color = ColorF5911Ea1
                }
            case .出现次数:
                color = Color00A79Ba1
            case .平均遗漏:
                color = ColorBF272Da1
            case .最大遗漏:
                color = Color009045a1
            case .最大连出:
                color = Color65AADDa1
            }
            
            cell.configure(with: self.dropData.drop[indexPath.row], color : color)
            return cell
        }
        else if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTRedBlueTrendItem", for: indexPath) as! DLTRedBlueTrendItem
            
    
            var color : UIColor
            
            let model = dropData.drop[indexPath.section]
            
            switch model.termStyle {
            case .默认:
                if indexPath.section % 2 == 0 {
                    color = ColorFFFFFF
                }else {
                    color = ColorF5911Ea1
                }
            case .出现次数:
                color = Color00A79Ba1
            case .平均遗漏:
                color = ColorBF272Da1
            case .最大遗漏:
                color = Color009045a1
            case .最大连出:
                color = Color65AADDa1
            }
            
            cell.configure(with: dropData.drop[indexPath.section].numList[indexPath.row],
                           num: "\(indexPath.row + 1)",
                           style : style,
                           color : color)
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
}
extension CXMMDLTRedTrendVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.leftCollectionView {
            return CGSize(width: 60, height: 30)
        }
        return CGSize(width: 35, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
