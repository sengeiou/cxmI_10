//
//  DLTTrendBottom.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTTrendBottom: UIView {
    @IBOutlet weak var redCollectionView : DLTTrendBallCollectionView!
    @IBOutlet weak var blueCollectionView : DLTTrendBallCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension DLTTrendBottom {
    public func configure(red : [DaletouDataModel], blue : [DaletouDataModel]) {
        self.redCollectionView.configure(with: red)
        self.blueCollectionView.configure(with: blue)
    }
}
