//
//  FootballBanQuanCFilterC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

typealias SelectedCell  = (_ selectedCells : [FootballPlayCellModel]) -> ()

class FootballBanQuanCFilterVC: BasePopViewController, BottomViewDelegate, FootballCollectionViewDelegate {
    
    

    public var teamInfo : FootballPlayListModel! {
        didSet{
            homeTeam.text = teamInfo.homeTeamAbbr
            visitingTeam.text = teamInfo.visitingTeamAbbr
            banScoreView.cells = teamInfo.matchPlays[0].matchCells
            
            guard teamInfo.selectedBan != nil else { return }
            selectedCells = teamInfo.selectedBan
        }
    }
    
    public var selected : SelectedCell!
    public var selectedCells : [FootballPlayCellModel]!
    
    private var homeTeam : UILabel!
    private var vslb : UILabel!
    private var visitingTeam : UILabel!
    
    private var banScoreView : FootballCollectionView!
    
    private var shengTitle: UILabel!

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
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(23 * defaultScale)
        }
        
        banScoreView.snp.makeConstraints { (make) in
            make.top.equalTo(shengTitle)
            make.left.equalTo(shengTitle.snp.right)
            make.width.equalTo(320 * defaultScale)
            make.height.equalTo(shengTitle)
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
        shengTitle.backgroundColor = ColorEB6D8E
        shengTitle.textAlignment = .center
        shengTitle.text = "半全场"
        
        
        banScoreView = FootballCollectionView()
        banScoreView.scoreType = .半全场
        banScoreView.delegate = self
        
        
        bottomView = BottomView()
        bottomView.delegate = self
        
        self.pushBgView.addSubview(homeTeam)
        self.pushBgView.addSubview(vslb)
        self.pushBgView.addSubview(visitingTeam)
        self.pushBgView.addSubview(shengTitle)
        self.pushBgView.addSubview(banScoreView)
        self.pushBgView.addSubview(bottomView)
    }
    
    // MARK: - 选取Item delegate
    func didSelectedItem(cellSon: SonCellModel) {
        
    }
    
    func didDeSelectedItem(cellSon: SonCellModel) {
       
    }
    
    func didSelectedItem(cell: FootballPlayCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.append(cell)
    }
    
    func didDeSelectedItem(cell: FootballPlayCellModel) {
        guard selectedCells != nil else { return }
        selectedCells.remove(cell)
    }
    
    func didTipConfitm() {
        guard selected != nil else { return }
        self.teamInfo.selectedBan = selectedCells
        self.selected(selectedCells)
        dismiss(animated: true, completion: nil)
    }
    
    func didTipCancel() {
        guard selected != nil else { return }
        self.teamInfo.selectedBan = selectedCells
        self.selected(selectedCells)
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
