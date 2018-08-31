//
//  CXMMLeagueMatchFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol LeagueMatchFilterDelegate {
    func didSelectItem(leagueInfo : LeagueInfoModel) -> Void
}

class CXMMLeagueMatchFilterVC: BasePopViewController {

    public var leagueMatch : LeagueMatchModel! {
        didSet{
            guard leagueMatch != nil else { return }
            self.collectionView.reloadData()
            titleLabel.text = leagueMatch.contryName
        }
    }
    
    public var delegate : LeagueMatchFilterDelegate!
    
    private var collectionView : UICollectionView!
    
//    private var bottomView: BottomView!
    
    private var titleLabel : UILabel!
    
    private var topline : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popStyle = .fromCenter
        initSubview()
    }

    private func initSubview() {
        
        self.viewHeight = 380
        
        topline = UIView()
        topline.backgroundColor = ColorE9E9E9
        
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ColorFFFFFF
        collectionView.register(LeagueMatchFilterItem.self,
                                forCellWithReuseIdentifier: LeagueMatchFilterItem.identifier)
        
        titleLabel = UILabel()
        titleLabel.font = Font13
        titleLabel.textColor = Color505050
        titleLabel.textAlignment = .center
        titleLabel.text = "西班牙"
        
//        bottomView = BottomView()
//        bottomView.delegate = self
        
        self.pushBgView.addSubview(topline)
        self.pushBgView.addSubview(titleLabel)
        //self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.height.equalTo(20)
            make.left.right.equalTo(0)
        }
        topline.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(-10)
        }
    }
}

//extension CXMMLeagueMatchFilterVC : BottomViewDelegate {
//    func didTipConfitm() {
//
//    }
//
//    func didTipCancel() {
//
//    }
//}

extension CXMMLeagueMatchFilterVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        delegate.didSelectItem(leagueInfo: leagueMatch.leagueInfoList[indexPath.row])
        self.dismiss(animated: false, completion: nil )
    }
}
extension CXMMLeagueMatchFilterVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard leagueMatch != nil else { return 0 }
        return leagueMatch.leagueInfoList.isEmpty == false ? leagueMatch.leagueInfoList.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeagueMatchFilterItem.identifier, for: indexPath) as! LeagueMatchFilterItem
        cell.configure(with: leagueMatch.leagueInfoList[indexPath.row])
        return cell
    }
}

extension CXMMLeagueMatchFilterVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LeagueMatchFilterItem.width, height: LeagueMatchFilterItem.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}











