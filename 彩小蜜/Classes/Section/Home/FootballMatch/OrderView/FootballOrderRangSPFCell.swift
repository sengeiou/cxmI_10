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
            let time = timeStampToHHmm(playInfoModel.betEndTime)
            guard let addr = playInfoModel.leagueAddr else { return }
            guard let changci = playInfoModel.changci else { return }
            
            titleLB.text = "\(addr)  \(changci)  截止\(time)"
            teamView.teamInfo = playInfoModel
            setupDanBut()
            danIsSelected(isSelected: playInfoModel.isDan)
        }
    }
    
    public var delegate : FootballOrderSPFCellDelegate!
    
    public var teamView: FootballTeamView!
    private var titleLB: UILabel!
    private var deleteBut : UIButton!
    private var danBut: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        //setupDanBut()
    }
    
    private func setupDanBut() {
        if danMaxNum <= 0  {
            if self.playInfoModel.isDan != true {
                danBut.isUserInteractionEnabled = false
                danBut.backgroundColor = Color787878
            }
        }else {
            danBut.isUserInteractionEnabled = true
            danBut.backgroundColor = ColorFFFFFF
        }
        
        if !self.playInfoModel.homeCell.isSelected && !self.playInfoModel.flatCell.isSelected && !self.playInfoModel.visitingCell.isSelected {
            self.playInfoModel.isDan = false
            danBut.isUserInteractionEnabled = false
            danBut.backgroundColor = Color787878
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
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.bottom.equalTo(danBut.snp.top)
        }
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(teamView.snp.centerY)
            make.left.equalTo(15 * defaultScale)
            make.width.height.equalTo(24 * defaultScale)
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
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "Remove"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        
        teamView = FootballTeamView()
        
        danBut = UIButton(type: .custom)
        danBut.setTitle("胆", for: .normal)
        danBut.layer.borderWidth = 0.3
        danBut.layer.borderColor = ColorC8C8C8.cgColor
        danBut.setTitleColor(Color505050, for: .normal)
        //danBut.setTitleColor(ColorEA5504, for: .selected)
        danBut.contentHorizontalAlignment = .center
        danBut.addTarget(self , action: #selector(danClicked(_:)), for: .touchUpInside)
        
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
