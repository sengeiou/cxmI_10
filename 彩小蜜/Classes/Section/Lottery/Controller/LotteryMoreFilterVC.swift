 //
//  LotteryMoreFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let FilterCellHeight: CGFloat = 30 * defaultScale
fileprivate let minimumLineSpacing : CGFloat = 12
fileprivate let minimumInteritemSpacing : CGFloat = 9
fileprivate let topInset : CGFloat = 10
fileprivate let leftInset: CGFloat = 0
fileprivate let FilterCellWidth : CGFloat = ((326 * defaultScale) - (10 * 2 * defaultScale) - (minimumInteritemSpacing * 2 * defaultScale) - 1) / 3

fileprivate let FootballFilterCellId = "FootballFilterCellId"

protocol LotteryMoreFilterVCDelegate {
    func filterConfirm(leagueId: String, isAlreadyBuy: Bool) -> Void
}

class LotteryMoreFilterVC: BasePopViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FootballFilterTopViewDelegate, FootballFilterBottomViewDelegate {
    
    public var filterList: [FilterModel]! {
        didSet{
            guard filterList != nil else { return }
            self.collectionView.reloadData()
        }
    }
    
    public var delegate : LotteryMoreFilterVCDelegate!
    public var isAlreadyBuy: Bool = false {
        didSet{
            changButState(isSelected: isAlreadyBuy)
        }
    }
    private var bottomView: FootballFilterBottomView!
    private var topView : FootballFilterTopView!
    
    private var titleLB: UILabel!
    private var topLine : UIImageView!
    private var titleTwolb : UILabel!
    private var titleThreelb : UILabel!
    
    private var onlyButBut: UIButton!
    private var currentFilterList : [FilterModel]!
    private var currentIsAlreadyBuy : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromCenter
        currentFilterList = [FilterModel]()
        self.currentIsAlreadyBuy = isAlreadyBuy
        initSubview()
        
        //filterRequest()
        // 保存当前选中的
        DispatchQueue.global().async {
            guard self.filterList != nil else { return }
            for model in self.filterList {
                if model.isSelected {
                    self.currentFilterList.append(model)
                }
            }
        }
        
        
    }
    
    // MARK: - 网络请求
//    private func filterRequest() {
//        weak var weakSelf = self
//        _ = homeProvider.rx.request(.filterMatchList)
//            .asObservable()
//            .mapArray(type: FilterModel.self)
//            .subscribe(onNext: { (data) in
//                weakSelf?.filterList = data
//                weakSelf?.collectionView.reloadData()
//            }, onError: { (error) in
//                guard let err = error as? HXError else { return }
//                switch err {
//                case .UnexpectedResult(let code, let msg):
//                    print(code!)
//                    weakSelf?.showHUD(message: msg!)
//                default: break
//                }
//            }, onCompleted: nil, onDisposed: nil )
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(topLine.snp.top)
        }
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(50 * defaultScale)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        titleTwolb.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom).offset(17 * defaultScale)
            make.height.equalTo(12 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(100)
        }
        
        onlyButBut.snp.makeConstraints { (make) in
            make.top.equalTo(titleTwolb.snp.bottom).offset(12 * defaultScale)
            make.left.equalTo(titleTwolb)
            //make.width.equalTo(100)
        }
        titleThreelb.snp.makeConstraints { (make) in
            make.top.equalTo(onlyButBut.snp.bottom).offset(16 * defaultScale)
            make.bottom.equalTo(topView.snp.top).offset(-12 * defaultScale)
            make.height.equalTo(12 * defaultScale)
            make.left.equalTo(titleTwolb)
            make.width.equalTo(100)
        }
        
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom).offset(110 * defaultScale)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
            make.height.equalTo(30 * defaultScale)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(36 * defaultScale)
            make.left.right.equalTo(0)
        }
        
    }
    private func initSubview() {
        self.viewHeight = 371 * defaultScale
        
        topLine = UIImageView()
        topLine.image = UIImage(named: "line")
        
        topView = FootballFilterTopView()
        topView.delegate = self
        bottomView = FootballFilterBottomView()
        bottomView.delegate = self
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .center
        titleLB.text = "赛事筛选"
        
        titleTwolb = UILabel()
        titleTwolb.font = Font12
        titleTwolb.textColor = Color787878
        titleTwolb.textAlignment = .left
        titleTwolb.text = "方案筛选"
        
        titleThreelb = UILabel()
        titleThreelb.font = Font12
        titleThreelb.textColor = Color787878
        titleThreelb.textAlignment = .left
        titleThreelb.text = "选择赛事"
        
        onlyButBut = UIButton(type: .custom)
        onlyButBut.titleLabel?.sizeToFit()
        onlyButBut.titleLabel?.font = Font14
        onlyButBut.setTitle("  只看已购对阵  ", for: .normal)
        onlyButBut.setTitleColor(Color787878, for: .normal)
        
        onlyButBut.layer.borderWidth = 0.3
        onlyButBut.layer.borderColor = ColorC8C8C8.cgColor
        onlyButBut.addTarget(self, action: #selector(onlyBuyButClicked(_:) ), for: .touchUpInside)
        
        
        self.pushBgView.addSubview(topLine)
        self.pushBgView.addSubview(titleLB)
        self.pushBgView.addSubview(topView)
        self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(collectionView)
        self.pushBgView.addSubview(titleTwolb)
        self.pushBgView.addSubview(titleThreelb)
        self.pushBgView.addSubview(onlyButBut)
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
        guard filterList != nil else { return 0 }
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
        self.isAlreadyBuy = false
        changButState(isSelected: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let filter = filterList[indexPath.row]
        filter.isSelected = !filter.isSelected
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - TOP VIEW Delegate
    // 全选
    func allSelected() {
        guard filterList != nil else { return }
        self.isAlreadyBuy = false
        for  index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = true
            self.collectionView.reloadItems(at: [indexPath])
        }
        changButState(isSelected: false)
    }
    // 反选
    func reverseSelected() {
        guard filterList != nil else { return }
        self.isAlreadyBuy = false
        for index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = !filter.isSelected
            self.collectionView.reloadItems(at: [indexPath])
        }
        changButState(isSelected: false)
    }
    // 仅五大联赛
    func fiveSelected() {
        self.isAlreadyBuy = false
        changButState(isSelected: false)
    }
    
    @objc private func onlyBuyButClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        self.isAlreadyBuy = sender.isSelected
        changButState(isSelected: sender.isSelected)
        guard filterList != nil else { return }
        for index in 0..<filterList.count {
            let indexPath = IndexPath(item: index, section: 0)
            let filter = filterList[indexPath.row]
            filter.isSelected = false
            self.collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
    private func changButState(isSelected: Bool) {
        if isSelected {
            onlyButBut.setTitleColor(ColorFFFFFF, for: .normal)
            onlyButBut.backgroundColor = ColorEA5504
        }else {
            onlyButBut.setTitleColor(Color787878, for: .normal)
            onlyButBut.backgroundColor = ColorFFFFFF
        }
        onlyButBut.isSelected = isSelected
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
        if idStr != "" {
            idStr.removeLast()
        }
        
        guard delegate != nil else { return }
        delegate.filterConfirm(leagueId: idStr, isAlreadyBuy: isAlreadyBuy)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterCancel() {
        changButState(isSelected: self.currentIsAlreadyBuy)
        
        DispatchQueue.global().async {
            if self.filterList != nil {
                for model in self.filterList {
                    model.isSelected = false
                }
                for model in self.currentFilterList {
                    model.isSelected = true
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
