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
    public func configure(with data : BannerModel) {
        guard let url = URL(string: data.bannerImage) else {
            aspectConstraint = nil
            icon.image = nil
            return
        }
        let data = try? Data(contentsOf: url)
        //从网络获取数据流,再通过数据流初始化图片
        if let imageData = data, let image = UIImage(data: imageData) {
            let aspect = image.size.width / image.size.height
            //设置imageView宽高比约束
            aspectConstraint = NSLayoutConstraint(item: icon,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: icon, attribute: .height,
                                                  multiplier: aspect, constant: 0.0)
            //加载图片
            icon.image = image
        }
        
        
//        icon.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
//            if let img = image {
//                let aspect = img.size.width / img.size.height
//
//                self.aspectConstraint = NSLayoutConstraint(item: self.icon, attribute: .width, relatedBy: .equal, toItem: self.icon, attribute: .height, multiplier: aspect, constant: 0.0)
//                self.icon.image = img
//                self.contentView.setNeedsLayout()
//                self.contentView.setNeedsDisplay()
//            }
//        }
    }
}
