//
//  DLTRedBlueTrendCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/13.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTRedBlueTrendCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DLTRedBlueTrendCell {
    public func configure(with data : DLTLottoNumInfo) {
        numLabel.text = data.termNum
    }
}
