//
//  HomeSportLotteryCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let homeFootballCellIdentifier = "homeFootballCellIdentifier"

fileprivate let sectionLeftSpacing = 30

let HorizontalItemCount = 4

let FootballCellLineSpacing: CGFloat = 10
let FootballCellInteritemSpacing: CGFloat = (screenWidth - CGFloat(sectionLeftSpacing) * 2 - FootballCellWidth * 4.0) / 3.0
let FootballCellWidth : CGFloat = (screenWidth - 40 * 3 - CGFloat(sectionLeftSpacing) * 2) / CGFloat(HorizontalItemCount)
let FootballCellHeight : CGFloat = 90

protocol HomeSportLotteryCellDelegate {
    func didSelectItem() -> Void
}


class HomeSportLotteryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    public var delegate: HomeSportLotteryCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(0)
            make.right.equalTo(self.contentView).offset(-0)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        self.contentView.addSubview(collectionView)
    }
    
    lazy public var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = ColorFFFFFF
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = true
        collection.register(HomeFootballCell.self, forCellWithReuseIdentifier: homeFootballCellIdentifier)
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        delegate.didSelectItem()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFootballCellIdentifier, for: indexPath) as! HomeFootballCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FootballCellWidth, height: FootballCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
