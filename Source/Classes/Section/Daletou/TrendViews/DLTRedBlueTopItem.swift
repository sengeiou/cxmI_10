//
//  DLTRedBlueTopItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTRedBlueTopItem: UICollectionViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
}

extension DLTRedBlueTopItem {
    public func configure(with num : String) {
        numLabel.text = num
    }
}
