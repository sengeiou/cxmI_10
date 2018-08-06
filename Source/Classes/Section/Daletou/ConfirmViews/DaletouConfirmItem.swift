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
        case .red:
            titleLabel.textColor = ColorEB1C24
        case .blue:
            titleLabel.textColor = Color0081CC
        }
        if data.num == "-" {
            titleLabel.textColor = ColorC7C7C7
        }
        
    }
}
