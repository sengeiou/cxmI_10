//
//  ShareCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ShareCell: UICollectionViewCell {
    
    public var shareData : ShareDataModel! {
        didSet{
            icon.image = UIImage(named : shareData.iconPic)
            title.text = shareData.title
        }
    }
    
    
    // MARK: - 属性 private
    private var icon : UIImageView!
    private var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initSubview()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
            make.height.equalTo(icon.snp.width)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(12 * defaultScale)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    private func initSubview() {
        icon = UIImageView()
        icon.image = UIImage(named: "")
        
        title = UILabel()
        title.font = Font13
        title.textColor = Color505050
        title.textAlignment = .center
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
