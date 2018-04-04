//
//  FootballMatchFilterVC.swift
//  彩小蜜
//
//  Created by HX on 2018/4/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



fileprivate let FilterCellWidth : CGFloat = 70
fileprivate let FilterCellHeight: CGFloat = 35
fileprivate let minimumLineSpacing : CGFloat = 10
fileprivate let minimumInteritemSpacing : CGFloat = 10
fileprivate let topInset : CGFloat = 10
fileprivate let leftInset: CGFloat = 0

fileprivate let FootballFilterCellId = "FootballFilterCellId"

protocol FootballMatchFilterVCDelegate {
    func filterConfirm(leagueId: String) -> Void
}

class FootballMatchFilterVC: BasePopViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FootballFilterTopViewDelegate, FootballFilterBottomViewDelegate {
   
    
    public var delegate : FootballMatchFilterVCDelegate!

    private var bottomView: FootballFilterBottomView!
    private var topView : FootballFilterTopView!
    
    private var bgView: UIView!
    private var titleLB: UILabel!
    
    private var filterList: [FilterModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubview()
        
        filterList = [FilterModel]()
        
//        for _ in 0...8 {
//            let fil = FilterModel()
//            filterList.append(fil)
//        }
        filterRequest()
    }
    
    // MARK: - 网络请求
    private func filterRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterMatchList)
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.filterList = data
                weakSelf?.collectionView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(topView.snp.top)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(44 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(44 * defaultScale)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(44 * defaultScale)
            make.left.right.equalTo(0)
        }
        
    }
    private func initSubview() {
        topView = FootballFilterTopView()
        topView.delegate = self
        bottomView = FootballFilterBottomView()
        bottomView.delegate = self
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .center
        titleLB.text = "赛事筛选"
        
        bgView.addSubview(titleLB)
        bgView.addSubview(topView)
        bgView.addSubview(bottomView)
        bgView.addSubview(collectionView)
        self.pushBgView.addSubview(bgView)
    }
    
    // MARK: - 懒加载
    lazy public var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = ColorFFFFFF
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = true
        collection.register(FootballFilterCell.self, forCellWithReuseIdentifier: FootballFilterCellId)
        return collection
    }()
    
    // MARK: - COLLECTION DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FootballFilterCellId, for: indexPath) as! FootballFilterCell
        
        cell.filterModel = self.filterList[indexPath.row]
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FilterCellWidth, height: FilterCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterList[indexPath.row]
        filter.isSelected = !filter.isSelected
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let filter = filterList[indexPath.row]
        filter.isSelected = !filter.isSelected
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - TOP VIEW Delegate
    // 全选
    func allSelected() {
        for  index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = true
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    // 反选
    func reverseSelected() {
        for index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = !filter.isSelected
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    // 仅五大联赛
    func fiveSelected() {
        
    }
    
    func filterConfirm() {
        var idStr : String = ""
        var i = 0
        for filter in self.filterList {
            if filter.isSelected == true {
                print(i)
                idStr += filter.leagueId + ","
            }
            i += 1
        }
        idStr.removeLast()
        guard delegate != nil else { return }
        delegate.filterConfirm(leagueId: idStr)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
