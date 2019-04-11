//
//  ComOrderHeaderFooter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ComOrderHeaderFooter: UITableViewHeaderFooterView {

    static public let identifier : String = "ComOrderHeaderFooter"
    
    private var icon : UIImageView!
    private var title : UILabel!
    private var line : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        self.contentView.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorEDEDED
        
        icon = UIImageView()
        icon.image = UIImage(named: "圆角矩形")
        
        title = UILabel()
        title.font = Font15
        title.textColor = Color404040
        

        self.contentView.addSubview(title)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(1)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(5)
            make.height.equalTo(20)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(icon.snp.right).offset(5)
            make.right.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComOrderHeaderFooter {
    public func configure(title : String) {
        self.title.text = title
    }
}
