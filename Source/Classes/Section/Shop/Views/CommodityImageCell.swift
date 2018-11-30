//
//  CommodityImageCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityImageCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    private func initSubview() {
        
    }
    
    var aspectConstraint : NSLayoutConstraint? {
        didSet{
            if let old = oldValue{
                icon.removeConstraint(old)
            }
            if let aspect = aspectConstraint {
                icon.addConstraint(aspect)
            }
        }
    }
}

// MARK: - 数据更新
extension CommodityImageCell {
    public func configure(with data : GoodsImage) {
        
        guard let url = URL(string: data.image) else {
            aspectConstraint = nil
            icon.image = nil
            return
        }
        
        icon.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
            if let img = image {
                let aspect = img.size.width / img.size.height
                
                self.aspectConstraint = NSLayoutConstraint(item: self.icon, attribute: .width, relatedBy: .equal, toItem: self.icon, attribute: .height, multiplier: aspect, constant: 0.0)
            }
        }
    }
}
