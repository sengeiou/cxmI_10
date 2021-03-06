//
//  DLTOrderItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTOrderItem: UICollectionViewCell {
    
    static let width : CGFloat = 32
    static let heiht : CGFloat = 32
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }
    
    private func setSubview() {
        self.line.isHidden = true
        self.numLabel.layer.cornerRadius = (DLTOrderItem.width - 4) / 2
        self.numLabel.layer.masksToBounds = true
        self.numLabel.layer.borderWidth = 1
        self.numLabel.layer.borderColor = ColorC7C7C7.cgColor
    }
}

extension DLTOrderItem {
    public func configure(with data : DLTOrderItemInfo) {
        numLabel.text = data.cathectic
        switch data.style {
        case .line:
            numLabel.isHidden = true
            line.isHidden = false
        case .red, .danRed, .dragRed:
            line.isHidden = true
            numLabel.isHidden = false
            numLabel.textColor = ColorEB1C24
            switch data.isGuess {
            case true:
                numLabel.layer.borderColor = ColorEB1C24.cgColor
                numLabel.backgroundColor = ColorEB1C24
                numLabel.textColor = ColorFFFFFF
            case false:
                numLabel.layer.borderColor = ColorC7C7C7.cgColor
                numLabel.backgroundColor = ColorFFFFFF
            }
        case .blue, .danBlue, .dragBlue:
            line.isHidden = true
            numLabel.isHidden = false
            numLabel.textColor = Color0081CC
            switch data.isGuess {
            case true:
                numLabel.layer.borderColor = Color0081CC.cgColor
                numLabel.backgroundColor = Color0081CC
                numLabel.textColor = ColorFFFFFF
            case false:
                numLabel.layer.borderColor = ColorC7C7C7.cgColor
                numLabel.backgroundColor = ColorFFFFFF
            }
        }
    }
}
