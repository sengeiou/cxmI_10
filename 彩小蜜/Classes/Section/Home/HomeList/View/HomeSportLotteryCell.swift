//
//  HomeSportLotteryCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let homeFootballCellIdentifier = "homeFootballCellIdentifier"

fileprivate let sectionLeftSpacing: CGFloat = 20 * defaultScale
let HomesectionTopSpacing : CGFloat = 10
let HomeSectionViewHeight : CGFloat = 44 * defaultScale
let HorizontalItemCount = 4

let FootballCellLineSpacing: CGFloat = 10 * defaultScale
let FootballCellInteritemSpacing: CGFloat = 20 * defaultScale
let FootballCellWidth : CGFloat = (screenWidth - (FootballCellInteritemSpacing * CGFloat(HorizontalItemCount - 1)) - sectionLeftSpacing * 2) / CGFloat(HorizontalItemCount)
let FootballCellHeight : CGFloat = 90 * defaultScale

protocol HomeSportLotteryCellDelegate {
    func didSelectItem() -> Void
}


class HomeSportLotteryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    public var playList : [HomePlayModel]! {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    public var delegate: HomeSportLotteryCellDelegate!
    
    private var title : UILabel!
    private var line : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(HomeSectionViewHeight)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
            make.height.equalTo(0.5)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(line.snp.top).offset(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(0)
            make.right.equalTo(self.contentView).offset(-0)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        title = UILabel()
        title.font = Font15
        title.textColor = Color505050
        title.textAlignment = .left
        title.text = "竞彩足球"
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(title)
        self.contentView.addSubview(collectionView)
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
        guard playList != nil , playList.isEmpty != true else { return 0 }
        return playList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFootballCellIdentifier, for: indexPath) as! HomeFootballCell
        cell.playModel = self.playList[indexPath.row]
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
        return UIEdgeInsets(top: HomesectionTopSpacing, left: sectionLeftSpacing, bottom: HomesectionTopSpacing, right: sectionLeftSpacing)
    }
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
