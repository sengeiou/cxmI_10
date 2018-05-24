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
            guard matchInfo != nil else { return }
            guard let range = matchInfo.match.range(of: "VS") else { return }
            
            let homeMatch = matchInfo.match.prefix(upTo: (range.lowerBound))
            let viMatch = matchInfo.match.suffix(from: range.upperBound)
            
            
            nameLB.text = "\(homeMatch)\nVS\n\(viMatch)"
            
            matchInfo.changci.insert("\n", at: matchInfo.changci.index(matchInfo.changci.startIndex, offsetBy: 2))
            
            timeLB.text = matchInfo.changci
           // ruleLB.text = matchInfo.playType
            
            
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

                    let rec = NSAttributedString(string: cathectic + "\n", attributes: [NSAttributedStringKey.foregroundColor: color])
                        
                    record.append(rec)
                }
                resultStr += result.matchResult + "\n"
                ruleStr += result.playType + "\n"
                i += 1
            }
            
            recordLB.attributedText = record
            
            if ruleStr != "" {
                ruleStr.removeLast()
                ruleLB.text = ruleStr
            }
            
            guard resultStr != "" else { return}
            resultStr.removeLast()
            resultLB.text = resultStr
            
        }
    }

    private var timeLB : UILabel!
    private var nameLB : UILabel!
    private var ruleLB : UILabel!
    private var recordLB: UILabel!
    private var resultLB : UILabel!
    public var line : UIImageView!
    //private var oddsIcon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named:"line")
        
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
        resultLB.sizeToFit()
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(ruleLB)
        self.contentView.addSubview(recordLB)
        self.contentView.addSubview(resultLB)
        
       
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(11 * defaultScale)
            make.bottom.equalTo(self.contentView).offset(-11 * defaultScale)
            make.width.equalTo(40 * defaultScale)
            make.left.equalTo(self.contentView).offset(leftSpacing)
        }
        nameLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(11 * defaultScale)
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
            make.top.equalTo(line.snp.bottom).offset(12 * defaultScale)
            //make.top.height.equalTo(timeLB)
            make.bottom.equalTo(self.contentView).offset(1)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(resultLB.snp.left).offset(-1)
        }
        
        resultLB.snp.makeConstraints { (make) in
            //make.top.height.equalTo(recordLB)
            make.top.height.equalTo(timeLB)
            make.width.equalTo(OrderDetailTitleWidth - 30)
            make.right.equalTo(self.contentView).offset(-26)
        }
        
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
      
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
