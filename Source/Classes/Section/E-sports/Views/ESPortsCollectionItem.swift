//
//  ESPortsCollectionItem.swift
//  彩小蜜
//
//  Created by 笑 on 2019/3/1.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class ESPortsCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var title : UIButton!
    
    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
