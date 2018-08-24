//
//  DLTRedBlueTrendItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTRedBlueTrendItem: UICollectionViewCell {
    
    static let width : CGFloat = 35
    static let height: CGFloat = 30
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numLabel.layer.cornerRadius = 12
        numLabel.layer.masksToBounds = true
    }
}

extension DLTRedBlueTrendItem {
    public func configure (with data : String, num : String, style : HotColdStyle, color : UIColor) {
        self.backgroundColor = color
        if data == "0" {
            numLabel.text = num
            numLabel.textColor = ColorFFFFFF
            switch style {
            case .red:
                numLabel.backgroundColor = ColorEB1C24
            case .blue:
                numLabel.backgroundColor = Color0081CC
            }
        }else {
            numLabel.text = data
            numLabel.textColor = Color787878
            numLabel.backgroundColor = UIColor(hexColor: "ffffff", alpha: 0)
        }
    }
}
