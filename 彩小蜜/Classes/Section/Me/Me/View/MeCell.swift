//
//  MeCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import TTTAttributedLabel



class MeCell: UITableViewCell {

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public var serviceNum : String! {
        didSet{
            self.detail.text = serviceNum
            self.detail.addLink(toPhoneNumber: serviceNum, with: NSRange.init(location: 0, length: serviceNum.lengthOfBytes(using: .utf8)))
        }
    }
    
    //MARK: - 属性
    public var icon : UIImageView!
    public var title : UILabel!
    public var detail : TTTAttributedLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView).offset(20)
            make.height.width.equalTo(18)
        }
        title.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(icon.snp.right).offset(8)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(title.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-22.5)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    private func createUI() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        
        title = UILabel()
        title.textAlignment = .left
        title.textColor = Color787878
        title.font = Font14
        
        detail = TTTAttributedLabel(frame: CGRect.zero)
        detail.textAlignment = .right
        detail.font = Font12
        detail.lineBreakMode = .byWordWrapping
        detail.linkAttributes =  [NSAttributedStringKey.foregroundColor: Color787878]
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    

}
