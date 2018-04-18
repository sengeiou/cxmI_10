//
//  NewsOnePicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let PicWidth : CGFloat = (screenWidth - leftSpacing * 2 - 5 * 2) / 3

class NewsOnePicCell: UITableViewCell {

    // MARK: - 属性 public
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var icon : UIImageView!
    private var bottomView: NewsBottomView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "Racecolorfootball")
        
        titleLb = getLabel()
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(titleLb)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(leftSpacing)
            make.right.equalTo(-leftSpacing)
            make.bottom.equalTo(-leftSpacing)
            make.width.equalTo(PicWidth)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(icon.snp.left).offset(-leftSpacing)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(10 * defaultScale)
            make.left.equalTo(titleLb)
            make.width.equalTo(200 * defaultScale)
        }
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.numberOfLines = 2
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
