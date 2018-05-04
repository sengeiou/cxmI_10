//
//  WithdrawalProgressCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WithdrawalProgressCell: UITableViewCell {

    public var progressModel: ProgressLogModel! {
        didSet{
            guard progressModel != nil else { return }
            titleLB.text = progressModel.logName
            timeLB.text = progressModel.logTime
            
            if progressModel.logTime != nil , progressModel.logTime != "" {
                icon.image = UIImage(named: "Mentionmoneysteps_sel")
            }else {
                icon.image = UIImage(named: "Mentionmoneysteps_nor")
            }
        }
    }
    
    private var icon : UIImageView!
    public var topLine : UIView!
    public var bottomLine: UIView!
    private var titleLB: UILabel!
    private var timeLB: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(61 * defaultScale)
            make.width.height.equalTo(24 * defaultScale)
        }
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(0.4)
            make.centerX.equalTo(icon.snp.centerX)
            make.bottom.equalTo(icon.snp.top).offset(-1)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(1)
            make.bottom.equalTo(0)
            make.centerX.width.equalTo(topLine)
            
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.top).offset(2)
            make.left.equalTo(icon.snp.right).offset(5)
            make.right.equalTo(-10)
            make.height.equalTo(10)
        }
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(5)
            make.left.right.equalTo(titleLB)
            make.height.equalTo(10)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        icon = UIImageView()
        icon.image = UIImage(named: "Mentionmoneysteps_sel")
        
        topLine = UIView()
        topLine.backgroundColor = Color787878
        
        bottomLine = UIView()
        bottomLine.backgroundColor = Color787878
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        //titleLB.text = "提现成功"
        
        timeLB = UILabel()
        timeLB.font = Font10
        timeLB.textColor = ColorA0A0A0
        timeLB.textAlignment = .left
        //timeLB.text = "14: 00: 36"
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(timeLB)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
