//
//  OrderStoreCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class OrderStoreCell: UITableViewCell {

    static public let identifier : String = "OrderStoreCell"
    
    static public let height : CGFloat = 100
    
    private var icon : UIImageView!
    private var title : UILabel!
    private var enterStore : UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    

    @objc private func enterStoreClicked() {
        
    }
    
}

extension OrderStoreCell {
    public func configure(with data : AppendInfo) {
        
    }
}
extension OrderStoreCell {
    private func initSubview() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "store")
        
        title = UILabel()
        title.font = Font15
        title.textColor = Color404040
        title.text = "合作店铺"
        
        let image = UIImageView()
        image.image = UIImage(named: "renzheng")
        
        enterStore = UIButton(type: .custom)
        enterStore.isUserInteractionEnabled = false
        enterStore.setTitle("进店逛逛", for: .normal)
        enterStore.setTitleColor(Color404040, for: .normal)
        enterStore.titleLabel?.font = Font15
        enterStore.layer.cornerRadius = 15
        enterStore.layer.masksToBounds = true
        enterStore.layer.borderColor = ColorEDEDED.cgColor
        enterStore.layer.borderWidth = 1
        
        enterStore.addTarget(self, action: #selector(enterStoreClicked), for: .touchUpInside)
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(image)
        self.contentView.addSubview(enterStore)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(20)
            make.width.equalTo(icon.snp.height)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(icon.snp.right).offset(20)
            make.width.equalTo(65)
        }
        image.snp.makeConstraints { (make) in
            make.centerY.equalTo(title.snp.centerY)
            make.width.equalTo(16)
            make.height.equalTo(18)
            make.left.equalTo(title.snp.right).offset(5)
        }
        enterStore.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
}
