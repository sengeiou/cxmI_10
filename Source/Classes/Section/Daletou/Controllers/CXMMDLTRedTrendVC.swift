//
//  CXMMDLTRedTrendVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CXMMDLTRedTrendVC: BaseViewController, IndicatorInfoProvider{

    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DLTTrendBottom!
    var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    public var style : HotColdStyle = .red
    
    public var redList : [DaletouDataModel]!
    public var blueList : [DaletouDataModel]!
    
    public var viewModel : DLTTrendBottomModel!
    
    public var compute: Bool! = false // 是否计算统计
    public var count: String! = "100" // 期数
    public var drop: Bool! = false     // 是否显示遗漏
    public var sort: Bool! = false    // 排序
    
    private var list : [DLTHotOrCold]!
    
    private var dropData : DLTTrendInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addPanGestureRecognizer = false
        self.bottomView.viewModel = self.viewModel
        initSubview()
        loadNewData()
        self.topCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bottomView.configure(red: self.redList, blue: self.blueList)
        
    }
    private func initSubview() {
    
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        self.scrollView.backgroundColor = UIColor(hexColor: "ffffff", alpha: 0.1)
        
        self.collectionView.isScrollEnabled = false
        self.topCollectionView.isScrollEnabled = false
        self.tableView.isScrollEnabled = false
        self.view.addSubview(scrollView)
        
        
        switch style {
        case .red:
            self.collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(topCollectionView.snp.bottom)
                make.bottom.equalTo(self.bottomView.snp.top)
                make.left.equalTo(self.tableView.snp.right)
                make.width.equalTo(DLTRedBlueTrendItem.width * 35)
            }
        case .blue:
            
            self.collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(topCollectionView.snp.bottom)
                make.bottom.equalTo(self.bottomView.snp.top)
                make.left.equalTo(self.tableView.snp.right)
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
        chartDataRequest()
    }
    private func chartDataRequest() {
        
        weak var weakSelf = self
        
        var tab = ""
        
        switch style {
        case .red:
            tab = "2"
        case .blue:
            tab = "3"
        }
        
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : tab))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                
                
                switch self.style {
                case .red:
                    weakSelf?.dropData = data.preLottoDrop
                    weakSelf?.scrollView.contentSize = CGSize(width: 35 * DLTRedBlueTrendItem.width + 1, height: DLTRedBlueTrendItem.height * CGFloat(data.preLottoDrop.drop.count))
                case .blue:
                    weakSelf?.dropData = data.postLottoDrop
                    weakSelf?.scrollView.contentSize = CGSize(width: 12 * DLTRedBlueTrendItem.width + 1, height: DLTRedBlueTrendItem.height * CGFloat(data.postLottoDrop.drop.count))
                }
                
                weakSelf?.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    weakSelf?.collectionView.reloadData()
                })
                
            }, onError: { (error) in
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
                self.tableView.contentOffset.y = scrollView.contentOffset.y
            }else{
                self.tableView.contentOffset.y = 0
            }
            
            self.collectionView.contentOffset = scrollView.contentOffset
            
            print(scrollView.contentOffset)
        }
        
        
        
    }
}

extension CXMMDLTRedTrendVC : UITableViewDelegate {
    
}

extension CXMMDLTRedTrendVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropData != nil ? dropData.drop.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTRedBlueTrendCell", for: indexPath) as! DLTRedBlueTrendCell
        cell.configure(with: self.dropData.drop[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension CXMMDLTRedTrendVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return dropData != nil ? dropData.drop.count : 0
        }else if collectionView == self.topCollectionView {
            return 1
        }else {
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
        }else {
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
        }else if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DLTRedBlueTrendItem", for: indexPath) as! DLTRedBlueTrendItem
            
            
            
            var color : UIColor
            
            if indexPath.section % 2 == 0 {
                color = ColorFFFFFF
            }else {
                color = ColorF5911Ea1
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
