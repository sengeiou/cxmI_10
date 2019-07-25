//
//  OrderDetailCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import Foundation

class OrderDetailCell: UITableViewCell {
    
    var allDetailLbArr :[[UILabel]] = []
    var allRuleLbArr :[[UILabel]] = []
    var allResultLbArr :[[UILabel]] = []
    
    var detailLbArr :[UILabel] = []
    var ruleLbArr :[UILabel] = []
    var resultLbArr :[UILabel] = []
    
    public var matchInfo: MatchInfo! {
        didSet{
            guard matchInfo != nil else { return }
            guard let range = matchInfo.match.range(of: "VS") else { return }
            
            detailLbArr.removeAll()
            ruleLbArr.removeAll()
            resultLbArr.removeAll()
            
            
            for i in 0..<allDetailLbArr.count{
                allDetailLbArr[i].first?.removeFromSuperview()
            }
            for i in 0..<allRuleLbArr.count{
                allRuleLbArr[i].first?.removeFromSuperview()
            }
            for i in 0..<allResultLbArr.count{
                allResultLbArr[i].first?.removeFromSuperview()
            }
            allDetailLbArr.removeAll()
            allRuleLbArr.removeAll()
            allResultLbArr.removeAll()
            
            let homeMatch = matchInfo.match.prefix(upTo: (range.lowerBound))
            let viMatch = matchInfo.match.suffix(from: range.upperBound)
            nameLB.text = "\(homeMatch)\nVS\n\(viMatch)"
            matchInfo.changci.insert("\n", at: matchInfo.changci.index(matchInfo.changci.startIndex, offsetBy: 2))
            timeLB.text = matchInfo.changci

            
            if matchInfo.isDan {
                self.danIcon.isHidden = false
            }else {
                self.danIcon.isHidden = true
            }
            
            var record = NSMutableAttributedString()
            var resultAtt = NSMutableAttributedString()

            danIcon.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.height.width.equalTo(16)
            }
            
            line.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentView).offset(0)
                make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
                make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
                make.height.equalTo(SeparationLineHeight)
            }
            
            for i in 0..<matchInfo.cathecticResults.count {

                let result = matchInfo.cathecticResults[i]
   
                //投注记录
                let detailLb = getDetailLB()
                detailLb.numberOfLines = 0
                //去掉最后内容 不显示省略号
                detailLb.lineBreakMode = .byClipping
                detailLbArr.append(detailLb)
                self.contentView.addSubview(detailLb)
                
                //玩法数组
                let ruleLB = getDetailLB()
                ruleLB.numberOfLines = 0
                ruleLbArr.append(ruleLB)
                self.contentView.addSubview(ruleLB)
                ruleLB.text = result.playType
                
                //结果数组
                let resultLb = getDetailLB()
                resultLb.numberOfLines = 0
                resultLbArr.append(resultLb)
                self.contentView.addSubview(resultLb)
                


                for cath in result.cathectics {
                    resultAtt = NSMutableAttributedString()
                    let color : UIColor!
                    if cath.isGuess == true {
                        color = ColorEA5504
                        let res = NSAttributedString(string: result.matchResult, attributes: [NSAttributedString.Key.foregroundColor: color])
                        resultAtt.append(res)
                        break
                    }else{
                        color = Color505050
                        let res = NSAttributedString(string: result.matchResult, attributes: [NSAttributedString.Key.foregroundColor: color])
                        resultAtt.append(res)
                    }
                }
                //赛果
                resultLb.attributedText = resultAtt

                
                for j in 0..<matchInfo.cathecticResults[i].cathectics.count {

                    let cath = matchInfo.cathecticResults[i].cathectics[j]
                    let cathectic = cath.cathectic.replacingOccurrences(of: "null", with: "")
                    
                    let color : UIColor!
                    if cath.isGuess == true {
                        if j + 1 >= matchInfo.cathecticResults[i].cathectics.count{
                            color = ColorEA5504
                            let rec = NSAttributedString(string: cathectic, attributes: [NSAttributedString.Key.foregroundColor: color])
                            record.append(rec)
                        }else{
                            color = ColorEA5504
                            let rec = NSAttributedString(string: cathectic + "\n", attributes: [NSAttributedString.Key.foregroundColor: color])
                            record.append(rec)
                        }
                    }else{
                        if j + 1 >= matchInfo.cathecticResults[i].cathectics.count{
                            color = Color505050
                            let rec = NSAttributedString(string: cathectic, attributes: [NSAttributedString.Key.foregroundColor: color])
                            record.append(rec)
                        }else{
                            color = Color505050
                            let rec = NSAttributedString(string: cathectic + "\n", attributes: [NSAttributedString.Key.foregroundColor: color])
                            record.append(rec)
                        }
                    }
                    //投注记录
                    detailLb.attributedText = record
                }
                
                allDetailLbArr.append(detailLbArr)
                allRuleLbArr.append(ruleLbArr)
                allResultLbArr.append(resultLbArr)
                
                detailLbArr.removeAll()
                ruleLbArr.removeAll()
                resultLbArr.removeAll()
                
                record = NSMutableAttributedString()
            }
            

            if allDetailLbArr.count == 1{
                let danJu = allDetailLbArr[0]
                danJu.first?.snp.makeConstraints({ (make) in
                    make.top.equalTo(line.snp.bottom).offset(12 * defaultScale)
                    make.width.equalTo(OrderDetailTitleWidth)
                    make.right.equalTo(allResultLbArr[0].first!.snp_left).offset(-6 * defaultScale)
                    make.bottom.equalTo(self.contentView).offset(-12 * defaultScale)
                })
            }else{
                for i in 0..<allDetailLbArr.count{
                    if i == 0 {
                        let danJu = allDetailLbArr[i]
                        danJu.first?.snp.makeConstraints({ (make) in
                            make.top.equalTo(line.snp.bottom).offset(12 * defaultScale)
                            make.width.equalTo(OrderDetailTitleWidth)
                            make.right.equalTo(allResultLbArr[i].first!.snp_left).offset(-6 * defaultScale)
                        })
                    }else if i + 1 >= allDetailLbArr.count{
                        let danJu = allDetailLbArr[i]
                        let backLB = allDetailLbArr[i - 1].first!
                        danJu.first?.snp.makeConstraints({ (make) in
                            make.top.equalTo(backLB.snp.bottom).offset(12 * defaultScale)
                            make.width.equalTo(OrderDetailTitleWidth)
                            make.right.equalTo(allResultLbArr[i].first!.snp_left).offset(-6 * defaultScale)
                            make.bottom.equalTo(self.contentView).offset(-12 * defaultScale)
                        })
                    }else{
                        let danJu = allDetailLbArr[i]
                        let backLB = allDetailLbArr[i - 1].first!
                        danJu.first?.snp.makeConstraints{ (make) in
                            make.top.equalTo(backLB.snp.bottom).offset(12 * defaultScale)
                            make.width.equalTo(OrderDetailTitleWidth)
                            //make.right.equalTo(resultL.snp.left).offset(-1 * defaultScale)
                            make.right.equalTo(allResultLbArr[i].first!.snp_left).offset(-6 * defaultScale)
                        }
                    }
                }
            }
            
            for i in 0..<allResultLbArr.count{
                let resultLb = allResultLbArr[i].first!
                resultLb.snp.remakeConstraints { (make) in
                    make.width.equalTo(OrderDetailTitleWidth - 30 * defaultScale)
                    make.right.equalTo(self.contentView).offset(-20 * defaultScale)
                    make.centerY.equalTo(allDetailLbArr[i].first!)
                }
            }
            
            for i in 0..<allRuleLbArr.count{
                let ruleLb = allRuleLbArr[i].first!
                ruleLb.snp.makeConstraints { (make) in
                    make.centerY.equalTo(allDetailLbArr[i].first!)
                    make.width.equalTo(nameLB)
                    make.right.equalTo(allDetailLbArr[i].first!.snp.left).offset(-1)
                }
            }
        
            nameLB.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentView).offset(11 * defaultScale)
                make.left.equalTo(timeLB.snp.right).offset(1 * defaultScale)
                make.right.equalTo(allRuleLbArr[0].first!.snp_left)
                make.bottom.equalTo(self.contentView).offset(-11 * defaultScale)
            }

            timeLB.snp.makeConstraints { (make) in
                make.top.equalTo(nameLB)
                make.bottom.equalTo(nameLB)
                make.width.equalTo(40 * defaultScale)
                make.left.equalTo(self.contentView).offset(leftSpacing + 10 * defaultScale)
            }
        }
    }

    
    public var line : UIImageView!
    private var timeLB : UILabel!
    private var nameLB : UILabel!
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
        
        timeLB = getDetailLB()
        timeLB.textAlignment = .left
        timeLB.numberOfLines = 0
        
        nameLB = getDetailLB()
        nameLB.numberOfLines = 0
        
        danIcon = UIImageView()
        danIcon.image = UIImage(named: "dan")
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(danIcon)
    }

    /// 移除所有子控件
    private func removeAllSubViews(){
        _ = contentView.subviews.map {
            $0.removeFromSuperview()
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
