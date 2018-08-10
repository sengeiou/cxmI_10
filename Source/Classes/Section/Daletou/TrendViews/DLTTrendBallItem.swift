//
//  DLTTrendBallItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTTrendBallItem: UICollectionViewCell {
    
    static let width : CGFloat = 24
    static let heiht : CGFloat = 24
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }
    
    private func setSubview() {
        numLabel.layer.cornerRadius = DLTTrendBallItem.width / 2
        numLabel.layer.masksToBounds = true
        numLabel.layer.borderWidth = 1
    }
}

extension DLTTrendBallItem {
    
}

extension DLTTrendBallItem {
    public func configure(with data : DaletouDataModel) {
        numLabel.text = data.num
        switch data.style {
        case .red:
            
            switch data.selected {
            case true:
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = ColorEB1C24
                numLabel.layer.borderColor = ColorEB1C24.cgColor
            case false:
                numLabel.textColor = ColorEB1C24
                numLabel.backgroundColor = ColorFFFFFF
                numLabel.layer.borderColor = ColorFFFFFF.cgColor
            }
        case .blue:
            
            switch data.selected {
            case true:
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = Color0081CC
                numLabel.layer.borderColor = Color0081CC.cgColor
            case false:
                numLabel.textColor = Color0081CC
                numLabel.backgroundColor = ColorFFFFFF
                numLabel.layer.borderColor = ColorFFFFFF.cgColor
            }
        default:
            break
        }
    }
}
