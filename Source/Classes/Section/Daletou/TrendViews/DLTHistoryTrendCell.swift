//
//  DLTHistoryTrendCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTHistoryTrendCell: UITableViewCell {

    @IBOutlet weak var phaseNum: UILabel!
    
    @IBOutlet weak var redOne: UILabel!
    
    @IBOutlet weak var redTwo: UILabel!
    
    @IBOutlet weak var redThree: UILabel!
    
    @IBOutlet weak var redFour: UILabel!
    
    @IBOutlet weak var redFive: UILabel!
    
    @IBOutlet weak var blueOne: UILabel!
    
    @IBOutlet weak var blueTwo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DLTHistoryTrendCell {
    public func configure(with data : DLTLottoNumInfo) {
        phaseNum.text = data.termNum
        guard data.numList.count == 7 else { return }
        redOne.text = data.numList[0]
        redTwo.text = data.numList[1]
        redThree.text = data.numList[2]
        redFour.text = data.numList[3]
        redFive.text = data.numList[4]
        blueOne.text = data.numList[5]
        blueTwo.text = data.numList[6]
    }
}

