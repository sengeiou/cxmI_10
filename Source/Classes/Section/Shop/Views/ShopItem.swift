//
//  ShopItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ShopItem: UICollectionViewCell {
    static let identifier : String = "ShopItem"
    static let spacing : CGFloat = 5.0
    static let width : CGFloat = (screenWidth - spacing * 2 - spacing) / 2 - 1
    static let height : CGFloat = width * 1.5
    
    @IBOutlet weak var icon : UIImageView!   // 商品图片
    @IBOutlet weak var goodsName: UILabel!   // 商品名称
    @IBOutlet weak var goodsPrice : UILabel! // 商品价格
    @IBOutlet weak var hisPrice : UILabel!   // 历史价格
    @IBOutlet weak var salesNum : UILabel!   // 销量
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
}

extension ShopItem {
    public func configure(with data : GoodsListModel) {
        if let url = URL(string: data.mainPic) {
            icon.kf.setImage(with: url)
        }
        goodsName.text = data.description
        goodsPrice.text = "¥ " + data.presentPrice
        salesNum.text = data.paidNum + "人付款"
        
        let historyPrice = NSMutableAttributedString(string: "¥ \(data.historyPrice)" , attributes: [NSAttributedStringKey.strikethroughStyle : 1])
        
        hisPrice.attributedText = historyPrice
    }
}

extension ShopItem {
    private func initSubview() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = ColorEDEDED.cgColor
    }
}
