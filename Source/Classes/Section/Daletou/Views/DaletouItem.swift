//
//  DaletouItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouItem: UICollectionViewCell {
    
    static let width : CGFloat = 36
    static let heiht : CGFloat = 36
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSubView()
        
        
    }
    
    private func setSubView() {
        numLabel.textColor = ColorEB1C24
        
        numLabel.layer.cornerRadius = DaletouItem.width / 2
        numLabel.layer.masksToBounds = true
        numLabel.layer.borderWidth = 1
        numLabel.layer.borderColor = ColorC7C7C7.cgColor
        
    }
}

// MARK: - 事件
extension DaletouItem {
    public func changeSelect(_ state : Bool, style : BallStyle) {
        switch style {
        case .red, .danRed, .dragRed:
            switch state {
            case true :
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = ColorEB1C24
                numLabel.layer.borderColor = ColorEB1C24.cgColor
            case false :
                numLabel.textColor = ColorEB1C24
                numLabel.backgroundColor = ColorFFFFFF
                numLabel.layer.borderColor = ColorC7C7C7.cgColor
            }
        case .blue, .danBlue, .dragBlue:
            switch state {
            case true :
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = Color0081CC
                numLabel.layer.borderColor = Color0081CC.cgColor
            case false :
                numLabel.textColor = Color0081CC
                numLabel.backgroundColor = ColorFFFFFF
                numLabel.layer.borderColor = ColorC7C7C7.cgColor
            }
        }
    }
}

// MARK: - 数据设置
extension DaletouItem {
    public func configure(with data: DaletouDataModel) {
        changeSelect(data.selected, style: data.style)
        numLabel.text = data.num
        
        
    }
}
