//
//  UserInfoSettingCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class UserInfoSettingCell: UITableViewCell {

    public var model : SettingListDataModel! {
        didSet{
            title.text = model.title
            detail.text = model.detail
        }
    }
    
    private var title : UILabel!
    private var detail: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubView()
    }
    
    private func initSubView() {
        self.selectionStyle = .none

        title = getLabel()
        title.sizeToFit()
        
        detail = getLabel()
        detail.font = Font12
        detail.textAlignment = .right
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
        }
        detail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(title)
            make.right.equalTo(-16 * defaultScale)
            make.left.equalTo(title.snp.right).offset(5)
        }
    }

    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.textColor = Color787878
        lab.font = Font14
        lab.textAlignment = .left
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
