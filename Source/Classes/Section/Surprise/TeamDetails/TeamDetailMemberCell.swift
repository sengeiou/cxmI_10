//
//  TeamDetailMemberCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailMemberCell: UITableViewCell {

    @IBOutlet weak var topline : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
   
    private var list : [TeamMemberInfo] = [TeamMemberInfo]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.backgroundColor = ColorF4F4F4
        leftLine.isHidden = true
        rightLine.isHidden = true
        bottomLine.isHidden = true
        collectionView.isScrollEnabled = false
    }
}

extension TeamDetailMemberCell {
    public func configure(with info : TeamMemberDetail) {
        self.list = info.playerList
        
        switch info.playerTypeCode {
        case "0": // 守门员
            title.text = "  守门员"
        case "1": // 后卫
            title.text = "  后卫"
        case "2": // 中场
            title.text = "  中场"
        case "3": // 前锋
            title.text = "  前锋"
        default: break
        }
        
        collectionView.reloadData()
    }
}

extension TeamDetailMemberCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension TeamDetailMemberCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count != 0 ? list.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamDetailMemberItem", for: indexPath) as! TeamDetailMemberItem
        cell.configure(with: list[indexPath.row])
        cell.topLine.isHidden = true
        return cell
    }
}
extension TeamDetailMemberCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: TeamDetailMemberItem.width, height: TeamDetailMemberItem.height)
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

