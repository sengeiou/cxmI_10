//
//  BBSchemeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BBSchemeCell: UITableViewCell {

    @IBOutlet weak var betInfo : UILabel!
    @IBOutlet weak var passType : UILabel!
    @IBOutlet weak var mulitle : UILabel!
    @IBOutlet weak var state : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension BBSchemeCell {
    public func configure(with data : SchemeDetail) {
        state.text = data.status
        
        let contents = data.tickeContent.components(separatedBy: "X")
        
        var str = ""
        var i = 0
        for content in contents {
            if i == contents.count - 1 {
                str += content
            }else {
                str += content + "X\n"
            }
            i += 1
        }
        
        betInfo.text = str
        passType.text = data.passType
        mulitle.text = data.multiple
        
        guard data.status != nil else { return }
        switch data.status {
        case "0":
            state.text = "待出票"
        case "1":
            state.text = "已出票"
        case "2":
            state.text = "出票失败"
        case "3":
            state.text = "出票中"
            
        default: break
            
        }
        
    }
}
