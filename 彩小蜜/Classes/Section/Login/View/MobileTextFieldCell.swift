//
//  MobileTextFieldCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MobileTextFieldCell: UITableViewCell {

    public var textfield : CustomTextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        
        
    }
    
    private func initSubview() {
        textfield = CustomTextField(style: .mobile, img: "pho_nor")
        textfield.borderStyle = .none
        textfield.selectImg = "pho_sel"
        textfield.placeholder = "请输入手机号码"
        textfield.keyboardType = .numberPad
        self.contentView.addSubview(textfield)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textfield.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
