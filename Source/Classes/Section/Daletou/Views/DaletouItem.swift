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
        case .red:
            switch state {
            case true :
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = ColorEB1C24
            case false :
                numLabel.textColor = ColorEB1C24
                numLabel.backgroundColor = ColorFFFFFF
            }
        case .blue:
            switch state {
            case true :
                numLabel.textColor = ColorFFFFFF
                numLabel.backgroundColor = Color0081CC
            case false :
                numLabel.textColor = Color0081CC
                numLabel.backgroundColor = ColorFFFFFF
            }
        }
    }
}

// MARK: - 数据设置
extension DaletouItem {
    public func configure(with data: DaletouDataModel) {
//        switch data.style {
//        case .red:
//            numLabel.textColor = ColorEB1C24
//        case .blue:
//            numLabel.textColor = Color0081CC
//        default: break
//        }
        changeSelect(data.selected, style: data.style)
        if let num = Int(data.num) {
            if num < 10 {
                numLabel.text = "0" + data.num
            }
            else{
                numLabel.text = data.num
            }
        }
        
    }
}
