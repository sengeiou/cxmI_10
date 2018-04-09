//
//  PaymentCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    public var title : UILabel!
    public var detail : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(detail.snp.left)
        }
        detail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(100 * defaultScale)
        }
    }
    private func initSubview() {
        title = UILabel()
        title.font = Font14
        title.textColor = Color787878
        title.textAlignment = .left
        
        detail = UILabel()
        detail.font = Font14
        detail.textColor = Color787878
        detail.textAlignment = .left
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
