//
//  FootballOddsCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOddsCell: UITableViewCell {

    public var homelb : UILabel!
    public var flatlb : UILabel!
    private var oddslb : UILabel!
    private var company : UILabel!
    private var visilb : UILabel!
    private var topLine : UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        company.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(5 * defaultScale)
            make.width.equalTo(72 * defaultScale)
        }
        oddslb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.left.equalTo(company.snp.right)
            make.right.equalTo(homelb.snp.left)
        }
        homelb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.width.equalTo(40 * defaultScale)
            make.left.equalTo(company.snp.right).offset(80 * defaultScale)
        }
        flatlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.left.equalTo(homelb.snp.right)
            make.right.equalTo(visilb.snp.left)
        }
        visilb.snp.makeConstraints { (make) in
            make.width.equalTo(homelb)
            make.right.equalTo(-16 * defaultScale)
            make.top.bottom.equalTo(company)
        }
    }
    private func initSubview() {
        topLine = UIImageView()
        topLine.image = UIImage(named: "line")
        
        company = getLabel("公司")
        oddslb = getLabel("初赔\n即赔")
        oddslb.numberOfLines = 0
        homelb = getLabel("胜")
        flatlb = getLabel("平")
        visilb = getLabel("负")
        
        self.addSubview(topLine)
        self.addSubview(company)
        self.addSubview(homelb)
        self.addSubview(flatlb)
        self.addSubview(visilb)
        self.addSubview(oddslb)
    }
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.text = title
        lab.font = Font12
        lab.textColor = Color9F9F9F
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
