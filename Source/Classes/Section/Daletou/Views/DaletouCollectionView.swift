//
//  DaletouCollectionView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift


enum BallStyle {
    case red
    case blue
}

enum DLTDisplayStyle {
    /// 默认样式
    case defStyle
    /// 显示遗漏
    case omission
}

protocol DaletouCollectionViewDelegate {
    func didSelected(view : DaletouCollectionView, model: DaletouDataModel, indexPath : IndexPath) -> Void
}

class DaletouCollectionView: UIView {

    public var delegate : DaletouCollectionViewDelegate!
    
    private var ballStyle : BallStyle = .red
    
    private var displayStyle : DLTDisplayStyle = .defStyle
    
    private var dataList : [DaletouDataModel]!
    private var omissionList: [DaletouOmissionModel]!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isScrollEnabled = false
    }
}
// MARK: - Event
extension DaletouCollectionView {
    public func reloadData() {
        
    }
}

// MARK: - 数据
extension DaletouCollectionView {
    public func configure(with dataList: [DaletouDataModel]) {
        self.dataList = dataList
        self.collectionView.reloadData()
    }
    // 显示隐藏数据
    public func configure(with omissionList : [DaletouOmissionModel]) {
        self.omissionList = omissionList
        self.collectionView.reloadData()
    }
    /// 配置显示样式，，默认-显示遗漏
    public func configure(with displayStyle : DLTDisplayStyle) {
        self.displayStyle = displayStyle
        self.collectionView.reloadData()
    }
}

extension DaletouCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataList[indexPath.row]
        model.selected = !model.selected
        self.collectionView.reloadData()
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelected(view: self, model: model, indexPath: indexPath)
    }
}

extension DaletouCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.dataList != nil else { return 0 }
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaletouItem", for: indexPath) as! DaletouItem
        cell.configure(with: self.dataList[indexPath.row])
        return cell
    }
}

extension DaletouCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch displayStyle {
        case .defStyle:
            return CGSize(width: DaletouItem.width, height: DaletouItem.heiht)
        case .omission:
            return CGSize(width: DaletouItem.width, height: DaletouItem.heiht + 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch displayStyle {
        case .defStyle:
            return 15
        case .omission:
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return ((screenWidth - 32 - (36 * 7)) / 6) - 1
    }
}
