//
//  SurprisePrizeDigitalItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum PrizeDigitalStyle {
    case circular
    case square
}

class SurprisePrizeDigitalItem: UICollectionViewCell {
    
    static let width : CGFloat = 30
    static let height : CGFloat = 30
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numLabel.layer.cornerRadius = SurprisePrizeDigitalItem.width / 2
        numLabel.layer.masksToBounds = true
        numLabel.layer.borderWidth = 1
        numLabel.layer.borderColor = ColorFFFFFF.cgColor
    }
}

extension SurprisePrizeDigitalItem {
    public func configure(with data : DigitalBallData, style : PrizeDigitalStyle ) {
        numLabel.text = data.title
        
        switch style {
        case .square:
            numLabel.layer.cornerRadius = 2
        numLabel.layer.masksToBounds = true
        default:
            break
        }
        
        switch data.style {
        case .seRed:
            numLabel.textColor = ColorFFFFFF
            numLabel.backgroundColor = ColorEB1C24
            numLabel.layer.borderColor = ColorEB1C24.cgColor
        case .seBlue:
            numLabel.textColor = ColorFFFFFF
            numLabel.backgroundColor = Color0081CC
            numLabel.layer.borderColor = Color0081CC.cgColor
        case .red:
            numLabel.textColor = ColorEB1C24
            numLabel.backgroundColor = ColorFFFFFF
            numLabel.layer.borderColor = ColorC7C7C7.cgColor
        case .blue:
            numLabel.textColor = Color0081CC
            numLabel.backgroundColor = ColorFFFFFF
            numLabel.layer.borderColor = ColorC7C7C7.cgColor
        
        }
    }
    
    
    public func configure(with data : DigitalBallData, style : LottoPlayType ) {
        numLabel.text = data.title
        
//        switch style {
//        case .square:
//            numLabel.layer.cornerRadius = 2
//            numLabel.layer.masksToBounds = true
//        default:
//            break
//        }
//
        switch data.style {
        case .seRed:
            numLabel.textColor = ColorFFFFFF
            numLabel.backgroundColor = ColorEB1C24
            numLabel.layer.borderColor = ColorEB1C24.cgColor
        case .seBlue:
            numLabel.textColor = ColorFFFFFF
            numLabel.backgroundColor = Color0081CC
            numLabel.layer.borderColor = Color0081CC.cgColor
        case .red:
            numLabel.textColor = ColorEB1C24
            numLabel.backgroundColor = ColorFFFFFF
            numLabel.layer.borderColor = ColorC7C7C7.cgColor
        case .blue:
            numLabel.textColor = Color0081CC
            numLabel.backgroundColor = ColorFFFFFF
            numLabel.layer.borderColor = ColorC7C7C7.cgColor

        }
    }
}
