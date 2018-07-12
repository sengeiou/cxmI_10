//
//  FootballIntegralView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
fileprivate let FootballIntegralCollectionCellId = "FootballIntegralCollectionCellId"

fileprivate let TitleWidth : CGFloat = 36 

fileprivate let IntegralCellWidth : CGFloat = (screenWidth - 36 - 80 - 12) / 6
fileprivate let IntegralCellHeight: CGFloat = 27

class FootballIntegralView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var scoreInfo : TeamScoreInfoModel! {
        didSet{
            guard scoreInfo != nil else { return }
            guard let hteam = scoreInfo.hteamScore else { return }
            guard let lteam = scoreInfo.lteamScore else { return }
            guard let tteam = scoreInfo.tteamScore else { return }
            
            scoreList.removeAll()
            
            scoreList.append(tteam.matchNum)
            scoreList.append(tteam.matchH)
            scoreList.append(tteam.matchD)
            scoreList.append(tteam.matchL)
            scoreList.append("\(tteam.ballIn)/\(tteam.ballLose)/\(tteam.ballClean)")
            scoreList.append(tteam.score)
            scoreList.append(tteam.ranking)
            
            scoreList.append(hteam.matchNum)
            scoreList.append(hteam.matchH)
            scoreList.append(hteam.matchD)
            scoreList.append(hteam.matchL)
            scoreList.append("\(hteam.ballIn)/\(hteam.ballLose)/\(hteam.ballClean)")
            scoreList.append(hteam.score)
            scoreList.append(hteam.ranking)
            
            scoreList.append(lteam.matchNum)
            scoreList.append(lteam.matchH)
            scoreList.append(lteam.matchD)
            scoreList.append(lteam.matchL)
            scoreList.append("\(lteam.ballIn)/\(lteam.ballLose)/\(lteam.ballClean)")
            scoreList.append(lteam.score)
            scoreList.append(lteam.ranking)
            
            scoreList.append("")
        }
    }
    
    private var scoreList: [String]!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        scoreList = [String]()
        
//        for _ in 0...20 {
//            scoreList.append("")
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func initSubview() {
        let topLine = getLine()
        let centerLine = getLine()
        let bottomLine = getLine()
        let vLine = getLine()
        
        let title = getLabel("总\n主\n客")
        let chang = getLabel("场")
        let sheng = getLabel("胜")
        let ping  = getLabel("平")
        let fu    = getLabel("负")
        let jin   = getLabel("进/失/净")
        let jifen = getLabel("积分")
        let mingci = getLabel("名次")
        
        self.addSubview(title)
        self.addSubview(chang)
        self.addSubview(sheng)
        self.addSubview(ping)
        self.addSubview(fu)
        self.addSubview(jin)
        self.addSubview(jifen)
        self.addSubview(mingci)
        self.addSubview(topLine)
        self.addSubview(centerLine)
        self.addSubview(bottomLine)
        self.addSubview(vLine)
        self.addSubview(collectionView)
        
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        centerLine.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom).offset(36 )
            make.left.right.height.equalTo(topLine)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.height.equalTo(topLine)
        }
        vLine.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.left.equalTo(36 * defaultScale)
            make.bottom.equalTo(bottomLine.snp.top)
            make.width.equalTo(0.5)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(vLine.snp.left)
            make.bottom.equalTo(bottomLine.snp.top)
        }
        mingci.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(centerLine.snp.top)
            make.width.equalTo(IntegralCellWidth)
        }
        jifen.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(mingci)
            make.right.equalTo(mingci.snp.left)
        }
        jin.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(mingci)
            make.width.equalTo(80)
            make.right.equalTo(jifen.snp.left)
        }
        fu.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(mingci)
            make.right.equalTo(jin.snp.left)
        }
        ping.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(mingci)
            make.right.equalTo(fu.snp.left)
        }
        sheng.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(mingci)
            make.right.equalTo(ping.snp.left)
        }
        chang.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(mingci)
            make.right.equalTo(sheng.snp.left)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.left.equalTo(vLine.snp.right)
            make.right.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
        }
        
    }
    
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.text = title
        return lab
    }
    
    private func getLine() -> UIView {
        let view = UIView()
        view.backgroundColor = ColorC8C8C8
        return view
    }
    
    // MARK: - 懒加载
    lazy public var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = ColorFFFFFF
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = false
        
        collection.register(FootballIntegralCollectionCell.self, forCellWithReuseIdentifier: FootballIntegralCollectionCellId)
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard scoreList.isEmpty == false else { return 0 }
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FootballIntegralCollectionCellId, for: indexPath) as! FootballIntegralCollectionCell
      
        cell.title.text = scoreList[indexPath.row]
     
        if indexPath.row == 5 || indexPath.row == 12 || indexPath.row == 19 {
            cell.title.textColor = ColorEA5504
        }else {
            cell.title.textColor = Color505050
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.row == 4 {
            return CGSize(width: 80, height: IntegralCellHeight)
        }else if indexPath.row ==  11 {
            return CGSize(width: 80, height: IntegralCellHeight)
        }else if indexPath.row == 18 {
            return CGSize(width: 80, height: IntegralCellHeight)
        }else {
            return CGSize(width: IntegralCellWidth, height: IntegralCellHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
