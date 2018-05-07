//
//  FootballOrderHunheCell.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOrderHunheCell: UITableViewCell {

    public var playInfoModel: FootballPlayListModel! {
        didSet{
            guard playInfoModel != nil else { return }
            homeMatch.text = playInfoModel.homeTeamAbbr
            visitingMatch.text = playInfoModel.visitingTeamAbbr
            scoreView.teamInfo = playInfoModel
            
            danIsSelected(isSelected: playInfoModel.isDan)
            setupDanBut()
        }
    }
    
    public var delegate : FootballOrderSPFCellDelegate!
    
    private var deleteBut : UIButton!
    private var danBut: UIButton!
    
    public var scoreView: FootballScoreView!
    private var homeMatch: UILabel!
    private var visitingMatch : UILabel!
    private var vsLb : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
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
        
        var selected = false
        
        for cell in playInfoModel.selectedHunhe {
            if cell.isSelected == true {
                selected = true
                break
            }
        }
        
        if selected == false {
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
    
    private func initSubview() {
        self.selectionStyle = .none
        
        deleteBut = UIButton(type: .custom)
        deleteBut.setBackgroundImage(UIImage(named: "Remove"), for: .normal)
        deleteBut.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        
        scoreView = FootballScoreView()
        scoreView.matchType = .混合过关
        
        danBut = UIButton(type: .custom)
        danBut.titleLabel?.font = Font12
        danBut.setTitle("胆", for: .normal)
        danBut.layer.borderWidth = 0.3
        danBut.layer.borderColor = ColorC8C8C8.cgColor
        danBut.setTitleColor(Color505050, for: .normal)

        danBut.contentHorizontalAlignment = .center
        danBut.addTarget(self , action: #selector(danClicked(_:)), for: .touchUpInside)
        
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
        
        self.contentView.addSubview(deleteBut)
        self.contentView.addSubview(scoreView)
        self.contentView.addSubview(danBut)
        self.contentView.addSubview(homeMatch)
        self.contentView.addSubview(vsLb)
        self.contentView.addSubview(visitingMatch)
        
        
        deleteBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(scoreView.snp.centerY)
            make.left.equalTo(15 * defaultScale)
            make.width.height.equalTo(playDeleteButtonSize * defaultScale)
        }
        danBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(31 * defaultScale)
//            make.top.equalTo(self.contentView).offset(27 * defaultScale)
//            make.bottom.equalTo(scoreView)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(53 * defaultScale)
        }
        homeMatch.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(scoreView.snp.top)
            make.left.equalTo(scoreView)
        }
        vsLb.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(homeMatch.snp.right)
        }
        visitingMatch.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(homeMatch)
            make.left.equalTo(vsLb.snp.right)
            make.right.equalTo(scoreView)
        }
        
        scoreView.snp.makeConstraints { (make) in
            make.top.equalTo(40 * defaultScale)
            make.bottom.equalTo(-15 * defaultScale)
            make.left.equalTo(deleteBut.snp.right).offset(leftSpacing)
            make.right.equalTo(danBut.snp.left).offset(-10 * defaultScale)
        }
    }
    
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font14
        lab.textColor = Color787878
        lab.textAlignment = .center
        lab.text = "截止23： 50"
        return lab
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
