//
//  DLTRedBlueTrendStageItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTRedBlueTrendStageItem: UICollectionViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.numLabel.backgroundColor = UIColor(hexColor: "ffffff", alpha: 0)
    }
}

extension DLTRedBlueTrendStageItem {
    public func configure(with data : DLTLottoNumInfo, color : UIColor) {
        numLabel.text = data.termNum
        self.backgroundColor = color
    }
}
