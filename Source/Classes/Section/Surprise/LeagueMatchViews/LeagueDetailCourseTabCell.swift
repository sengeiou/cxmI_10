//
//  LeagueDetailCourseTabCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueDetailCourseTabCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var viewModel : CourseTabCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = ColorF4F4F4
        collectionView.backgroundColor = ColorF4F4F4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension LeagueDetailCourseTabCell {
    public func configure(with data : CourseTabCellViewModel) {
        self.viewModel = data
        self.collectionView.reloadData()
    }
}

extension LeagueDetailCourseTabCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedItem(model: viewModel.list[indexPath.row], index: indexPath.row)
    }
}
extension LeagueDetailCourseTabCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard viewModel != nil else { return 0 }
        return viewModel.list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueDetailCourseTabItem", for: indexPath) as! LeagueDetailCourseTabItem
        cell.configure(with: viewModel.list[indexPath.row])
        return cell
    }
    
}

extension LeagueDetailCourseTabCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LeagueDetailCourseTabItem.width, height: LeagueDetailCourseTabItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
