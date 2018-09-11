//
//  SurpriseShooterHeaderItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseShooterHeaderItem: UICollectionViewCell {
    
    static let identifier : String = "SurpriseShooterHeaderItem"
    static let width : CGFloat = 80
    static let height: CGFloat = 30
    
    public var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font12
        title.textColor = Color505050
        title.textAlignment = .center
        
        self.contentView.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
