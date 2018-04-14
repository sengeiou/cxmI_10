//
//  FootballHunheFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballHunheFilterVC: BasePopViewController, BottomViewDelegate, FootballCollectionViewDelegate {

    public var teamInfo : FootballPlayListModel! {
        didSet{
            var spfArr = [FootballPlayCellModel]()
            spfArr.append(teamInfo.matchPlays[1].homeCell)
            spfArr.append(teamInfo.matchPlays[1].flatCell)
            spfArr.append(teamInfo.matchPlays[1].visitingCell)
            
            var rangArr = [FootballPlayCellModel]()
            rangArr.append(teamInfo.matchPlays[0].homeCell)
            rangArr.append(teamInfo.matchPlays[0].flatCell)
            rangArr.append(teamInfo.matchPlays[0].visitingCell)
            SPFView.cells = spfArr
            rangSPFView.cells = rangArr
            scoreHomeView.cellSons = teamInfo.matchPlays[2].homeCell.cellSons
            scoreFlatView.cellSons = teamInfo.matchPlays[2].flatCell.cellSons
            scoreVisiView.cellSons = teamInfo.matchPlays[2].visitingCell.cellSons
            
            totalView.cells = teamInfo.matchPlays[3].matchCells
            banquanView.cells = teamInfo.matchPlays[4].matchCells
            
            if teamInfo.matchPlays[0].fixedOdds < 0 {
                rangSPFTitlelb.text = "让\n球\n\(teamInfo.matchPlays[0].fixedOdds!)"
            }else {
                rangSPFTitlelb.text = "让\n球\n+\(teamInfo.matchPlays[0].fixedOdds!)"
            }
            
            selectedCells = teamInfo.selectedHunhe
        }
    }
    
    public var selectedScore : Selected!
    public var deSelectedScore : DeSelected!
    public var didSelectedScore : SelectedItem!
    
    public var selected : SelectedCell!
    public var deSelected : DeSelectedCell!
    public var didSelected : SelectedItemCell!
    public var selectedCells : [FootballPlayCellModel]!
    
    // MARK: - 属性 private
    private var topTitleView : TopTitleView!
    private var bottomView : BottomView!
    
    private var SPFTitlelb : UILabel!
    private var rangSPFTitlelb : UILabel!
    private var scoreTitlelb: UILabel!
    private var totalTitlelb : UILabel!
    private var banquanTitlelb: UILabel!
    
    private var SPFView : FootballCollectionView!
    private var rangSPFView: FootballCollectionView!
    private var scoreHomeView: FootballCollectionView!
    private var scoreFlatView: FootballCollectionView!
    private var scoreVisiView: FootballCollectionView!
    private var totalView : FootballCollectionView!
    private var banquanView: FootballCollectionView!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCells = [FootballPlayCellModel]()
        self.popStyle = .fromBottom
        initSubview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topTitleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(40 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-SafeAreaBottomHeight)
            make.height.equalTo(36 * defaultScale)
            make.left.right.equalTo(0)
        }
        SPFTitlelb.snp.makeConstraints { (make) in
            make.top.equalTo(topTitleView.snp.bottom)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(23 * defaultScale)
            make.height.equalTo(38 * defaultScale)
        }
        rangSPFTitlelb.snp.makeConstraints { (make) in
            make.top.equalTo(SPFTitlelb.snp.bottom)
            make.left.width.height.equalTo(SPFTitlelb)
        }
        scoreTitlelb.snp.makeConstraints { (make) in
            make.top.equalTo(rangSPFTitlelb.snp.bottom).offset(8 * defaultScale)
            make.left.width.equalTo(SPFTitlelb)
            make.height.equalTo(266 * defaultScale)
        }
        totalTitlelb.snp.makeConstraints { (make) in
            make.top.equalTo(scoreTitlelb.snp.bottom).offset(8 * defaultScale)
            make.left.width.equalTo(SPFTitlelb)
            make.height.equalTo(38 * defaultScale)
        }
        banquanTitlelb.snp.makeConstraints { (make) in
            make.top.equalTo(totalTitlelb.snp.bottom).offset(8 * defaultScale)
            make.left.width.equalTo(SPFTitlelb)
            make.height.equalTo(114 * defaultScale)
        }
        SPFView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(SPFTitlelb)
            make.left.equalTo(SPFTitlelb.snp.right)
            make.width.equalTo(320 * defaultScale)
        }
        rangSPFView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(rangSPFTitlelb)
            make.left.equalTo(rangSPFTitlelb.snp.right)
            make.right.equalTo(SPFView)
        }
        scoreHomeView.snp.makeConstraints { (make) in
            make.top.equalTo(scoreTitlelb)
            make.left.equalTo(scoreTitlelb.snp.right)
            make.right.equalTo(SPFView)
        }
        scoreFlatView.snp.makeConstraints { (make) in
            make.top.equalTo(scoreHomeView.snp.bottom)
            make.height.equalTo(38 * defaultScale)
            make.left.equalTo(scoreHomeView)
            make.right.equalTo(scoreHomeView)
        }
        scoreVisiView.snp.makeConstraints { (make) in
            make.top.equalTo(scoreFlatView.snp.bottom)
            make.left.right.equalTo(scoreHomeView)
            make.height.equalTo(scoreHomeView)
            make.bottom.equalTo(scoreTitlelb)
        }
        totalView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(totalTitlelb)
            make.left.equalTo(totalTitlelb.snp.right)
            make.right.equalTo(SPFView)
        }
        banquanView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(banquanTitlelb)
            make.left.equalTo(banquanTitlelb.snp.right)
            make.right.equalTo(SPFView)
        }
    }
    
    // MARK: - 初始化子视图
    private func initSubview() {
        self.viewHeight = 621 * defaultScale
        
        topTitleView = TopTitleView()
        bottomView = BottomView()
        bottomView.delegate = self
        
        SPFTitlelb = getLabel()
        SPFTitlelb.font = Font10
        SPFTitlelb.backgroundColor = ColorF6AD41
        SPFTitlelb.text = "胜\n平\n负"
        
        rangSPFTitlelb = getLabel()
        rangSPFTitlelb.font = Font10
        rangSPFTitlelb.backgroundColor = Color85A5E1
        rangSPFTitlelb.text = "让\n球\n+1"
        
        scoreTitlelb = getLabel()
        scoreTitlelb.backgroundColor = Color65AADD
        scoreTitlelb.text = "比\n分"
        
        totalTitlelb = getLabel()
        totalTitlelb.font = Font10
        totalTitlelb.backgroundColor = Color6CD6C4
        totalTitlelb.text = "总\n进\n球"
        
        banquanTitlelb = getLabel()
        banquanTitlelb.backgroundColor = ColorEB6D8E
        banquanTitlelb.text = "半\n全\n场"
        
        SPFView = FootballCollectionView()
        SPFView.matchType = .胜平负
        SPFView.delegate = self 
        
        rangSPFView = FootballCollectionView()
        rangSPFView.matchType = .让球胜平负
        rangSPFView.delegate = self
        
        scoreHomeView = FootballCollectionView()
        scoreHomeView.matchType = .混合过关
        scoreHomeView.scoreType = .胜
        scoreHomeView.delegate = self
        
        scoreFlatView = FootballCollectionView()
        scoreFlatView.matchType = .混合过关
        scoreFlatView.scoreType = .平
        scoreFlatView.delegate = self
        
        scoreVisiView = FootballCollectionView()
        scoreVisiView.matchType = .混合过关
        scoreVisiView.scoreType = .负
        scoreVisiView.delegate = self
        
        totalView = FootballCollectionView()
        totalView.matchType = .总进球
        totalView.delegate = self
        
        banquanView = FootballCollectionView()
        banquanView.matchType = .半全场
        banquanView.delegate = self
        
        self.pushBgView.addSubview(topTitleView)
        self.pushBgView.addSubview(bottomView)
        self.pushBgView.addSubview(SPFTitlelb)
        self.pushBgView.addSubview(rangSPFTitlelb)
        self.pushBgView.addSubview(scoreTitlelb)
        self.pushBgView.addSubview(totalTitlelb)
        self.pushBgView.addSubview(banquanTitlelb)
        self.pushBgView.addSubview(SPFView)
        self.pushBgView.addSubview(rangSPFView)
        self.pushBgView.addSubview(scoreHomeView)
        self.pushBgView.addSubview(scoreFlatView)
        self.pushBgView.addSubview(scoreVisiView)
        self.pushBgView.addSubview(totalView)
        self.pushBgView.addSubview(banquanView)
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = ColorFFFFFF
        lab.textAlignment = .center
        lab.numberOfLines = 0
        
        return lab
    }
    
    // MARK: - 选取Item delegate
    func didSelectedItem(cellSon: FootballPlayCellModel) {
        guard selectedCells != nil else { return }

        selectedCells.append(cellSon)
        self.teamInfo.selectedHunhe = selectedCells
        
        var canAdd = true
        
        if teamInfo.selectedHunhe.count == 1 {
            canAdd = true
        }else {
            canAdd = false
        }
        
        self.selected(selectedCells, canAdd)
        
        guard didSelected != nil else { return }
        self.didSelected()
    }
    
    func didDeSelectedItem(cellSon: FootballPlayCellModel) {
        guard selectedCells != nil else { return }

        selectedCells.remove(cellSon)
        
        self.teamInfo.selectedHunhe = selectedCells
        
        var canRemove = true
        
        if self.teamInfo.selectedHunhe.count == 0 {
            canRemove = true
        }else {
            canRemove = false
        }
        
        self.deSelected(selectedCells, canRemove)
        
        guard didSelected != nil else { return }
        self.didSelected()
    }
    func didSelectedItem(cell: FootballPlayCellModel) {
        cell.isSelected = true
        guard selectedCells != nil else { return }
        selectedCells.append(cell)
        self.teamInfo.selectedHunhe = selectedCells
        
        var canAdd = true
        
        if teamInfo.selectedHunhe.count == 1 {
            canAdd = true
        }else {
            canAdd = false
        }
        
        self.selected(selectedCells, canAdd)
        
        guard didSelected != nil else { return }
        self.didSelected()
        
    }
    
    func didDeSelectedItem(cell: FootballPlayCellModel) {
        cell.isSelected = false
        guard selectedCells != nil else { return }
        selectedCells.remove(cell)
        
        self.teamInfo.selectedHunhe = selectedCells
        
        var canRemove = true
        
        if self.teamInfo.selectedHunhe.count == 0 {
            canRemove = true
        }else {
            canRemove = false
        }
        
        self.deSelected(selectedCells, canRemove)
        
        guard didSelected != nil else { return }
        self.didSelected()
    }
    func didTipConfitm() {
        
        self.teamInfo.selectedHunhe = selectedCells
        
        dismiss(animated: true, completion: nil)
    }
    
    func didTipCancel() {
        guard selected != nil else { return }
        self.teamInfo.selectedHunhe = selectedCells
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
