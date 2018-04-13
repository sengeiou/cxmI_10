//
//  FootballScoreFilterVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

typealias Selected  = (_ selectedCells : [SonCellModel], _ canAdd : Bool) -> ()
typealias DeSelected = (_ selectedCells : [SonCellModel], _ canRemove : Bool) -> ()
typealias SelectedItem = () -> ()

class FootballScoreFilterVC: BasePopViewController, BottomViewDelegate, FootballCollectionViewDelegate {
    
    public var teamInfo : FootballPlayListModel! {
        didSet{
            homeTeam.text = teamInfo.homeTeamAbbr
            visitingTeam.text = teamInfo.visitingTeamAbbr
            shengScoreView.cellSons = teamInfo.matchPlays[0].homeCell.cellSons
            pingScoreView.cellSons = teamInfo.matchPlays[0].flatCell.cellSons
            fuScoreView.cellSons = teamInfo.matchPlays[0].visitingCell.cellSons
            
            guard teamInfo.selectedScore != nil else { return }
            selectedCells = teamInfo.selectedScore
            currentSelectedCells = teamInfo.selectedScore
        }
    }

    public var selected : Selected!
    public var deSelected : DeSelected!
    public var didSelected : SelectedItem!
    private var selectedCells : [SonCellModel]!
    
    private var currentSelectedCells : [SonCellModel]!
    
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
        selectedCells = [SonCellModel]()
        currentSelectedCells = [SonCellModel]()
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
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(23 * defaultScale)
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
            make.width.equalTo(320 * defaultScale)
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
    func didSelectedItem(cellSon: SonCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.append(cellSon)
        self.teamInfo.selectedScore = selectedCells
        
        var canAdd = true
        
        if teamInfo.selectedScore.count == 1 {
            canAdd = true
        }else {
            canAdd = false
        }

        self.selected(selectedCells, canAdd)

        guard didSelected != nil else { return }
        self.didSelected()
    }
    
    func didDeSelectedItem(cellSon: SonCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.remove(cellSon)
        
        self.teamInfo.selectedScore = selectedCells
        
        var canRemove = true 
        
        if self.teamInfo.selectedScore.count == 0 {
            canRemove = true
        }else {
            canRemove = false
        }
        
        self.deSelected(selectedCells, canRemove)
        
        guard didSelected != nil else { return }
        self.didSelected()
    }
    func didSelectedItem(cell: FootballPlayCellModel) {
    }
    
    func didDeSelectedItem(cell: FootballPlayCellModel) {
    }
    func didTipConfitm() {
        guard selected != nil else { return }
        self.teamInfo.selectedScore = selectedCells
        //self.selected(selectedCells)
        dismiss(animated: true, completion: nil)
    }
    
    func didTipCancel() {
        guard selected != nil else { return }
        self.teamInfo.selectedScore = selectedCells
        //self.selected(selectedCells)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}
