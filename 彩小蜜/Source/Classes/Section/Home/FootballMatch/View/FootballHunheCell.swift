//
//  FootballHunheCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  混合过关

import UIKit


protocol FootballHunheCellDelegate {
    func didTipHunheCellDetail(teamInfo : FootballPlayListModel) -> Void
    func didTipMoreButton(view : FootballHunheView, rangView : FootballHunheView, teamInfo : FootballPlayListModel) -> Void
}

class FootballHunheCell: UITableViewCell, DateProtocol {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            guard playInfoModel != nil else { return }
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            teamView.teamInfo = playInfoModel
            teamView.index = index
            rangTeamView.teamInfo = playInfoModel
            rangTeamView.index = index
            topTitleView.teamInfo = playInfoModel
            endTime.text = "截止" + timeStampToHHmm(playInfoModel.betEndTime)
            
            typeIcon.isHidden = true
            
            for match in playInfoModel.matchPlays {
                if match.playType == "1" {
                    if match.single == true {
                        typeIcon.isHidden = false
                    }

                    if match.fixedOdds < 0 {
                        rangTeamlb.backgroundColor = Color85C36b
                        rangTeamlb.text = "\(match.fixedOdds!)"
                    }else {
                        rangTeamlb.backgroundColor = ColorF6AD41
                        rangTeamlb.text = "+\(match.fixedOdds!)"
                    }
                    rangTeamView.matchInfo = match
                }
                if match.playType == "2" {
                    if match.single == true {
                        typeIcon.isHidden = false
                    }
                    teamView.matchInfo = match
                }
            }
            
            if playInfoModel.selectedHunhe.isEmpty == false {
                let muAtt = NSMutableAttributedString(string: "已选\n", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
                let num = NSAttributedString(string: "\(playInfoModel.selectedHunhe.count)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                let 项 = NSAttributedString(string: "项", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
                muAtt.append(num)
                muAtt.append(项)
                
                moreBut.setAttributedTitle(muAtt, for: .normal)
            }else {
                let att = NSAttributedString(string: "更多\n玩法", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
                moreBut.setAttributedTitle(att, for: .normal)
            }
            
            // 2 为 胜平负，1为让球胜平负
//            guard playInfoModel.matchPlays[0].playType == "1" else { return }
//
//            let rangMatchPlay = playInfoModel.matchPlays[0]
//
//            rangTeamlb.text = "\(rangMatchPlay.fixedOdds!)"
//            if rangMatchPlay.fixedOdds < 0 {
//                rangTeamlb.backgroundColor = Color85C36b
//            }else {
//                rangTeamlb.backgroundColor = ColorF6AD41
//            }
            
        }
    }
    
    public var delegate : FootballHunheCellDelegate!
    
    public var index : IndexPath!
    
    private var matchTitle: UILabel!
    private var matchTime: UILabel!
    private var endTime: UILabel!
    private var detailBut: UIButton!
    public var teamView: FootballHunheView!
    public var rangTeamView: FootballHunheView!
    private var topTitleView : TopTitleView!
    
    private var moreBut: UIButton!
    private var teamlb : UILabel! // 胜平负
    private var rangTeamlb : UILabel! // 让球胜平负
    // 单关图标
    private var typeIcon : UIImageView!
    
    private var line : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
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
            make.top.equalTo(20 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(endTime)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.equalTo(matchTitle.snp.bottom).offset(2)
            make.left.width.height.equalTo(endTime)
        }
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(10 * defaultScale)
            make.top.equalTo(matchTime.snp.bottom).offset(2)
            make.bottom.equalTo(detailBut.snp.top).offset(-2)
            make.width.equalTo(70 * defaultScale)
        }
        detailBut.snp.makeConstraints { (make) in
            make.centerX.equalTo(endTime.snp.centerX)
            make.top.equalTo(endTime.snp.bottom)
            make.width.equalTo(endTime)
            make.bottom.equalTo(-20 * defaultScale)
        }
        topTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(teamView.snp.top)
            make.left.right.equalTo(teamView)
        }
        teamView.snp.makeConstraints { (make) in
            make.top.equalTo(35 * defaultScale)
            make.left.equalTo(teamlb.snp.right)
            make.right.equalTo(moreBut.snp.left)
        }
        rangTeamView.snp.makeConstraints { (make) in
            make.top.equalTo(teamView.snp.bottom)
            make.left.right.height.equalTo(teamView)
            make.bottom.equalTo(-15 * defaultScale)
        }
        
        teamlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(teamView)
            make.width.equalTo(25 * defaultScale)
            make.left.equalTo(endTime.snp.right).offset(5)
        }
        rangTeamlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(rangTeamView)
            make.left.width.equalTo(teamlb)
        }
        moreBut.snp.makeConstraints { (make) in
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(35 * defaultScale)
            make.top.equalTo(teamView)
            make.bottom.equalTo(rangTeamView)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        topTitleView = TopTitleView()
        
        teamView = FootballHunheView()
        teamView.matchType = .胜平负
        rangTeamView = FootballHunheView()
        rangTeamView.matchType = .让球胜平负
        
        teamlb = initLabel()
        teamlb.text = "0"
        teamlb.textColor = ColorFFFFFF
        teamlb.backgroundColor = ColorC7C7C7
        
        rangTeamlb = initLabel()
        rangTeamlb.textColor = ColorFFFFFF
        
        
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
        
        moreBut = UIButton(type: .custom)
        moreBut.setTitle("更多\n玩法", for: .normal)
        moreBut.setTitleColor(Color787878, for: .normal)
        moreBut.titleLabel?.font = Font12
        moreBut.titleLabel?.numberOfLines = 0
        moreBut.layer.borderWidth = 0.3
        moreBut.layer.borderColor = ColorC8C8C8.cgColor
        moreBut.addTarget(self, action: #selector(moreButClicked(_:)), for: .touchUpInside)
        
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(teamView)
        self.contentView.addSubview(rangTeamView)
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(matchTitle)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(endTime)
        self.contentView.addSubview(detailBut)
        self.contentView.addSubview(teamlb)
        self.contentView.addSubview(rangTeamlb)
        self.contentView.addSubview(moreBut)
        self.contentView.addSubview(topTitleView)
    }
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color787878
        lab.textAlignment = .center
        lab.text = "截止23： 50"
        return lab
    }
    @objc private func detailButClicked(_ sender : UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipHunheCellDetail(teamInfo: self.playInfoModel)
    }
    @objc private func moreButClicked(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipMoreButton(view: teamView, rangView: rangTeamView, teamInfo: playInfoModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
