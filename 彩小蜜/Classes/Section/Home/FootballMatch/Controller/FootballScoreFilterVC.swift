//
//  FootballScoreFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

typealias Selected  = (_ selectedCells : [FootballPlayCellModel], _ canAdd : Bool) -> ()
typealias DeSelected = (_ selectedCells : [FootballPlayCellModel], _ canRemove : Bool) -> ()
typealias SelectedItem = () -> ()

class FootballScoreFilterVC: BasePopViewController, BottomViewDelegate, FootballCollectionViewDelegate {
    
    public var teamInfo : FootballPlayListModel! {
        didSet{
            guard teamInfo != nil else { return }
            homeTeam.text = teamInfo.homeTeamAbbr
            visitingTeam.text = teamInfo.visitingTeamAbbr
            shengScoreView.cells = teamInfo.matchPlays[0].homeCell.cellSons
            pingScoreView.cells = teamInfo.matchPlays[0].flatCell.cellSons
            fuScoreView.cells = teamInfo.matchPlays[0].visitingCell.cellSons
            
            oldHomeSelectedCells = teamInfo.matchPlays[0].homeCell.cellSons.map{ $0.copy() as! FootballPlayCellModel }
            oldFlatSelectedCells = teamInfo.matchPlays[0].flatCell.cellSons.map{ $0.copy() as! FootballPlayCellModel }
            oldVisiSelectedCells = teamInfo.matchPlays[0].visitingCell.cellSons.map{ $0.copy() as! FootballPlayCellModel }
            
            //guard teamInfo.selectedHunhe != nil else { return }
            selectedCells = teamInfo.selectedHunhe
            
        }
    }

    public var selected : Selected!
    public var deSelected : DeSelected!
    public var didSelected : SelectedItem!
    private var selectedCells : [FootballPlayCellModel]!
    
    private var oldHomeSelectedCells : [FootballPlayCellModel]!
    private var oldFlatSelectedCells : [FootballPlayCellModel]!
    private var oldVisiSelectedCells : [FootballPlayCellModel]!
    
    private var homeTeam : UILabel!
    private var vslb : UILabel!
    private var visitingTeam : UILabel!
    
    private var shengScoreView : FootballCollectionView!
    private var pingScoreView : FootballCollectionView!
    private var fuScoreView : FootballCollectionView!
    
    private var shengTitle: UILabel!
    private var pingTitle: UILabel!
    private var fuTitle : UILabel!
    
    private var bottomView : BottomView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popStyle = .fromBottom
        selectedCells = [FootballPlayCellModel]()
        
        initSubview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeTeam.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.bottom.equalTo(shengTitle.snp.top)
        }
        vslb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeTeam)
            make.left.equalTo(homeTeam.snp.right)
        }
        visitingTeam.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeTeam)
            make.left.equalTo(vslb.snp.right)
            make.right.equalTo(0)
        }
        
        shengTitle.snp.makeConstraints { (make) in
            make.top.equalTo(43 * defaultScale)
            make.height.equalTo(132 * defaultScale)
            make.left.equalTo(filterleftSpacing)
            make.width.equalTo(filterTitleWidth)
        }
        
        pingTitle.snp.makeConstraints { (make) in
            make.top.equalTo(shengTitle.snp.bottom).offset(18 * defaultScale)
            make.left.width.equalTo(shengTitle)
            make.height.equalTo(44 * defaultScale)
        }
        fuTitle.snp.makeConstraints { (make) in
            make.top.equalTo(pingTitle.snp.bottom).offset(18 * defaultScale)
            make.left.width.equalTo(shengTitle)
            make.height.equalTo(132 * defaultScale)
        }
        
        shengScoreView.snp.makeConstraints { (make) in
            make.top.equalTo(shengTitle)
            make.left.equalTo(shengTitle.snp.right)
            make.width.equalTo(ScoreViewWidth)
            make.height.equalTo(shengTitle)
        }
        pingScoreView.snp.makeConstraints { (make) in
            make.top.equalTo(pingTitle)
            make.left.width.equalTo(shengScoreView)
            make.height.equalTo(pingTitle)
        }
        fuScoreView.snp.makeConstraints { (make) in
            make.top.equalTo(fuTitle)
            make.left.width.equalTo(shengScoreView)
            make.height.equalTo(fuTitle)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(45 * defaultScale)
        }
        
    }
    
    private func initSubview() {
        
        self.viewHeight = (454 + SafeAreaBottomHeight) * defaultScale
        
        homeTeam = UILabel()
        homeTeam.font = Font14
        homeTeam.textColor = Color505050
        homeTeam.textAlignment = .center
        
        vslb = UILabel()
        vslb.text = "VS"
        vslb.font = Font14
        vslb.textColor = Color9F9F9F
        vslb.textAlignment = .center
        vslb.sizeToFit()
        
        visitingTeam = UILabel()
        visitingTeam.font = Font14
        visitingTeam.textColor = Color505050
        visitingTeam.textAlignment = .center
        
        shengTitle = UILabel()
        shengTitle.font = Font12
        shengTitle.textColor = ColorFFFFFF
        shengTitle.backgroundColor = ColorF6AD41
        shengTitle.textAlignment = .center
        shengTitle.text = "胜"
        
        pingTitle = UILabel()
        pingTitle.font = Font12
        pingTitle.textColor = ColorFFFFFF
        pingTitle.backgroundColor = Color65AADD
        pingTitle.textAlignment = .center
        pingTitle.text = "平"
        
        fuTitle = UILabel()
        fuTitle.font = Font12
        fuTitle.textColor = ColorFFFFFF
        fuTitle.backgroundColor = Color85C36B
        fuTitle.textAlignment = .center
        fuTitle.text = "负"
        
        shengScoreView = FootballCollectionView()
        shengScoreView.scoreType = .胜
        shengScoreView.delegate = self
        
        pingScoreView = FootballCollectionView()
        pingScoreView.scoreType = .平
        pingScoreView.delegate = self
        
        fuScoreView = FootballCollectionView()
        fuScoreView.scoreType = .负
        fuScoreView.delegate = self
        
        bottomView = BottomView()
        bottomView.delegate = self
        
        self.pushBgView.addSubview(homeTeam)
        self.pushBgView.addSubview(vslb)
        self.pushBgView.addSubview(visitingTeam)
        self.pushBgView.addSubview(shengTitle)
        self.pushBgView.addSubview(pingTitle)
        self.pushBgView.addSubview(fuTitle)
        self.pushBgView.addSubview(shengScoreView)
        self.pushBgView.addSubview(pingScoreView)
        self.pushBgView.addSubview(fuScoreView)
        self.pushBgView.addSubview(bottomView)
    }
    
    // MARK: - 选取Item delegate
    func didSelectedItem(cell: FootballPlayCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.append(cell)
    }
    
    func didDeSelectedItem(cell: FootballPlayCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.remove(cell)
    }
    
    func didTipConfitm() {
        
        self.teamInfo.selectedHunhe = selectedCells
        
        dismiss(animated: true, completion: nil)
        
        let canAdd = true
        self.selected(selectedCells, canAdd)
        
        guard didSelected != nil else { return }
        self.didSelected()
    }
    
    func didTipCancel() {
       
        dismiss(animated: true, completion: nil)
        
        for index in 0..<oldHomeSelectedCells.count {
            self.teamInfo.matchPlays[0].homeCell.cellSons[index].isSelected = oldHomeSelectedCells[index].isSelected
        }
        for index in 0..<oldFlatSelectedCells.count {
            self.teamInfo.matchPlays[0].flatCell.cellSons[index].isSelected = oldFlatSelectedCells[index].isSelected
        }
        for index in 0..<oldVisiSelectedCells.count {
            self.teamInfo.matchPlays[0].visitingCell.cellSons[index].isSelected = oldVisiSelectedCells[index].isSelected
        }
    }
    
    @objc public override func backPopVC() {
        self.didTipCancel()
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === self.pushBgView.superview {
            return true
        }
        if touch.view !== self.shengScoreView || touch.view !== self.pingScoreView || touch.view !== self.fuScoreView {
            return false
        }
        return true
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}
