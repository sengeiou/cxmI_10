//
//  BasketballHunhePlayPopItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballHunhePlayPopItem: UICollectionViewCell {
    static let width : CGFloat = (screenWidth - 32 - 23 ) / 3 - 0.01
    static let height: CGFloat = 38
    
    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var LeftLine: UIView!
    @IBOutlet weak var rightLine : UIView!
    @IBOutlet weak var bottomLine : UIView!
    
    @IBOutlet weak var title : UILabel!
    
    public var index : Int!
}

extension BasketballHunhePlayPopItem {
    
    public func configureViewModel(with data : BBCellModel?, isShow : Bool) {
        guard let data = data else { return }
        _ = data.isSelected.asObserver()
            .subscribe { [weak self](event) in
                guard let se = event.element else { return }
                
                switch se {
                case true :
                    self?.title.textColor = ColorFFFFFF
                    self?.title.backgroundColor = ColorEA5504
                case false :
                    self?.title.textColor = Color505050
                    self?.title.backgroundColor = ColorFFFFFF
                }
        }
    }
    
    public func configure(with data : BasketballPlayCellInfo?, isShow : Bool) {
        
        switch isShow {
        case false :
            
            let att = NSAttributedString(string: "未开售")
            
            title.attributedText = att
        case true :
            guard let data = data else { return }
            let nameAtt = NSMutableAttributedString(string: data.cellName,
                                                    attributes: [NSAttributedStringKey.foregroundColor: Color505050,
                                                                 NSAttributedStringKey.font : Font14])
            let oddAtt = NSAttributedString(string: data.cellOdds,
                                            attributes: [NSAttributedStringKey.foregroundColor: Color9F9F9F,
                                                         NSAttributedStringKey.font : Font12])
            nameAtt.append(oddAtt)
            title.attributedText = nameAtt
        }
        
        
        
    }
}
