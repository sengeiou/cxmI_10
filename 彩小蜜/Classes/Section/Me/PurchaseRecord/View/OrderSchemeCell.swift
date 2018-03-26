//
//  OrderSchemeCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderSchemeCell: UITableViewCell {

    
    private var line : UIImageView!
    private var numLB : UILabel!
    private var contentLB: UILabel!
    private var passLB: UILabel!
    private var multipleLB: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        numLB.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(11)
            make.bottom.equalTo(self.contentView).offset(-11)
            make.width.equalTo(OrderDetailTitleWidth)
            make.left.equalTo(self.contentView).offset(leftSpacing)
        }
        contentLB.snp.makeConstraints { (make) in
            make.top.equalTo(numLB)
            make.left.equalTo(numLB.snp.right).offset(1)
            make.right.equalTo(passLB.snp.left).offset(-1)
            make.bottom.equalTo(numLB)
        }
        passLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(numLB)
            make.right.equalTo(multipleLB.snp.left).offset(-1)
        }
        multipleLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(numLB)
            make.right.equalTo(self.contentView).offset(-26)
        }
    }

    private func initSubview() {
        line = UIImageView()
        line.image = UIImage(named:"line")
        
        numLB = getDetailLB()
        numLB.textAlignment = .left
        contentLB = getDetailLB()
        contentLB.numberOfLines = 0
        
        passLB = getDetailLB()
        multipleLB = getDetailLB()
        multipleLB.textAlignment = .right

        
        self.contentView.addSubview(line)
        self.contentView.addSubview(numLB)
        self.contentView.addSubview(contentLB)
        self.contentView.addSubview(passLB)
        self.contentView.addSubview(multipleLB)
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.text = "白塞"
        lab.textColor = Color505050
        lab.textAlignment = .center
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
