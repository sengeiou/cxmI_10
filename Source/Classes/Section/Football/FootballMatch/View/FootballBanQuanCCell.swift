//
//  FootballBanQuanCCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  半全场

import UIKit

protocol FootballBanQuanCCellDelegate {
    func didTipBanQuanCCellDetail(teamInfo : FootballPlayListModel) -> Void
    func didTipStopSelling(cell: FootballBanQuanCCell, teamInfo : FootballPlayListModel) -> Void
}

class FootballBanQuanCCell: UITableViewCell, DateProtocol, FootballStopSellingViewDelegate {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            guard playInfoModel != nil else { return }
            
            changSellingState(isStop: playInfoModel.isShutDown )
            
            if playInfoModel.homeTeamRank != nil && playInfoModel.homeTeamRank != "" {
                homeMatch.text = "[\(playInfoModel.homeTeamRank!)]" + playInfoModel.homeTeamAbbr
            }else {
                homeMatch.text = playInfoModel.homeTeamAbbr
            }
            
            if playInfoModel.visitingTeamRank != nil && playInfoModel.visitingTeamRank != "" {
                visitingMatch.text = "[\(playInfoModel.visitingTeamRank!)]" + playInfoModel.visitingTeamAbbr
            }else {
                visitingMatch.text = playInfoModel.visitingTeamAbbr
            }
            
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            scoreView.teamInfo = playInfoModel
            endTime.text = "截止" + timeStampToHHmm(playInfoModel.betEndTime)
            if playInfoModel.matchPlays[0].single == true {
                typeIcon.isHidden = false
            }else {
                typeIcon.isHidden = true
            }
        }
    }
    
    public var delegate : FootballBanQuanCCellDelegate!
    
    public var scoreView: FootballScoreView!
    
    private var matchTitle: UILabel!
    private var matchTime: UILabel!
    private var endTime: UILabel!
    private var detailBut: UIButton!
    
    private var homeMatch: UILabel!
    private var visitingMatch : UILabel!
    private var vsLb : UILabel!
    
    // 单关图标
    private var typeIcon : UIImageView!
    
    private var line : UIImageView!
    
    private var stopSellingView: FootballStopSellingView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func changSellingState(isStop: Bool) {
        if isStop {
            scoreView.alpha = 0.2
            stopSellingView.isHidden = false
        }else {
            scoreView.alpha = 1
            stopSellingView.isHidden = true
        }
    }
    func didTipDetails(view: UIView) {
        guard delegate != nil else { return }
        delegate.didTipStopSelling(cell: self, teamInfo: self.playInfoModel)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(1)
        }
        
        typeIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(typeIconSize * defaultScale)
        }
        
        matchTitle.snp.makeConstraints { (make) in
            make.top.equalTo(13.5 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(endTime)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.equalTo(matchTitle.snp.bottom).offset(2)
            make.left.width.height.equalTo(endTime)
        }
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(leftSpacing)
            make.top.equalTo(matchTime.snp.bottom).offset(2)
            make.bottom.equalTo(detailBut.snp.top).offset(-2)
            make.width.equalTo(70 * defaultScale)
        }
        detailBut.snp.makeConstraints { (make) in
            make.centerX.equalTo(endTime.snp.centerX)
            make.top.equalTo(endTime.snp.bottom)
            make.width.equalTo(endTime)
            make.bottom.equalTo(-1)
        }
        
        homeMatch.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(scoreView.snp.top)
            make.left.equalTo(scoreView)
            make.right.equalTo(vsLb.snp.left)
        }
        vsLb.snp.makeConstraints { (make) in
            make.width.equalTo(50 * defaultScale)
            make.top.bottom.equalTo(homeMatch)
            make.centerX.equalTo(scoreView.snp.centerX)
        }
        visitingMatch.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeMatch)
            make.left.equalTo(vsLb.snp.right)
            make.right.equalTo(scoreView)
        }
        
        scoreView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-18 * defaultScale)
            make.height.equalTo(28 * defaultScale)
            make.left.equalTo(endTime.snp.right).offset(10 * defaultScale)
            make.right.equalTo(-rightSpacing)
        }
        stopSellingView.snp.makeConstraints { (make) in
            make.top.equalTo(scoreView)
            make.bottom.equalTo(scoreView)
            make.left.equalTo(scoreView)
            make.right.equalTo(scoreView)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        scoreView = FootballScoreView()
        scoreView.matchType = .半全场
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(named: "Singlefield")
        
        matchTitle = initLabel()
        
        matchTime = initLabel()
        
        endTime = initLabel()
        endTime.sizeToFit()
        
        detailBut = UIButton(type: .custom)
        detailBut.setImage(UIImage(named: "Collapse"), for: .normal)
        detailBut.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 5, right: 0)
        detailBut.titleLabel?.numberOfLines = 2
        detailBut.addTarget(self, action: #selector(detailButClicked(_:)), for: .touchUpInside)
        
        homeMatch = initLabel()
        homeMatch.font = Font14
        homeMatch.textColor = Color505050
        vsLb = initLabel()
        vsLb.text = "VS"
        vsLb.font = Font14
        vsLb.textColor = Color787878
        visitingMatch = initLabel()
        visitingMatch.font = Font14
        visitingMatch.textColor = Color505050
        
        stopSellingView = FootballStopSellingView()
        stopSellingView.vertical = false
        stopSellingView.delegate = self 
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(matchTitle)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(endTime)
        self.contentView.addSubview(detailBut)
        self.contentView.addSubview(scoreView)
        self.contentView.addSubview(homeMatch)
        self.contentView.addSubview(vsLb)
        self.contentView.addSubview(visitingMatch)
        self.contentView.addSubview(stopSellingView)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        //lab.text = "截止23： 50"
        return lab
    }
    @objc private func detailButClicked(_ sender : UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipBanQuanCCellDetail(teamInfo: self.playInfoModel)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
