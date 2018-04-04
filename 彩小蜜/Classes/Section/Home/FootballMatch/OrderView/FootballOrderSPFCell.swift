//
//  FootballOrderSPFCell.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOrderSPFCell: UITableViewCell {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            titleLB.text = playInfoModel.leagueAddr
            teamView.teamInfo = playInfoModel
            
        }
    }
    
    public var teamView: FootballTeamView!
    private var titleLB: UILabel!
    private var deleteBut : UIButton!
    private var danBut: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.height.equalTo(20)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(teamView.snp.centerY)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(22)
        }
        danBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(teamView.snp.centerY)
            make.width.equalTo(28 * defaultScale)
            make.top.equalTo(titleLB.snp.bottom).offset(5 * defaultScale)
            make.bottom.equalTo(-10 * defaultScale)
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
        deleteBut.setBackgroundImage(UIImage(named: "sut"), for: .normal)
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
        danBut.setTitleColor(ColorEA5504, for: .selected)
        danBut.contentHorizontalAlignment = .center
        danBut.addTarget(self , action: #selector(danClicked(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(deleteBut)
        self.contentView.addSubview(teamView)
        self.contentView.addSubview(danBut)
    }
    // 删除
    @objc private func deleteClicked(_ sender : UIButton) {
        
    }
    // 胆
    @objc private func danClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            sender.layer.borderColor = ColorEA5504.cgColor
        }else {
            sender.layer.borderColor = ColorC8C8C8.cgColor
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
