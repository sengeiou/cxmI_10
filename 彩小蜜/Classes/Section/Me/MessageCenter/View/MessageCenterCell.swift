//
//  MessageCenterCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MessageCenterCell: UITableViewCell {

    public var messageModel: MessageCenterModel! {
        didSet{
            titleLB.text = messageModel.title
            timeLB.text = messageModel.sendTime
            moneyLB.text = messageModel.content
            detailLB.text = messageModel.msgDesc
            stateLB.text = messageModel.contentDesc
            
            switch messageModel.objectType {
            case "0":
                moneyLB.textColor = ColorE95504
            default:
                moneyLB.textColor = Color505050
            }
            
        }
    }
    
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var timeLB : UILabel!
    private var stateLB: UILabel!
    private var detailLB: UILabel!
    
    private var detailTitle : UILabel!
    private var detailIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(16 * defaultScale)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.width.equalTo(100 * defaultScale)
            make.height.equalTo(15 * defaultScale)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(5)
            make.left.height.equalTo(titleLB)
            make.right.equalTo(self.contentView.snp.centerX).offset(-20)
        }
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB).offset(5)
            make.left.equalTo(titleLB.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.equalTo(10 * defaultScale)
        }
        stateLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB)
            make.left.equalTo(self.contentView.snp.centerX).offset(-20)
            make.height.equalTo(12 * defaultScale)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        detailLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB.snp.bottom)
            make.bottom.equalTo(self.contentView).offset(-10 * defaultScale)
            make.left.equalTo(moneyLB)
            make.right.equalTo(detailTitle.snp.left).offset(-10)
        }
        detailTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(-16 * defaultScale)
            make.height.equalTo(timeLB)
            make.width.equalTo(100)
            make.right.equalTo(detailIcon.snp.left).offset(1)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailTitle.snp.centerY)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.width.equalTo(12)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        //titleLB.text = "中奖通知"
        
        moneyLB = UILabel()
        moneyLB.font = Font15
        moneyLB.textColor = ColorE95504
        moneyLB.textAlignment = .left
        //moneyLB.text = "中奖3000.00元"
        
        timeLB = UILabel()
        timeLB.font = Font10
        timeLB.textColor = ColorC8C8C8
        timeLB.textAlignment = .left
        //timeLB.text = "01月30日 08： 30"
        
        detailLB = UILabel()
        detailLB.font = Font10
        detailLB.textColor = ColorC8C8C8
        detailLB.textAlignment = .left
        detailLB.numberOfLines = 0
//        detailLB.text =
//        """
//        彩种： 精彩足球
//        投注金额： 50.00元
//        投注时间： 2018年02月03日
//        """
        
        stateLB = UILabel()
        stateLB.font = Font12
        stateLB.textColor = Color787878
        stateLB.textAlignment = .left
        //stateLB.text = "奖金已打入您的可用余额"
        
        detailTitle = UILabel()
        detailTitle.font = Font10
        detailTitle.textColor = Color787878
        detailTitle.textAlignment = .right
        detailTitle.text = "查看详情"
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(stateLB)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(detailTitle)
        self.contentView.addSubview(detailIcon)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
