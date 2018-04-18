//
//  FootballScoreCollectionCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class FootballScoreCollectionCell: UICollectionViewCell {
    
    //比分
//    public var cellSon : FootballPlayCellModel! {
//        didSet{
//            selected(cellSon.isSelected)
//            titlelb.text = cellSon.cellName
//            detaillb.text = cellSon.cellOdds
//        }
//    }
    //半全场
    public var cellInfo : FootballPlayCellModel! {
        didSet{
            selected(cellInfo.isSelected)
            titlelb.text = cellInfo.cellName
            detaillb.text = cellInfo.cellOdds
        }
    }
    
    public var isSelectedItem: Bool! {
        didSet{
            selected(isSelectedItem)
        }
    }
    
    private var titlelb : UILabel!
    private var detaillb : UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titlelb.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.right.equalTo(0)
            make.height.equalTo(detaillb)
        }
        detaillb.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titlelb.snp.bottom)
            make.bottom.equalTo(-5)
        }
    }
    private func initSubview() {
    
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        titlelb = UILabel()
        titlelb.font = Font14
        titlelb.textColor = Color505050
        titlelb.textAlignment = .center
        titlelb.text = "12"
        
        detaillb = UILabel()
        detaillb.font = Font12
        detaillb.textColor = Color9F9F9F
        detaillb.textAlignment = .center
        
        self.contentView.addSubview(titlelb)
        self.contentView.addSubview(detaillb)
    }
    
    private func selected(_ selected: Bool) {
        if selected == true {
            self.backgroundColor = ColorEA5504
            self.titlelb.textColor = ColorFFFFFF
            self.detaillb.textColor = ColorFFFFFF
        }else {
            self.backgroundColor = ColorFFFFFF
            self.titlelb.textColor = Color505050
            self.detaillb.textColor = Color9F9F9F
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
