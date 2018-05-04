//
//  FootballPlayFilterVC.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//  串关筛选

import UIKit


fileprivate let FilterCellHeight: CGFloat = 30 * defaultScale
fileprivate let minimumLineSpacing : CGFloat = 10
fileprivate let minimumInteritemSpacing : CGFloat = 10
fileprivate let topInset : CGFloat = 10
fileprivate let leftInset: CGFloat = 30

fileprivate let itemCount : Int = 3

fileprivate let FilterCellWidth : CGFloat = (screenWidth - leftInset * 2 - minimumInteritemSpacing * 2) / CGFloat(itemCount)

fileprivate let FootballPlayFilterCellId = "FootballPlayFilterCellId"

protocol FootballPlayFilterVCDelegate {
    func playFilterConfirm(filterList:[FootballPlayFilterModel]) -> Void
    func playFilterCancel() -> Void
}

class FootballPlayFilterVC: BasePopViewController, FootballFilterBottomViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    public var filterList: [FootballPlayFilterModel]! {
        didSet{
            guard filterList != nil else { return }
            oldFileterList = filterList.map { $0.copy() as! FootballPlayFilterModel }
            self.collectionView.reloadData()

        }
    }
    
    // MARK: - 属性
    public var delegate: FootballPlayFilterVCDelegate!
    
    private var bottomView: FootballFilterBottomView!
    
    private var bgView: UIView!
    private var titleLB: UILabel!
    
    private var oldFileterList: [FootballPlayFilterModel]!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        initSubview()
        filterList = [FootballPlayFilterModel]()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50 * defaultScale)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            make.left.equalTo(0)
            make.right.equalTo(-0)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.height.equalTo(36 * defaultScale)
            make.left.right.equalTo(0)
        }
        
    }
    private func initSubview() {
        self.viewHeight = 240 * defaultScale
        
        bottomView = FootballFilterBottomView()
        bottomView.delegate = self
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font12
        titleLB.textColor = Color9F9F9F
        titleLB.textAlignment = .center
        titleLB.text = "可选串关方式"
        
        bgView.addSubview(titleLB)
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
        collection.register(FootballPlayFilterCell.self, forCellWithReuseIdentifier: FootballPlayFilterCellId)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FootballPlayFilterCellId, for: indexPath) as! FootballPlayFilterCell
        
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
    
    
    func filterConfirm() {
        guard delegate != nil else { return }
        delegate.playFilterConfirm(filterList: filterList)
        dismiss(animated: true, completion: nil)
    }
    
    func filterCancel() {
        guard delegate != nil else { return }
        delegate.playFilterCancel()
        
        dismiss(animated: true, completion: nil)
        
        for index in 0..<filterList.count {
            filterList[index].isSelected = oldFileterList[index].isSelected
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.filterCancel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
