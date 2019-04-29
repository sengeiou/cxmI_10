//
//  ComOrderAdressCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ComOrderAdressCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    
    public var textView : HHTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        textView = HHTextView()
//        textView.delegate = self
        textView.placeholder = "请输入详细收货地址"
        textView.backgroundColor = ColorF8F8F8
        textView.placeholderColor = ColorA0A0A0
        textView.font = Font12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ColorEDEDED.cgColor
        
        self.contentView.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(title)
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
        }
    }

    
}

