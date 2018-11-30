//
//  ServiceHomeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/30.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ServiceHomeCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var title : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
extension ServiceHomeCell {
    public func configure(with data : ServiceHomeModel) {
        
    }
}
