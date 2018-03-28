//
//  OrderDetailCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    public var matchInfo: MatchInfo! {
        didSet{
            timeLB.text = matchInfo.changci
            nameLB.text = matchInfo.match
            ruleLB.text = matchInfo.playType
            recordLB.text = matchInfo.cathectic
            resultLB.text = matchInfo.result
            
            if matchInfo.matchResult == "0" {
                recordLB.textColor = Color505050
                resultLB.textColor = Color505050
            }else if matchInfo.matchResult == "1" {
                recordLB.textColor = ColorE95504
                resultLB.textColor = ColorE95504
            }
        }
    }

    private var timeLB : UILabel!
    private var nameLB : UILabel!
    private var ruleLB : UILabel!
    private var recordLB: UILabel!
    private var resultLB : UILabel!
    private var line : UIImageView!
    private var oddsIcon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(11)
            make.bottom.equalTo(self.contentView).offset(-11)
            make.width.equalTo(OrderDetailTitleWidth)
            make.left.equalTo(self.contentView).offset(leftSpacing)
        }
        nameLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeLB)
            make.left.equalTo(timeLB.snp.right).offset(1)
            make.right.equalTo(ruleLB.snp.left).offset(-1)
            make.bottom.equalTo(timeLB)
        }
        ruleLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeLB)
            make.right.equalTo(recordLB.snp.left).offset(-1)
        }
        
        recordLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(oddsIcon.snp.top).offset(-5)
            
            make.width.equalTo(timeLB)
            make.right.equalTo(resultLB.snp.left).offset(-1)
        }
        
        oddsIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(8)
            make.centerX.equalTo(recordLB.snp.centerX)
            make.bottom.equalTo(timeLB)
        }
        resultLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeLB)
            make.right.equalTo(self.contentView).offset(-26)
        }
        
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named:"line")
        
        timeLB = getDetailLB()
        timeLB.textAlignment = .left
        nameLB = getDetailLB()
        nameLB.numberOfLines = 3
        ruleLB = getDetailLB()
        recordLB = getDetailLB()
        recordLB.numberOfLines = 2
        resultLB = getDetailLB()
        resultLB.textAlignment = .right
        
        oddsIcon = UIImageView()
        oddsIcon.image = UIImage(named: "guess")
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(ruleLB)
        self.contentView.addSubview(recordLB)
        self.contentView.addSubview(resultLB)
        self.contentView.addSubview(oddsIcon)
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        //lab.text = "白塞"
        lab.textColor = Color505050
        lab.textAlignment = .center
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
