//
//  DaletouHistoryAwardCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DaletouHistoryAwardCell: UITableViewCell {

    static let identifier = "DaletouHistoryAwardCell"
    
    private var title: UILabel!
    
    private var red1 : UILabel!
    private var red2 : UILabel!
    private var red3 : UILabel!
    private var red4 : UILabel!
    private var red5 : UILabel!
    
    private var blue1: UILabel!
    private var blue2: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    
    
    private func initSubview() {
        self.selectionStyle = .none
        
        title = getLabel()
        title.font = Font13
        title.textAlignment = .left
        title.textColor = Color787878
        title.text = "20180801期"
        
        red1 = getLabel()
        red2 = getLabel()
        red3 = getLabel()
        red4 = getLabel()
        red5 = getLabel()
        
        blue1 = getLabel()
        blue1.textColor = Color0081CC
        blue2 = getLabel()
        blue2.textColor = Color0081CC
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(red1)
        self.contentView.addSubview(red2)
        self.contentView.addSubview(red3)
        self.contentView.addSubview(red4)
        self.contentView.addSubview(red5)
        self.contentView.addSubview(blue1)
        self.contentView.addSubview(blue2)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(80)
        }
        red1.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(30)
            make.left.equalTo(title.snp.right).offset(10)
        }
        red2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(red1.snp.right).offset(5)
        }
        red3.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(red2.snp.right).offset(5)
        }
        red4.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(red3.snp.right).offset(5)
        }
        red5.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(red4.snp.right).offset(5)
        }
        blue1.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(red5.snp.right).offset(5)
        }
        blue2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(red1)
            make.left.equalTo(blue1.snp.right).offset(5)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font14
        lab.textColor = ColorEB1C24
        lab.textAlignment = .center
        lab.text = "10"
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DaletouHistoryAwardCell {
    public func configure(with data : DLTHistoricalData) {
        title.text = data.termNum
        guard data.numList.count == 7 else { return }
        
        red1.text = data.numList[0]
        red2.text = data.numList[1]
        red3.text = data.numList[2]
        red4.text = data.numList[3]
        red5.text = data.numList[4]
        
        blue1.text = data.numList[5]
        blue2.text = data.numList[6]
    }
}
