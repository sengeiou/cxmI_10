//
//  FootballPlayFilterCell.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballPlayFilterCell: UICollectionViewCell {
    public var filterModel : FootballPlayFilterModel! {
        didSet{
            guard filterModel != nil else { return }
            selected(filterModel.isSelected)
            title.text = filterModel.title
        }
    }
    
    public var isSelectedItem: Bool! {
        didSet{
            guard isSelectedItem != nil else { return }
            selected(isSelectedItem)
        }
    }
    
    private var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
        //isSelectedItem = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    private func initSubview() {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = ColorC8C8C8.cgColor
        self.backgroundColor = ColorFFFFFF
        
        title = UILabel()
        title.font = Font12
        title.textColor = Color505050
        title.textAlignment = .center
        
        self.contentView.addSubview(title)
    }
    
    private func selected(_ selected: Bool) {
        
        if selected == true {
            self.layer.borderColor = ColorEA5504.cgColor
            self.title.textColor = ColorEA5504
        }else {
            self.layer.borderColor = ColorC8C8C8.cgColor
            self.title.textColor = Color505050
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
