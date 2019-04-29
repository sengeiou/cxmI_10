//
//  BBOrderDetailCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BBOrderDetailCell: UITableViewCell {

    
    // 场次
    @IBOutlet weak var changCi : UILabel!
    // 球队名称，赛事
    @IBOutlet weak var teamName : UILabel!
    // 玩法
    @IBOutlet weak var playLabel : UILabel!
    // 投注
    @IBOutlet weak var betLabel : UILabel!
    // 赛果
    @IBOutlet weak var resultLabel: UILabel!
    // 胆
    @IBOutlet weak var danIcon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BBOrderDetailCell {
    public func configure(with data : MatchInfo) {
        guard let range = data.match.range(of: "VS") else { return }
        
        let homeMatch = data.match.prefix(upTo: (range.lowerBound))
        let viMatch = data.match.suffix(from: range.upperBound)
        
        teamName.text = "\(homeMatch)\nVS\n\(viMatch)"
  
        var changci = data.changci
        
        changci.insert("\n", at: changci.index(changci.startIndex, offsetBy: 2))
        
        
        changCi.text = changci
        
        // 胆
        danIcon.isHidden = !data.isDan
        
        
        let record = NSMutableAttributedString()
        let resultAtt = NSMutableAttributedString()
        //var resultStr = ""
        var ruleStr = ""
        var i = 1
        for (index, result) in data.cathecticResults.enumerated() {
            for cath in result.cathectics {
                let color : UIColor!
                if cath.isGuess == true {
                    color = ColorEA5504
                }else {
                    color = Color505050
                }
                let cathectic = cath.cathectic.replacingOccurrences(of: "null", with: "")
                
                let rec : NSAttributedString
                let res : NSAttributedString
                
                if index == data.cathecticResults.count - 1 {
                    rec = NSAttributedString(string: cathectic, attributes: [NSAttributedString.Key.foregroundColor: color])
                    res = NSAttributedString(string: result.matchResult, attributes: [NSAttributedString.Key.foregroundColor: color])
                }else {
                    rec = NSAttributedString(string: cathectic + "\n", attributes: [NSAttributedString.Key.foregroundColor: color])
                    res = NSAttributedString(string: result.matchResult + "\n", attributes: [NSAttributedString.Key.foregroundColor: color])
                }
                record.append(rec)
                resultAtt.append(res)
            }
           
            ruleStr += result.playType + "\n"
            i += 1
        }
        
        betLabel.attributedText = record
        resultLabel.attributedText = resultAtt
        
        if ruleStr != "" {
            ruleStr.removeLast()
            playLabel.text = ruleStr
        }
    }
}
