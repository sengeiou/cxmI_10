//
//  NewsThreePicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NewsThreePicCell: UITableViewCell {

    // MARK: - 属性 public
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var bottomView: NewsBottomView!
    private var picOne : UIImageView!
    private var picTwo : UIImageView!
    private var picThree: UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        
        self.selectionStyle = .none
        
        
    
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-leftSpacing)
            make.height.equalTo(20)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(10 * defaultScale)
            make.left.equalTo(titleLb)
            make.width.equalTo(200 * defaultScale)
        }
        picOne.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10 * defaultScale)
            make.bottom.equalTo(bottomView.snp.top).offset(-10 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(picThree)
        }
        picTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(picThree)
            make.left.equalTo(picOne.snp.right).offset(5)
        }
        picThree.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(picOne)
            make.left.equalTo(picTwo.snp.right).offset(5)
            make.right.equalTo(-leftSpacing)
        }
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.numberOfLines = 1
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
