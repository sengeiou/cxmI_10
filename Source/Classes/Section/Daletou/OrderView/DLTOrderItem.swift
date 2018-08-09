//
//  DLTOrderItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTOrderItem: UICollectionViewCell {
    
    static let width : CGFloat = 28
    static let heiht : CGFloat = 28
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }
    
    private func setSubview() {
        self.line.isHidden = true
        self.numLabel.layer.cornerRadius = DLTOrderItem.width / 2
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
            numLabel.textColor = ColorEB1C24
        case .blue, .danBlue, .dragBlue:
            numLabel.textColor = Color0081CC
        }
    }
}
