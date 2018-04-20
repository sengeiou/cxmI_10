//
//  FootballCollectionView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum ScoreType: String {
    case 胜 = "胜"
    case 平 = "平"
    case 负 = "负"
    case 半全场 = "半全场"
}

protocol FootballCollectionViewDelegate {
    func didSelectedItem(cell : FootballPlayCellModel) -> Void
    func didDeSelectedItem(cell : FootballPlayCellModel) -> Void
}

fileprivate let FilterCellHeight: CGFloat = 44 * defaultScale
fileprivate let HunheCellHeight : CGFloat = 38 * defaultScale
fileprivate let minimumLineSpacing : CGFloat = 0
fileprivate let minimumInteritemSpacing : CGFloat = 0
fileprivate let topInset : CGFloat = 0
fileprivate let leftInset: CGFloat = 0
fileprivate let FilterCellWidth : CGFloat = (320 * defaultScale) / 5
fileprivate let collectionviewwidth : CGFloat = 320 * defaultScale

fileprivate let FootballScoreCollectionCellId = "FootballScoreCollectionCellId"

class FootballCollectionView: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public var cells : [FootballPlayCellModel]! {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    public var delegate : FootballCollectionViewDelegate!
    
    public var matchType : FootballMatchType = .比分
    public var scoreType : ScoreType = .胜
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    private func initSubview() {
        self.addSubview(collectionView)
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
        collection.isScrollEnabled = false
        collection.register(FootballScoreCollectionCell.self, forCellWithReuseIdentifier: FootballScoreCollectionCellId)
        return collection
    }()
    
    // MARK: - COLLECTION DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard cells != nil else { return 0 }
        return cells.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FootballScoreCollectionCellId, for: indexPath) as! FootballScoreCollectionCell
    
        cell.cellInfo = cells[indexPath.row]
//        switch matchType {
//        case .比分, .混合过关:
//            cell.cellSon = cells[indexPath.row]
//
//        default :
//            cell.cellInfo = cells[indexPath.row]
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch matchType {
        case .胜平负, .让球胜平负:
            return CGSize(width: collectionviewwidth / 3, height: HunheCellHeight)
        case .比分:
            switch scoreType {
            case .胜:
                if indexPath.row == 12 {
                    return CGSize(width: FilterCellWidth * 3, height: FilterCellHeight)
                }else {
                    return CGSize(width: FilterCellWidth, height: FilterCellHeight)
                }
            case .平:
                return CGSize(width: FilterCellWidth, height: FilterCellHeight)
            case .负:
                if indexPath.row == 12 {
                    return CGSize(width: FilterCellWidth * 3, height: FilterCellHeight)
                }else {
                    return CGSize(width: FilterCellWidth, height: FilterCellHeight)
                }
            case .半全场 :
                return CGSize(width: collectionviewwidth / 3, height: FilterCellHeight)
            }
        case .总进球:
            return CGSize(width: collectionviewwidth / 8, height: HunheCellHeight)
        case .半全场:
            return CGSize(width: collectionviewwidth / 3, height: HunheCellHeight)
        case .混合过关:
            switch scoreType {
            case .胜:
                if indexPath.row == 12 {
                    return CGSize(width: FilterCellWidth * 3, height: HunheCellHeight)
                }else {
                    return CGSize(width: FilterCellWidth, height: HunheCellHeight)
                }
            case .平:
                return CGSize(width: FilterCellWidth, height: HunheCellHeight)
            case .负:
                if indexPath.row == 12 {
                    return CGSize(width: FilterCellWidth * 3, height: HunheCellHeight)
                }else {
                    return CGSize(width: FilterCellWidth, height: HunheCellHeight)
                }
            case .半全场 :
                return CGSize(width: collectionviewwidth / 3, height: HunheCellHeight)
            }
        default: return CGSize(width: 0, height: 0)
            
        }
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
        cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
        collectionView.reloadItems(at: [indexPath])
        
        guard delegate != nil else { return }
        if cells[indexPath.row].isSelected == true {
            delegate.didSelectedItem(cell: cells[indexPath.row])
        }else {
            delegate.didDeSelectedItem(cell: cells[indexPath.row])
        }
//        switch matchType {
//        case .比分, .混合过关:
//            cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
//            collectionView.reloadItems(at: [indexPath])
//
//            guard delegate != nil else { return }
//            if cells[indexPath.row].isSelected == true {
//                delegate.didSelectedItem(cell: cells[indexPath.row])
//            }else {
//                delegate.didDeSelectedItem(cell: cells[indexPath.row])
//            }
//        default:
//
//            cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
//            collectionView.reloadItems(at: [indexPath])
//
//            guard delegate != nil else { return }
//            if cells[indexPath.row].isSelected == true {
//                delegate.didSelectedItem(cell: cells[indexPath.row])
//            }else {
//                delegate.didDeSelectedItem(cell: cells[indexPath.row])
//            }
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
        collectionView.reloadItems(at: [indexPath])
//        switch scoreType {
//        case .半全场:
//            cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
//            collectionView.reloadItems(at: [indexPath])
//        default:
//            cells[indexPath.row].isSelected = !cells[indexPath.row].isSelected
//            collectionView.reloadItems(at: [indexPath])
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
