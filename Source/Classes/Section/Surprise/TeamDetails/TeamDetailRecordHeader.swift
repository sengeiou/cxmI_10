//
//  TeamDetailRecordHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailRecordHeader: UITableViewHeaderFooterView {

    static let identifier = "TeamDetailRecordHeader"
    
    private var title : UILabel!
    
    private var topLine : UIView!
    private var bottomLine : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorFFFFFF
        initSubview()
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font12
        title.textAlignment = .left
        
        topLine = UIView()
        topLine.backgroundColor = ColorF4F4F4
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorF4F4F4
        
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(title)
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(topLine.snp.bottom)
            make.bottom.equalTo(bottomLine.snp.top)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamDetailRecordHeader {
    public func configure(with data : TeamRecoreDetail) {
        let muAtt = NSMutableAttributedString(string: "最近战绩",
                                              attributes :[NSAttributedString.Key.foregroundColor: Color505050,
                                                           NSAttributedString.Key.font : Font14])
        
        let countAtt = NSAttributedString(string: " \(data.matchCount)场比赛",
            attributes: [NSAttributedString.Key.foregroundColor : Color787878,
                         NSAttributedString.Key.font : Font12])
        
        let teamAtt = NSAttributedString(string: " \(data.homeTeam)",
            attributes: [NSAttributedString.Key.foregroundColor: Color787878,
                         NSAttributedString.Key.font : Font12])
        
        let winAtt = NSAttributedString(string: " \(data.win)胜",
            attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504,
                         NSAttributedString.Key.font : Font12])
        
        let flatAtt = NSAttributedString(string: "\(data.flat)平",
            attributes: [NSAttributedString.Key.foregroundColor: Color6CD6C4,
                         NSAttributedString.Key.font : Font12])
        let losAtt = NSAttributedString(string: "\(data.negative)负",
            attributes: [NSAttributedString.Key.foregroundColor: Color44AE35,
                         NSAttributedString.Key.font : Font12])
        
        muAtt.append(countAtt)
        muAtt.append(teamAtt)
        muAtt.append(winAtt)
        muAtt.append(flatAtt)
        muAtt.append(losAtt)
        
        title.attributedText = muAtt
        
    }
}
