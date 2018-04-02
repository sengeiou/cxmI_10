//
//  HomeActivityCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeActivityCell: UITableViewCell {

    public var activityModel : HomeActivityModel! {
        didSet{
            if let url = URL(string: activityModel.actImg) {
                icon.kf.setImage(with: url)
            }
        }
    }
    
    private var icon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.contentView)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        
        self.contentView.addSubview(icon)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
