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
    
    //MARK: - 属性
    public var title : UILabel!
    public var detail : TTTAttributedLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         createUI()
    }
    
    private func createUI() {
        
        title = UILabel()
        title.textAlignment = .left
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 12)
        
        detail = TTTAttributedLabel(frame: CGRect.zero)
        detail.textAlignment = .right
       
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(title.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    

}
