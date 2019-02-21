//
//  HomeSportCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

fileprivate let homeFootballSportCellIdentifier = "homeFootballSportCellIdentifier"

fileprivate let sectionLeftSpacing: CGFloat = 20 * defaultScale
let HomesectionTopSportSpacing : CGFloat = 10
let HomeSectionViewSportHeight : CGFloat = 1 * defaultScale
let HorizontalSportItemCount = 3

let FootballCellLineSportSpacing: CGFloat = 10 * defaultScale
let FootballCellInteritemSportSpacing: CGFloat = 10 * defaultScale
let FootballSportCellWidth : CGFloat = (screenWidth - (FootballCellInteritemSportSpacing * CGFloat(HorizontalItemCount - 1)) - sectionLeftSpacing * 2) / CGFloat(HorizontalSportItemCount)
let FootballSportCellHeight : CGFloat = 110

protocol HomeSportCellDelegate {
    func didSelectSportItem(playModel: HomeFindModel, index: Int) -> Void
}


class HomeSportCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private var playList : [HomeFindModel]!
    
    public var delegate: HomeSportCellDelegate!
    
    private var title : UILabel!
    private var line : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        line.snp.makeConstraints { (make) in
        //            make.top.equalTo(HomeSectionViewHeight)
        //            make.left.equalTo(10 * defaultScale)
        //            make.right.equalTo(-10 * defaultScale)
        //            make.height.equalTo(0.5)
        //        }
        //
        //        title.snp.makeConstraints { (make) in
        //            make.top.equalTo(0)
        //            make.bottom.equalTo(line.snp.top).offset(0)
        //            make.left.equalTo(leftSpacing)
        //            make.right.equalTo(-rightSpacing)
        //        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(1)
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
        line.backgroundColor = ColorC7C7C7
        
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
        collection.register(HomeFootballCell.self, forCellWithReuseIdentifier: homeFootballSportCellIdentifier)
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        guard playList.isEmpty == false else { return }
        let play = playList[indexPath.row]
        delegate.didSelectSportItem(playModel: play, index: indexPath.row)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard playList != nil , playList.isEmpty != true else { return 0 }
        return playList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFootballSportCellIdentifier, for: indexPath) as! HomeFootballCell
        cell.configure(with: self.playList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FootballSportCellWidth, height: FootballSportCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellLineSportSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FootballCellInteritemSportSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: HomesectionTopSportSpacing, left: sectionLeftSpacing, bottom: HomesectionTopSportSpacing, right: sectionLeftSpacing)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeSportCell {
    public func configure(with data : [HomeFindModel]) {
        self.playList = data
        
        self.collectionView.reloadData()
    }
}
