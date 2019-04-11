//
//  FootballOrderRangSPFCell.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOrderRangSPFCell: UITableViewCell, DateProtocol {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            guard playInfoModel != nil else { return }
            let time = timeStampToHHmm(playInfoModel.betEndTime)
            guard let addr = playInfoModel.leagueAddr else { return }
            guard let changci = playInfoModel.changci else { return }
            
            titleLB.text = "\(addr)  \(changci)  截止\(time)"
            teamView.teamInfo = playInfoModel
            
            danIsSelected(isSelected: playInfoModel.isDan)
            setupDanBut()
            
            if playInfoModel.matchPlays[0].single == true {
                typeIcon.isHidden = false
            }else {
                typeIcon.isHidden = true
            }
        }
    }
    
    public var delegate : FootballOrderSPFCellDelegate!
    
    public var teamView: FootballTeamView!
    private var titleLB: UILabel!
    private var deleteBut : UIButton!
    private var danBut: UIButton!
    // 单关图标
    private var typeIcon : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        //setupDanBut()
    }
    
    private func setupDanBut() {
        if danMaxNum <= 0  {
            if self.playInfoModel.isDan != true {
                danBut.isUserInteractionEnabled = false
                danBut.setTitleColor(ColorC8C8C8, for: .normal)
                danBut.layer.borderColor = ColorC8C8C8.cgColor
            }
        }else {
            danBut.isUserInteractionEnabled = true
            danBut.backgroundColor = ColorFFFFFF
        }
        
        let matchPlay = self.playInfoModel.matchPlays[0]
        if !matchPlay.homeCell.isSelected && !matchPlay.flatCell.isSelected && !matchPlay.visitingCell.isSelected {
            self.playInfoModel.isDan = false
            danBut.isUserInteractionEnabled = false
            danBut.setTitleColor(ColorC8C8C8, for: .normal)
            danBut.layer.borderColor = ColorC8C8C8.cgColor
        }
    }
    private func danIsSelected(isSelected: Bool) {
        self.playInfoModel.isDan = isSelected
        
        if isSelected == true {
            danBut.layer.borderColor = ColorEA5504.cgColor
            danBut.setTitleColor(ColorEA5504, for: .selected)
        }else {
            danBut.layer.borderColor = ColorC8C8C8.cgColor
            danBut.setTitleColor(Color505050, for: .normal)
            
        }
        danBut.isSelected = isSelected
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        typeIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(typeIconSize * defaultScale)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(leftSpacing + 2)
            make.right.equalTo(-rightSpacing)
            make.bottom.equalTo(danBut.snp.top)
        }
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(teamView.snp.centerY)
            make.left.equalTo(15 * defaultScale)
            make.width.height.equalTo(playDeleteButtonSize * defaultScale)
        }
        danBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(teamView.snp.centerY)
            make.width.equalTo(31 * defaultScale)
            make.top.equalTo(self.contentView).offset(27 * defaultScale)
            make.bottom.equalTo(-11 * defaultScale)
            make.right.equalTo(-rightSpacing)
        }
        teamView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(danBut)
            make.left.equalTo(deleteBut.snp.right).offset(leftSpacing)
            make.right.equalTo(danBut.snp.left).offset(-10 * defaultScale)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(named: "Singlefield")
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "Remove"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        titleLB = UILabel()
        titleLB.font = Font12
        titleLB.textColor = Color9F9F9F
        titleLB.textAlignment = .left
        
        teamView = FootballTeamView()
        teamView.matchType = .让球胜平负
        
        danBut = UIButton(type: .custom)
        danBut.titleLabel?.font = Font12
        danBut.setTitle("胆", for: .normal)
        danBut.layer.borderWidth = 0.5
        danBut.layer.borderColor = ColorC8C8C8.cgColor
        danBut.setTitleColor(Color505050, for: .normal)
        //danBut.setTitleColor(ColorEA5504, for: .selected)
        danBut.contentHorizontalAlignment = .center
        danBut.addTarget(self , action: #selector(danClicked(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(typeIcon)
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(deleteBut)
        self.contentView.addSubview(teamView)
        self.contentView.addSubview(danBut)
    }
    // 删除
    @objc private func deleteClicked(_ sender : UIButton) {
        guard delegate != nil else { return }
        delegate.deleteOrderSPFCell(playInfo: self.playInfoModel)
    }
    // 胆
    @objc private func danClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        danIsSelected(isSelected: sender.isSelected)
        if sender.isSelected == true {
            guard delegate != nil else { return }
            delegate.danSelected()
            
        }else {
            guard delegate != nil else { return }
            delegate.danDeSelected()
        }
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
