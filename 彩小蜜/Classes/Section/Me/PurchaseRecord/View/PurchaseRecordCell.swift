//
//  PurchaseRecordCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PurchaseRecordCell: UITableViewCell {

    // MARK: - 点击事件
    @objc private func detailClicked(_ sender : UIButton) {
        
    }
    
    // MARK: - 属性
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var timeLB : UILabel!
    private var stateBut : UIButton!
    private var stateIcon : UIImageView!
    private var detailLB : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLB.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(stateBut.snp.left).offset(-10)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(titleLB)
            make.top.equalTo(titleLB.snp.bottom).offset(5)
        }
        timeLB.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(titleLB)
            make.top.equalTo(moneyLB.snp.bottom).offset(5)
        }
        stateBut.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.right.equalTo(stateIcon.snp.left).offset(1)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.centerY.equalTo(stateBut.snp.centerY)
            make.height.width.equalTo(20)
        }
        detailLB.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(timeLB)
        }
        
        
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.text = "竞彩足球"
        titleLB.textColor = Color505050
        
        moneyLB = UILabel()
        moneyLB.font = Font13
        moneyLB.textColor = ColorA0A0A0
        moneyLB.text = "¥25.00"
        
        timeLB = UILabel()
        timeLB.font = Font12
        timeLB.textColor = ColorC8C8C8
        timeLB.text = "2018.02.03  14:15:88"
        
        stateBut = UIButton(type: .custom)
        stateBut.titleLabel?.font = Font15
        stateBut.setTitle("已中奖", for: .normal)
        stateBut.setTitleColor(ColorEA5504, for: .normal)
        stateBut.addTarget(self, action: #selector(detailClicked(_:)), for: .touchUpInside)
        
        stateIcon = UIImageView()
        stateIcon.image = UIImage(named: "redarrow")
        
        detailLB = UILabel()
        detailLB.font = Font13
        detailLB.textColor = ColorC8C8C8
        detailLB.textAlignment = .right
        detailLB.text = "中奖金额：¥ 500"
        
        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(stateBut)
        self.contentView.addSubview(stateIcon)
        self.contentView.addSubview(detailLB)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
