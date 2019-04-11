//
//  WorldCupOrderDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WorldCupOrderDetailCell: UITableViewCell {
    public var detailType : String!
    
    public var matchInfo: MatchInfo! {
        didSet{
            guard matchInfo != nil else { return }
            guard detailType != nil else { return }
            if detailType == "1" { // 冠军
                nameLB.text = matchInfo.match
            }else if detailType == "2" {// 冠亚军
                guard let range = matchInfo.match.range(of: "VS") else { return }
                
                let homeMatch = matchInfo.match.prefix(upTo: (range.lowerBound))
                let viMatch = matchInfo.match.suffix(from: range.upperBound)
                
                nameLB.text = "\(homeMatch)\nVS\n\(viMatch)"
            }
            
            matchInfo.changci.insert("\n", at: matchInfo.changci.index(matchInfo.changci.startIndex, offsetBy: 2))
            
            if matchInfo.isDan {
                self.danIcon.isHidden = false
            }else {
                self.danIcon.isHidden = true
            }
            
            let record = NSMutableAttributedString()
            let resultAtt = NSMutableAttributedString()
            //var resultStr = ""
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
                    
                    let rec = NSAttributedString(string: cathectic, attributes: [NSAttributedString.Key.foregroundColor: color])
                    
                    let res = NSAttributedString(string: result.matchResult, attributes: [NSAttributedString.Key.foregroundColor: color])
                    record.append(rec)
                    resultAtt.append(res)
                }
                //resultStr += result.matchResult + "\n"
                ruleStr += result.playType + "\n"
                i += 1
            }
            
            resultLB.attributedText = resultAtt
            
            if ruleStr != "" {
                ruleStr.removeLast()
                oddLB.attributedText = record
            }
        }
    }
    
    public var line : UIImageView!
    
    private var nameLB : UILabel!
    private var oddLB : UILabel!
    private var resultLB : UILabel!
    
    private var danIcon : UIImageView!
    //private var oddsIcon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        nameLB = getDetailLB()
        nameLB.numberOfLines = 0
        
        oddLB = getDetailLB()
        oddLB.numberOfLines = 0
        
        resultLB = getDetailLB()
        resultLB.numberOfLines = 0
        //resultLB.textAlignment = .right
        resultLB.sizeToFit()
        
        danIcon = UIImageView()
        danIcon.image = UIImage(named: "dan")
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(oddLB)
        self.contentView.addSubview(resultLB)
        self.contentView.addSubview(danIcon)
        
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        danIcon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.height.width.equalTo(16)
        }
        
        nameLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(11 * defaultScale)
            make.bottom.equalTo(self.contentView).offset(-11 * defaultScale)
            make.left.equalTo(16)
            make.width.equalTo(resultLB)
        }
        oddLB.snp.makeConstraints { (make) in
            make.top.height.equalTo(nameLB)
            make.width.equalTo(80)
            make.left.equalTo(nameLB.snp.right).offset(1)
        }
        resultLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLB)
            make.left.equalTo(oddLB.snp.right).offset(1)
            make.right.equalTo(self.contentView).offset(-5)
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
