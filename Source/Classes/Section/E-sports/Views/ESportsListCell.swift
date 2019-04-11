//
//  ESportsListCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class ESportsListCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var title : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
}

extension ESportsListCell {
    public func configure(with data : String) {
        
    }
}

extension ESportsListCell {
    private func initSubview() {
        title.text = ""
        
    }
}
