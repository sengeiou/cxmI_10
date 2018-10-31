//
//  FootballIntegralCollectionCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballIntegralCollectionCell: UICollectionViewCell {
    
    public var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    private func initSubview(){

        
        title = UILabel()
        title.font = Font12
        title.textColor = Color505050
        title.textAlignment = .center
        //title.text = "88"
        
        self.contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
