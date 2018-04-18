//
//  NewsNoPicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NewsNoPicCell: UITableViewCell {

    // MARK: - 属性 public
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var detailLb: UILabel!
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
        
        titleLb = getLabel()
        titleLb.text = "一家大幅快乐撒发生的几率附加费"
        detailLb = getLabel()
        detailLb.text = "一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费"
        detailLb.textColor = Color9F9F9F
        detailLb.numberOfLines = 2
        
        bottomView = NewsBottomView()
        
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(detailLb)
        self.contentView.addSubview(bottomView)
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(20 * defaultScale)
        }
        detailLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.left.right.equalTo(titleLb)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10 * defaultScale)
            make.left.equalTo(titleLb)
            make.width.equalTo(200 * defaultScale)
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
