//
//  OrderSchemeCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderSchemeCell: UITableViewCell {

    public var schemeDetail : SchemeDetail! {
        didSet{
            
            let contents = schemeDetail.tickeContent.components(separatedBy: "X")
            
            var str = ""
            for content in contents {
                str += content + "\n"
            }
            str.removeLast()
            
            numLB.text = schemeDetail.number
            contentLB.text = str
            passLB.text = schemeDetail.passType
            multipleLB.text = schemeDetail.multiple
        }
    }
    
    public var ishidenLine : Bool! {
        didSet{
            if ishidenLine == true {
                self.line.isHidden = true
            }else {
                self.line.isHidden = false
            }
        }
    }
    
    private var line : UIImageView!
    private var numLB : UILabel!
    private var contentLB: UILabel!
    private var passLB: UILabel!
    private var multipleLB: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        ishidenLine = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    private func initSubview() {
        
        
        line = UIImageView()
        line.image = UIImage(named:"line")
        
        numLB = getDetailLB()
        numLB.textAlignment = .center
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
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        numLB.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLB.snp.centerY)
            make.width.equalTo(OrderDetailTitleWidth - 20)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.height.equalTo(20)
        }
        contentLB.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(numLB.snp.right).offset(1)
            make.right.equalTo(passLB.snp.left).offset(-1)
            make.bottom.equalTo(self.contentView).offset(-11)
        }
        passLB.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLB.snp.centerY)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(multipleLB.snp.left).offset(-15)
        }
        multipleLB.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLB.snp.centerY)
            make.height.width.equalTo(passLB)
            make.width.equalTo(OrderDetailTitleWidth - 14 )
            make.right.equalTo(self.contentView).offset(-33)
        }
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
