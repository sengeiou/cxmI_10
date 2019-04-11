//
//  AccountDetailFilterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AccountDetailFilterCell: UITableViewCell {

    static let cellId = "AccountDetailFilterCellId"
    
    public var filterModel : AccountDetailFilterModel! {
        didSet{
            guard filterModel != nil else { return }
            datelb.text = filterModel.date
            if filterModel.isSelected {
                datelb.textColor = ColorEA5504
            }else {
                datelb.textColor = Color505050
            }
        }
    }
    
    private var datelb : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        datelb.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        datelb = UILabel()
        datelb.font = Font13
        datelb.textColor = Color505050
        datelb.textAlignment = .center
        
        self.contentView.addSubview(datelb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
