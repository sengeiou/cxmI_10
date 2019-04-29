//
//  CommodityDetailItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/30.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityDetailItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 20) / 2
    static let height : CGFloat = 30
    
    @IBOutlet weak var title : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

extension CommodityDetailItem {
    public func configure(with data : String ) {
        title.text = data
    }
}
