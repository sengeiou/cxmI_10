//
//  DLTHotColdCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTHotColdCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var label30: UILabel!
    
    @IBOutlet weak var label50: UILabel!
    
    @IBOutlet weak var label100: UILabel!
    
    @IBOutlet weak var dropLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DLTHotColdCell {
    public func configure(with data : DLTHotOrCold) {
        numLabel.text = data.num
        label30.text = data.countA
        label50.text = data.countB
        label100.text = data.countC
        dropLabel.text = data.drop
    }
}
