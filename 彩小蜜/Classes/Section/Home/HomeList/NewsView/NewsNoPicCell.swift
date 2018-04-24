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
    public var newsInfo : NewsInfoModel!{
        didSet{
            guard newsInfo != nil else { return }
            bottomView.newsInfo = newsInfo
            titleLb.text = newsInfo.title
            detailLb.text = newsInfo.summary
           
        }
    }
    
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var detailLb: UILabel!
    private var bottomView: NewsBottomView!
    private var bottomLine : UIView!
    
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
        //titleLb.text = "一家大幅快乐撒发生的几率附加费"
        detailLb = getLabel()
        detailLb.font = Font13
        //detailLb.text = "一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费一家大幅快乐撒发生的几率附加费"
        detailLb.textColor = Color787878
        detailLb.numberOfLines = 2
        
        bottomView = NewsBottomView()
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(detailLb)
        self.contentView.addSubview(bottomView)
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(12 * defaultScale)
            make.left.equalTo(12 * defaultScale)
            make.right.equalTo(-12 * defaultScale)
            make.height.equalTo(15 * defaultScale)
        }
        detailLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.left.right.equalTo(titleLb)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            //make.bottom.equalTo(-12 * defaultScale)
            make.left.equalTo(titleLb)
            make.right.equalTo(titleLb)
            make.bottom.equalTo(bottomLine.snp.top).offset(-12 * defaultScale)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
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
