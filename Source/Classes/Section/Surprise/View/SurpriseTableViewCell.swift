//
//  SurpriseTableViewCell.swift
//  tiantianwancai
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 笑. All rights reserved.
//

import UIKit

class SurpriseTableViewCell: UITableViewCell {

    static let identifier : String = "SurpriseTableViewCell"
    
    private var icon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
   
    
    private func initSubview(){
        icon = UIImageView()
        self.contentView.addSubview(icon)
        
        icon.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(8)
            make.right.equalTo(-8)
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

extension SurpriseTableViewCell {
    public func configure(with urlStr : String) {
        if let url = URL(string: urlStr) {
            icon.kf.setImage(with: url)
        }
    }
}
