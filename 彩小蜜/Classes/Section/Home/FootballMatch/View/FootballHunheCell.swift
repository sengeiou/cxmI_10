//
//  FootballHunheCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//  混合过关

import UIKit

protocol FootballHunheCellDelegate {
    func didTipMoreButton(teamInfo : FootballPlayListModel) -> Void
}

class FootballHunheCell: UITableViewCell, DateProtocol {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            matchTitle.text = playInfoModel.leagueAddr
            matchTime.text = playInfoModel.changci
            teamView.teamInfo = playInfoModel
            rangTeamView.teamInfo = playInfoModel
            topTitleView.teamInfo = playInfoModel
            endTime.text = "截止" + timeStampToHHmm(playInfoModel.betEndTime)
            if playInfoModel.matchPlays[0].single == true ||
                playInfoModel.matchPlays[1].single == true {
                typeIcon.isHidden = false
            }else {
                typeIcon.isHidden = true
            }
            
            // 2 为 胜平负，1为让球胜平负
            guard playInfoModel.matchPlays[0].playType == "1" else { return }
            
            let rangMatchPlay = playInfoModel.matchPlays[0]
            
            rangTeamlb.text = "\(rangMatchPlay.fixedOdds!)"
            if rangMatchPlay.fixedOdds < 0 {
                rangTeamlb.backgroundColor = Color85C36b
            }else {
                rangTeamlb.backgroundColor = ColorF6AD41
            }
            
        }
    }
    
    public var delegate : FootballHunheCellDelegate!
    
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
            make.width.height.equalTo(20)
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
            make.width.height.equalTo(20)
            make.bottom.equalTo(-10)
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
            make.left.equalTo(endTime.snp.right).offset(10)
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
        detailBut.titleLabel?.numberOfLines = 2
        
        moreBut = UIButton(type: .custom)
        moreBut.setTitle("更多\n玩法", for: .normal)
        moreBut.setTitleColor(Color787878, for: .normal)
        moreBut.titleLabel?.font = Font12
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
    
    @objc private func moreButClicked(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.didTipMoreButton(teamInfo: playInfoModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
