//
//  OrderDetailTitleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let OrderDetailTitleWidth : CGFloat = 70 * defaultScale

class OrderDetailTitleCell: UITableViewCell {

    public var matchInfo: MatchInfo! {
        didSet{
            guard matchInfo != nil else { return }
            guard let range = matchInfo.match.range(of: "VS") else { return }
            
            let homeMatch = matchInfo.match.prefix(upTo: (range.lowerBound))
            let viMatch = matchInfo.match.suffix(from: range.upperBound)
            
            let record = NSMutableAttributedString()
            var resultStr = ""
            var ruleStr = ""
            
            var i = 1
            for result in matchInfo.cathecticResults {
                for cath in result.cathectics {
                    let color : UIColor!
                    if cath.isGuess == true {
                        color = ColorEA5504
                    }else {
                        color = Color505050
                    }
                    let cathectic = cath.cathectic.replacingOccurrences(of: "null", with: "")

                    let rec = NSAttributedString(string: "\(cathectic)\n", attributes: [NSAttributedStringKey.foregroundColor: color])
                        
                    record.append(rec)
                }
                resultStr += result.matchResult + "\n"
                ruleStr += result.playType + "\n"
                
                i += 1
            }
            if ruleStr != "" {
                ruleStr.removeLast()
                ruleLB.text = ruleStr
            }
            if resultStr != "" {
                resultStr.removeLast()
            }
            
            
            nameLB.text = "\(homeMatch)\nVS\n\(viMatch)"
            
            matchInfo.changci.insert("\n", at: matchInfo.changci.index(matchInfo.changci.startIndex, offsetBy: 2))
            
            timeLB.text = matchInfo.changci
            recordLB.attributedText = record
            resultLB.text = resultStr
            
        }
    }
    
    private var timeTitle : UILabel!
    private var timeLB : UILabel!
    private var nameTitle: UILabel!
    private var nameLB : UILabel!
    private var ruleTitle: UILabel!    // 玩法
    private var ruleLB : UILabel!
    private var recordTitle: UILabel!  // 投注
    private var recordLB: UILabel!
    private var resultTitle: UILabel!  // 赛果
    private var resultLB : UILabel!
    
    private var sectionTitle : UILabel!
    private var line : UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font14
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "方案内容"
        
        timeTitle = getTitleLB("场次")
        timeTitle.textAlignment = .left
        nameTitle = getTitleLB("赛事")
        ruleTitle = getTitleLB("玩法")
       
        recordTitle = getTitleLB("投注")
        resultTitle = getTitleLB("赛果")
        resultTitle.textAlignment = .right
        
        timeLB = getDetailLB()
        timeLB.textAlignment = .left
        timeLB.numberOfLines = 0
        nameLB = getDetailLB()
        nameLB.numberOfLines = 0
        ruleLB = getDetailLB()
        ruleLB.numberOfLines = 0
        recordLB = getDetailLB()
        recordLB.numberOfLines = 0
        resultLB = getDetailLB()
        resultLB.numberOfLines = 0
        resultLB.textAlignment = .right
        
       
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(timeTitle)
        self.contentView.addSubview(nameTitle)
        self.contentView.addSubview(ruleTitle)
        self.contentView.addSubview(recordTitle)
        self.contentView.addSubview(resultTitle)
        
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(ruleLB)
        self.contentView.addSubview(recordLB)
        self.contentView.addSubview(resultLB)
        
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(orderSectionHeaderHeight)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        sectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(11)
            make.bottom.equalTo(line.snp.top).offset(-11)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
        timeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(11)
            make.left.equalTo(self.contentView).offset(26)
            make.width.equalTo(40 * defaultScale)
            make.height.equalTo(12)
        }
        nameTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeTitle)
            make.left.equalTo(timeTitle.snp.right).offset(1)
            //make.right.equalTo(ruleTitle.snp.left).offset(-1)
        }
        ruleTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeTitle)
            make.width.equalTo(nameTitle)
            make.left.equalTo(nameTitle.snp.right).offset(1)
            make.right.equalTo(recordTitle.snp.left).offset(-1)
        }
        recordTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeTitle)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(resultTitle.snp.left).offset(-1)
        }
        
        resultTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeTitle)
            make.width.equalTo(OrderDetailTitleWidth - 30)
            make.right.equalTo(self.contentView).offset(-26)
        }
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeTitle.snp.bottom).offset(11 * defaultScale)
            make.bottom.equalTo(self.contentView).offset(-11 * defaultScale)
            make.width.equalTo(timeTitle)
            make.left.equalTo(self.contentView).offset(leftSpacing)
        }
        nameLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeTitle.snp.bottom).offset(11 * defaultScale)
            make.bottom.equalTo(self.contentView).offset(-11 * defaultScale)
            make.left.equalTo(timeLB.snp.right).offset(1)
            make.right.equalTo(ruleLB.snp.left).offset(-1)
        }
        
        ruleLB.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeLB)
            make.width.equalTo(nameLB)
            make.right.equalTo(recordLB.snp.left).offset(-1)
        }
        
        recordLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeLB)
            make.bottom.equalTo(self.contentView).offset(1)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(resultLB.snp.left).offset(-1)
        }
        
        resultLB.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeLB)
            make.width.equalTo(OrderDetailTitleWidth - 30)
            make.right.equalTo(self.contentView).offset(-26)
        }
    }
    
    private func getTitleLB(_ text: String) -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.text = text
        lab.textColor = ColorA0A0A0
        
        lab.textAlignment = .center
        return lab
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color505050
        lab.textAlignment = .center
        //lab.backgroundColor = ColorEA5504
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
