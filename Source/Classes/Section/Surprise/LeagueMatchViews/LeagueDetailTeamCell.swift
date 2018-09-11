//
//  LeagueDetailTeamCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueDetailTeamCellDelegate {
    func didSelectTeamItem(teamInfo : LeagueTeamInfo, index : IndexPath ) -> Void
}

class LeagueDetailTeamCell: UITableViewCell {

    public var delegate : LeagueDetailTeamCellDelegate!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var teamList : [LeagueTeamInfo]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        collectionView.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension LeagueDetailTeamCell {
    public func configure(with data : LeagueTeamList) {
        teamList = data.leagueTeamInfoDTOList
        collectionView.reloadData()
    }
}

extension LeagueDetailTeamCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
       
        delegate.didSelectTeamItem(teamInfo: teamList[indexPath.row], index: indexPath)
    }
}

extension LeagueDetailTeamCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList != nil ? teamList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseMatchItem", for: indexPath) as! SurpriseMatchItem
        cell.configure(with: teamList[indexPath.row])
        return cell
    }
}

extension LeagueDetailTeamCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SurpriseCollectionCell.width, height: SurpriseCollectionCell.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
