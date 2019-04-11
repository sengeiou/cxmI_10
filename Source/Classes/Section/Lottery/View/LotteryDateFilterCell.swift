//
//  LotteryDateFilterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LotteryDateFilterCell: UITableViewCell {

    public var dateModel : LotteryDateModel! {
        didSet{
            guard dateModel != nil else { return }
            datelb.text = dateModel.strDate
            if dateModel.isSelected {
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
