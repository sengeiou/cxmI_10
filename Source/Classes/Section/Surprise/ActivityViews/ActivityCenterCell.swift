//
//  ActivityCenterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ActivityCenterCell: UITableViewCell {

    @IBOutlet weak var baView: UIView!
    
    
    @IBOutlet weak var maskBageView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        maskBageView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
extension ActivityCenterCell {
    public func configure(with data : ActivityInfo, style : ActivityCenterStyle) {
        if let url = URL(string: data.bannerImage) {
            icon.kf.setImage(with: url)
        }
        title.text = data.bannerName
        
        switch style {
        case .progress:
            detail.isHidden = false
            maskBageView.isHidden = true
            self.isUserInteractionEnabled = true
        case .over :
            detail.isHidden = true
            maskBageView.isHidden = false
            self.isUserInteractionEnabled = false
        }
        
        
    }
}
