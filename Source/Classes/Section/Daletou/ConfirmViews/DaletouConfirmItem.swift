//
//  DaletouConfirmItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouConfirmItem: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

extension DaletouConfirmItem {
    public func configure(with data : DaletouDataModel) {
        titleLabel.text = data.num
        switch data.style {
        case .red, .danRed, .dragRed:
            titleLabel.textColor = ColorEB1C24
        case .blue, .danBlue, .dragBlue:
            titleLabel.textColor = Color0081CC
        case .line:
            break
        }
        if data.num == "-" {
            titleLabel.font = Font28
            titleLabel.textColor = ColorC7C7C7
            titleLabel.textAlignment = .center
        }else {
            titleLabel.font = Font16
            titleLabel.textAlignment = .left
        }
        
    }
}
